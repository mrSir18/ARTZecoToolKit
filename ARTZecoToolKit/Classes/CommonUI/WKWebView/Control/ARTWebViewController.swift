//
//  ARTWebViewController.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/8/20.
//

import WebKit

open class ARTWebViewController: UIViewController {
    
    /// 导航栏视图
    public var navigationBarView: ARTWebNavigationBarView!
    
    /// WebView视图
    public var webView: ARTWebView!
    
    /// 进度条视图
    public var progressBarView: ARTProgressBarView!
    
    /// 自定义 Cookie 字典
    public var customCookies: [String: String] = [:]
    
    /// URL 地址
    public var url: String?
    
    /// 是否自动获取网页标题  默认为 `true`
    public var shouldAutoFetchTitle: Bool = true
    
    /// 导航栏标题
    public var navigationBarTitle: String = "成长智库"
    
    /// 返回按钮图片
    public var backButtonImageName: String = "back_black_left"
    
    /// 自定义 JS 方法名数组
    public var jsMethodNames: [String] = []
    
    /// 接收到脚本消息的回调
    public var didReceiveScriptMessage: ((WKScriptMessage) -> Void)?
    
    /// 脚本消息处理代理
    public lazy var scriptMessageDelegate: ARTScriptMessageHandlerDelegate = {
        return ARTScriptMessageHandlerDelegate(self)
    }()
    
    /// 退出控制器完成回调
    public var dismissCompletion: (() -> Void)?
    
    
    // MARK: - Initialization
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupNavigationBarView()
        setupWebView()
        setupNetworkStatusView()
        setupProgressBarView()
        setupLoadwebView()
    }
    
    // MARK: - Override Setup Methods
    
    open func setupNetworkStatusView() {
        /// 子类重写: 此方法以自定义网络状态视图
    }
    
    open func setupNavigationBarView() {
        /// 子类重写: 此方法以自定义导航栏视图
        navigationBarView = ARTWebNavigationBarView(self)
        view.addSubview(navigationBarView)
        navigationBarView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(art_navigationFullHeight())
        }
    }
    
    open func setupWebView() {
        /// 子类重写: 此方法以自定义 WebView
        webView = ARTWebView(self)
        view.addSubview(webView)
        view.sendSubviewToBack(webView)
        webView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(navigationBarView.snp.bottom)
        }
    }
    
    open func setupProgressBarView() {
        /// 子类重写: 此方法以自定义进度条视图
        progressBarView = ARTProgressBarView(self)
        view.addSubview(progressBarView)
        progressBarView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(webView)
            make.height.equalTo(ARTAdaptedValue(2.0))
        }
    }
    
    open func setupLoadwebView() {
        /// 子类重写: 此方法以自定义加载 WebView
        if let url = url {
            url.hasPrefix("http") ? webView.loadURL(url) : webView.loadLocalHTML(fileName: url)
        }
    }
    
    // MARK: - Register Methods
    
    /// 添加观察者
    open func registerWebViewObservers() {
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: [.new], context: nil)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: [.new], context: nil)
    }
    
    /// 观察者回调
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath, let webView = webView else { /// 调用父类的 observeValue 方法处理其他情况
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        guard object as? WKWebView == webView else { /// 调用父类的 observeValue 方法处理其他情况
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        switch keyPath {
        case #keyPath(WKWebView.estimatedProgress): /// 更新进度条的进度
            DispatchQueue.main.async {
                let progress = Float(webView.estimatedProgress)
                self.progressBarView.setProgress(progress, animated: true) { /// 当进度达到 100% 时隐藏进度条
                    if progress >= 1.0 { self.progressBarView.isHidden = true }
                }
            }
        case #keyPath(WKWebView.title): /// 更新导航栏的标题
            DispatchQueue.main.async {
                if self.shouldAutoFetchTitle { /// 自动获取标题
                    self.navigationBarView.updateTitleContent(webView.title ?? "")
                }
            }
        default: /// 调用父类的 observeValue 方法处理其他情况
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    /// 移除观察者
    open func unregisterWebViewObservers() {
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.title))
    }
    
    /// 注册JS消息处理器到 WebView 的用户内容控制器。
    /// - Parameter scriptNames: 需要注册的JS消息处理器名称列表。
    open func registerScriptMessageHandlers(_ scriptNames: [String]) {
        scriptNames.forEach { scriptName in
            webView.configuration.userContentController.add(scriptMessageDelegate, name: scriptName)
        }
    }
    
    /// 移除已注册的JS消息处理器。
    /// - Parameter scriptNames: 需要移除的JS消息处理器名称列表。
    open func unregisterScriptMessageHandlers(_ scriptNames: [String]) {
        scriptNames.forEach { scriptName in
            webView.configuration.userContentController.removeScriptMessageHandler(forName: scriptName)
        }
    }
    
    // MARK: - Life Cycle
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.interactivePopGestureRecognizer?.delegate  = self as? UIGestureRecognizerDelegate
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        registerWebViewObservers()
        registerScriptMessageHandlers(jsMethodNames)
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterWebViewObservers()
        unregisterScriptMessageHandlers(jsMethodNames)
    }
}

// MARK: - Public Methods

extension ARTWebViewController {
    
    /// 加载 URL
    ///
    /// - Parameter url: URL 地址
    @objc open func loadURL(_ url: String) {
        if url.isEmpty { return }
        url.hasPrefix("http") ? webView.loadURL(url) : webView.loadLocalHTML(fileName: url)
    }
    
    /// 刷新 WebView
    @objc open func reloadWebView() {
        webView.refreshCookies()
        webView.reload()
    }
    
    /// 全屏显示
    @objc open func showFullScreen() {
        webView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension ARTWebViewController: WKScriptMessageHandler {
    
    open func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) { /// 接收到脚本消息
        didReceiveScriptMessage?(message)
    }
    
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        ARTAlertController.showAlertController(title: "提示",
                                               message: message,
                                               preferredStyle: .alert,
                                               buttonTitles: ["确定", "取消"],
                                               buttonStyles: [.default, .cancel], in: self) { mode in
            switch mode {
            case .first:
                completionHandler()
            default:
                break
            }
        }
    }
}

extension ARTWebViewController: ARTWebViewDelegate {
    
    open func webviewCustomCookies() -> [String : String] { /// 配置自定义 Cookie
        return customCookies
    }
    
    open func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) { /// 开始加载网页
        print("开始加载网页: \(webView.url?.absoluteString ?? "")")
    }
    
    open func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) { /// 网页内容开始返回
        webView.evaluateJavaScript("document.cookie") { result, error in
            if let cookies = result as? String { /// 用换行符替代分隔符，使得每个 cookie 另起一行
                let formattedCookies = cookies
                    .replacingOccurrences(of: "; ", with: "\n")
                    .trimmingCharacters(in: .whitespacesAndNewlines) // 去除多余的空白字符
                print("网页中的 cookies 为：\n\(formattedCookies)")
            } else if let error = error { /// 打印获取 cookies 时发生的错误
                print("获取 cookies 时发生错误：\(error.localizedDescription)")
            }
        }
    }
    
    open func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) { /// 网页加载完成
        print("网页加载完成: \(webView.title ?? "")")
    }
    
    open func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) { /// 网页加载失败
        print("网页加载失败: \(error.localizedDescription)")
    }
    
    open func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) { /// 网页加载失败
        print("网页加载失败: \(error.localizedDescription)")
    }
}

// MARK: - UIScrollViewDelegate

extension ARTWebViewController {
    open func scrollViewDidScroll(_ scrollView: UIScrollView) { // 根据滚动位置调整顶部导航栏透明度
        let offsetY = scrollView.contentOffset.y / 100.0
        let alpha = min(max(offsetY, 0), 1.0)
        navigationBarView.updateNavigationBarAlpha(alpha)
    }
}

// MARK: - ARTWebNavigationBarViewProtocol

extension ARTWebViewController: ARTWebNavigationBarViewProtocol {
    
    open func navigationBarDidTapBackButton(_ navigationBar: ARTWebNavigationBarView) { /// 点击返回按钮
        if presentingViewController != nil {
            dismiss(animated: true, completion: dismissCompletion)
        } else {
            popViewControllerWithCompletion(dismissCompletion)
        }
    }
    
    open func shouldHideNavigationBar(for navigationBar: ARTWebNavigationBarView) -> Bool { // 是否隐藏导航栏
        return false
    }
    
    open func navigationBarBackgroundColor(for navigationBar: ARTWebNavigationBarView) -> UIColor { /// 导航栏背景颜色
        return .white
    }
    
    open func navigationBarAlpha(for navigationBar: ARTWebNavigationBarView) -> CGFloat { /// 导航栏透明度
        return 1.0
    }
    
    open func shouldFollowScrollView(for navigationBar: ARTWebNavigationBarView) -> Bool { /// 是否跟随滚动
        return false
    }
    
    open func backButtonImageName(for navigationBar: ARTWebNavigationBarView) -> String? { /// 返回按钮图片名称
        return backButtonImageName
    }
    
    open func shouldHideBackButton(for navigationBar: ARTWebNavigationBarView) -> Bool { /// 是否隐藏返回按钮
        return false
    }
    
    open func titleContent(for navigationBar: ARTWebNavigationBarView) -> String { /// 标题内容
        return navigationBarTitle
    }
    
    open func titleFont(for navigationBar: ARTWebNavigationBarView) -> UIFont { /// 标题字体
        return .art_medium(ARTAdaptedValue(17.0)) ?? .systemFont(ofSize: 17.0)
    }
    
    open func titleColor(for navigationBar: ARTWebNavigationBarView) -> UIColor { /// 标题颜色
        return .art_color(withHEXValue: 0x000000)
    }
    
    open func customRightView(for navigationBar: ARTWebNavigationBarView) -> UIView? { /// 自定义右侧视图
        return nil
    }
}

// MARK: - ARTProgressBarViewProtocol

extension ARTWebViewController: ARTProgressBarViewProtocol {
    
    open func tintColor(for progressBar: ARTProgressBarView) -> UIColor { /// 进度条的颜色
        return .art_color(withHEXValue: 0xFE5C01)
    }
    
    open func shouldHideProgressBar(for progressBar: ARTProgressBarView) -> Bool { /// 是否隐藏进度条
        return false
    }
}

// MARK: - Controller Transition

extension ARTWebViewController {
    
    /// 弹出控制器
    ///
    /// - Parameters:
    ///  - completion: 完成回调
    public func popViewControllerWithCompletion(_ completion: (() -> Void)?) {
        if let coordinator = self.transitionCoordinator {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion?()
            }
        } else {
            navigationController?.popViewController(animated: true)
            DispatchQueue.main.async {
                completion?()
            }
        }
    }
}
