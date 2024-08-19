//
//  ARTWebView.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/8/20.
//

import WebKit

public class ARTWebView: WKWebView {
    
    // MARK: - Life Cycle
   
    public convenience init(_ delegate: ARTWebViewDelegate) {
        WKWebView.loadSwizzling()
        
        /// 配置 WKWebView
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = WKUserContentController()

        let preferences = WKPreferences()
        preferences.javaScriptCanOpenWindowsAutomatically = true
        configuration.preferences = preferences
        
        /// 调用父类的指定初始化方法
        self.init(frame: .zero, configuration: configuration)
        
        /// 设置视图属性和代理
        self.translatesAutoresizingMaskIntoConstraints  = false
        self.scrollView.showsHorizontalScrollIndicator  = false
        self.scrollView.showsVerticalScrollIndicator    = false
        self.allowsBackForwardNavigationGestures        = true
        self.scrollView.contentInsetAdjustmentBehavior  = .never
        self.navigationDelegate = delegate
        self.uiDelegate         = delegate
        self.cookieDelegate     = delegate
        self.backgroundColor    = .white
        
        /// 开启自定义 Cookie
        self.setupCustomCookies()
    }

    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension ARTWebView {
    
    // MARK: - Public Methods
    
    /// 加载本地 HTML 文件。
    /// - Parameter fileName: 要加载的 HTML 文件名（不包含扩展名）。
    /// - Parameter bundle: 包含 HTML 文件的 `Bundle`，默认为主 Bundle。
    public func loadLocalHTML(fileName: String, bundle: Bundle = .main) {
        guard let fileURL = bundle.url(forResource: fileName, withExtension: "html") else {
            print("HTML file not found: \(fileName).html")
            return
        }
        let request = URLRequest(url: fileURL)
        self.load(request)
    }
    
    /// 加载网络 URL。
    /// - Parameter urlString: 网络 URL 的字符串表示。
    public func loadURL(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL string: \(urlString)")
            return
        }
        let request = URLRequest(url: url)
        self.load(request)
    }
}
