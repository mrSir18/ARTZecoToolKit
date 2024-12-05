//
//  ARTWebView.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/8/20.
//

import WebKit

public class ARTWebView: WKWebView {
    
    // MARK: - Initialization
    
    public convenience init(_ delegate: ARTWebViewDelegate) {
        WKWebView.loadSwizzling()
        
        /// 配置 WKWebView
        let configuration = ARTWebView.createWebViewConfiguration()
        
        /// 调用父类的指定初始化方法
        self.init(frame: .zero, configuration: configuration)
        
        /// 设置视图属性和代理
        setupWebViewProperties(delegate: delegate)
        
        /// 开启自定义 Cookie
        setupCustomCookies()
    }
    
    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Private Methods
    
    /// 配置 WebView 的属性
    private func setupWebViewProperties(delegate: ARTWebViewDelegate) {
        self.translatesAutoresizingMaskIntoConstraints  = false
        self.scrollView.showsHorizontalScrollIndicator  = false
        self.scrollView.showsVerticalScrollIndicator    = false
        self.allowsBackForwardNavigationGestures        = true
        self.scrollView.contentInsetAdjustmentBehavior  = .never
        self.scrollView.scrollIndicatorInsets           = .zero
        self.scrollView.contentInset = .zero
        self.scrollView.bounces      = false
        self.navigationDelegate      = delegate
        self.uiDelegate              = delegate
        self.cookieDelegate          = delegate
        self.scrollView.delegate     = delegate
        self.backgroundColor         = .white
    }
    
    /// 创建 WebView 的配置
    private static func createWebViewConfiguration() -> WKWebViewConfiguration {
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = WKUserContentController()
        
        // 配置基础获取高度的 JavaScript 脚本
        let userScript = createHeightObserverScript()
        configuration.userContentController.addUserScript(userScript)
        
        // 设置偏好配置
        let preferences = WKPreferences()
        preferences.javaScriptCanOpenWindowsAutomatically = true
        configuration.preferences = preferences
        
        return configuration
    }
    
    /// 创建 JavaScript 脚本
    private static func createHeightObserverScript() -> WKUserScript {
        let scriptSource = """
        // 定义通知高度的函数
        function notifyHeight() {
            const height = Math.max(
                document.body.scrollHeight,
                document.documentElement.scrollHeight,
                document.body.offsetHeight,
                document.documentElement.offsetHeight,
                document.documentElement.clientHeight
            );
            window.webkit.messageHandlers.webViewContentHeight.postMessage(height);
        }
        
        // 页面加载完成后获取高度
        window.onload = function() {
            notifyHeight();
        };
        
        // 监听 DOM 内容变化（动态支持）
        const observer = new MutationObserver(function() {
            notifyHeight();
        });
        observer.observe(document.body, { childList: true, subtree: true });
        """
        return WKUserScript(
            source: scriptSource,
            injectionTime: .atDocumentEnd,
            forMainFrameOnly: true
        )
    }
}

extension ARTWebView {
    
    // MARK: - Dynamic JavaScript Injection
    
    /// 动态添加 JavaScript 脚本。
    ///
    /// - Parameters:
    ///   - script: JavaScript 脚本内容。
    ///   - injectionTime: 注入时间，默认为 `.atDocumentEnd`。
    ///   - forMainFrameOnly: 是否仅针对主框架，默认为 `true`。
    public func addJavaScript(_ script: String, injectionTime: WKUserScriptInjectionTime = .atDocumentEnd, forMainFrameOnly: Bool = true) {
        let userScript = WKUserScript(source: script, injectionTime: injectionTime, forMainFrameOnly: forMainFrameOnly)
        configuration.userContentController.addUserScript(userScript)
    }
    
    /// 移除所有动态添加的 JavaScript 脚本。
    public func removeAllJavaScript() {
        configuration.userContentController.removeAllUserScripts()
        
        // 重新添加默认的脚本
        let defaultScript = ARTWebView.createHeightObserverScript()
        configuration.userContentController.addUserScript(defaultScript)
    }
    
    /// 添加多个 JavaScript 脚本
    public func addJavaScripts(_ scripts: [String]) {
        scripts.forEach { addJavaScript($0) }
    }
}

extension ARTWebView {
    
    // MARK: - Public Methods
    
    /// 加载本地 HTML 文件。
    ///
    /// - Parameters:
    ///   - fileName: HTML 文件的名称（不包括扩展名）。
    ///   - bundle: 包含 HTML 文件的 Bundle，默认为主 Bundle。
    public func loadLocalHTML(fileName: String, bundle: Bundle = .main) {
        guard let fileURL = bundle.url(forResource: fileName, withExtension: "html") else {
            print("HTML file not found: \(fileName).html")
            return
        }
        loadRequest(with: fileURL)
    }
    
    /// 加载网络 URL。
    ///
    /// - Parameter urlString: 网络 URL 的字符串表示。
    public func loadURL(_ urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            print("Invalid URL string: \(String(describing: urlString))")
            return
        }
        loadRequest(with: url)
    }
    
    /// 使用给定的 URL 创建并加载请求。
    ///
    /// - Parameter url: 要加载的 URL。
    private func loadRequest(with url: URL) {
        let request = URLRequest(url: url,
                                 cachePolicy: .reloadIgnoringLocalCacheData,
                                 timeoutInterval: 30.0)
        load(request)
    }
}
