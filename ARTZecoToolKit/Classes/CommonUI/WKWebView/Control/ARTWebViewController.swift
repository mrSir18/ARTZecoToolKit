//
//  ARTWebViewController.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/8/20.
//

// TODO: 若想获取网页内容高度，外部自行注册 jsMethodNames = [webViewContentHeight] 即可。

@preconcurrency import WebKit

open class ARTWebViewController: UIViewController {
    
    /// 导航栏视图
    public var navigationBarView: ARTWebNavigationBar!
    
    /// WebView视图
    public var webView: ARTWebView!
    
    /// 工具栏视图
    public var toolbar: ARTWebToolbar!
    
    /// 进度条视图
    public var progressBarView: ARTWebProgressBar!
    
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
    
    /// 是否隐藏导航栏  默认为 `false`
    public var shouldHideNavigationBar: Bool = false
    
    /// 是否隐藏工具栏  默认为 `false`
    public var shouldHideToolbar: Bool = false
    
    /// 自定义 JS 方法名数组
    public var jsMethodNames: [String] = []
    
    /// 动态注入的 JS 脚本数组
    public var dynamicScripts: [String] = []
    
    /// 接收到脚本消息的回调
    public var didReceiveScriptMessage: ((ARTScriptMessage) -> Void)?
    
    /// 脚本消息处理代理
    public lazy var scriptMessageDelegate: ARTScriptMessageHandlerDelegate = {
        return ARTScriptMessageHandlerDelegate(self)
    }()
    
    /// 退出控制器完成回调
    public var dismissCompletion: (() -> Void)?
    
    
    // MARK: - Private Properties
    
    /// 激活链接  隐藏工具栏  默认为 `true`
    private var isLinkActivated: Bool = true
    
    /// 上次滚动位置
    private var lastContentOffset: CGFloat = 0.0
    
    /// WebView 内容高度
    private let webViewContentHeight = "webViewContentHeight"
    
    
    // MARK: - Initialization
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupNavigationBarView()
        setupWebView()
        setupToolBarView()
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
        let height = shouldHideNavigationBar ? 0 : art_navigationFullHeight()
        navigationBarView = ARTWebNavigationBar(self)
        navigationBarView.isHidden = shouldHideNavigationBar
        view.addSubview(navigationBarView)
        navigationBarView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(height)
        }
    }
    
    open func setupWebView() {
        /// 子类重写: 此方法以自定义 WebView
        webView = ARTWebView(self)
        webView.executeJavaScripts(dynamicScripts)
        view.addSubview(webView)
        view.sendSubviewToBack(webView)
        webView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(navigationBarView?.snp.bottom ?? view.snp.top)
        }
    }
    
    open func setupToolBarView() {
        /// 子类重写: 此方法以自定义工具栏视图
        toolbar = ARTWebToolbar(self)
        toolbar.isHidden = shouldHideToolbar
        view.addSubview(toolbar)
        toolbar.snp.makeConstraints { make in
            make.size.equalTo(ARTAdaptedSize(width: 132.0, height: 66.0))
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-art_safeAreaBottom())
        }
    }
    
    open func setupProgressBarView() {
        /// 子类重写: 此方法以自定义进度条视图
        progressBarView = ARTWebProgressBar(self)
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
        webView.addObserver(self, forKeyPath: "canGoForward", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "canGoBack", options: .new, context: nil)
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
        case #keyPath(WKWebView.estimatedProgress): /// 监听 WebView 的 estimatedProgress 属性
            DispatchQueue.main.async {
                let progress = Float(webView.estimatedProgress)
                self.progressBarView.setProgress(progress, animated: true) { /// 当进度达到 100% 时隐藏进度条
                    if progress >= 1.0 { self.progressBarView.isHidden = true }
                }
            }
        case #keyPath(WKWebView.title): /// 监听 WebView 的 title 属性
            DispatchQueue.main.async {
                if self.shouldAutoFetchTitle { /// 自动获取标题
                    self.navigationBarView?.updateTitleContent(webView.title ?? "")
                }
            }
        case #keyPath(WKWebView.canGoBack), #keyPath(WKWebView.canGoForward): /// 监听 WebView 的 canGoBack 和 canGoForward 属性
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return  }
                if self.shouldHideToolbar { return }
                self.isLinkActivated = true
                self.toolbar.updateToolButtonsState(canGoBack: webView.canGoBack, canGoForward: webView.canGoForward) /// 更新工具栏按钮状态
            }
        default: /// 调用父类的 observeValue 方法处理其他情况
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    /// 移除观察者
    open func unregisterWebViewObservers() {
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.title))
        webView.removeObserver(self, forKeyPath: "canGoForward")
        webView.removeObserver(self, forKeyPath: "canGoBack")
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

// MARK: - Private Methods

extension ARTWebViewController {
    
    /// 获取 WebView 内容高度
    private func createHeightObserverScript(_ webView: WKWebView, completion: @escaping (CGFloat) -> Void) {
        if jsMethodNames.contains(webViewContentHeight) { /// 如果注册了获取 WebView 内容高度的方法，则执行该方法
            let js = """
                Math.max(
                    document.body.scrollHeight,
                    document.documentElement.scrollHeight,
                    document.body.offsetHeight,
                    document.documentElement.offsetHeight,
                    document.documentElement.clientHeight
                )
            """
            webView.evaluateJavaScript(js) { result, error in
                completion((result as? CGFloat) ?? 0)
            }
        }
    }
}

extension ARTWebViewController: WKScriptMessageHandler {
    
    open func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) { /// 接收到脚本消息
        let scriptMessage = convertToCustomScriptMessage(from: message)
        didReceiveScriptMessage?(scriptMessage)
    }
    
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        ARTAlertController.showAlertController(title: "提示",
                                               message: message,
                                               preferredStyle: .alert,
                                               buttonTitles: ["确定", "取消"],
                                               buttonStyles: [.default, .cancel], in: self) { mode in
            switch mode {
            case .first, .second:
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
    
    open func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation) { /// 开始加载网页
        print("开始加载网页: \(webView.url?.absoluteString ?? "")")
    }
    
    open func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) { /// 获取网页中的 cookies
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
        createHeightObserverScript(webView) { [weak self] height in // 获取 WebView 内容高度
            let scriptMessage = ARTScriptMessage(body: height,
                                                 webView: self?.webView,
                                                 name: "webViewContentHeight")
            self?.didReceiveScriptMessage?(scriptMessage)
        }
    }
    
    open func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) { /// 网页加载失败
        print("网页加载失败: \(error.localizedDescription)")
    }
    
    open func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) { /// 网页加载失败
        print("网页加载失败: \(error.localizedDescription)")
    }
    
    open func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) { /// 拦截导航请求，检测用户是否点击了链接，用于调整工具栏透明度
        guard navigationAction.navigationType == .linkActivated, !shouldHideToolbar else {
            decisionHandler(.allow)
            return
        }
        isLinkActivated = true
        toolbar.alpha = 1.0
        webView.evaluateJavaScript("window.scrollY") { [weak self] result, error in /// 获取当前滚动位置
            guard let self = self else { return }
            if let scrollY = result as? Double {
                lastContentOffset = CGFloat(scrollY)
            }
            resetLinkActivationFlag(after: 1.0) /// 重置 isLinkActivated
        }
        decisionHandler(.allow)
    }
}

// MARK: - UIScrollViewDelegate

extension ARTWebViewController {
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        /// 根据滚动位置调整顶底栏透明度
        let navigationAlpha = min(max(currentOffset / 100.0, 0), 1.0)
        navigationBarView?.updateNavigationBarAlpha(navigationAlpha)
        
        /// 如果用户点击了链接，则不调整工具栏透明度
        if isLinkActivated { return }
        if currentOffset <= 0 { /// 当滚动位置小于等于0时，工具栏保持完全可见
            if toolbar.alpha != 1.0 { animateToolbarAlpha(to: 1.0) }
            return
        }
        
        /// 根据滚动方向调整工具栏透明度
        let targetAlpha: CGFloat = currentOffset > lastContentOffset ? 0.0 : 1.0
        if toolbar.alpha != targetAlpha {
            animateToolbarAlpha(to: targetAlpha)
        }
        lastContentOffset = currentOffset
    }
    
    private func animateToolbarAlpha(to alpha: CGFloat) { /// 动画调整工具栏透明度
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: [], animations: {
            self.toolbar.alpha = alpha
        }, completion: nil)
    }
    
    private func resetLinkActivationFlag(after seconds: TimeInterval) { /// 重置 isLinkActivated
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.isLinkActivated = false
        }
    }
}

// MARK: - ARTWebNavigationBarProtocol

extension ARTWebViewController: ARTWebNavigationBarProtocol {
    
    open func navigationBarDidTapBackButton(_ navigationBar: ARTWebNavigationBar) { /// 点击返回按钮
        if presentingViewController != nil {
            dismiss(animated: true, completion: dismissCompletion)
        } else {
            popViewControllerWithCompletion(dismissCompletion)
        }
    }
    
    open func shouldHideNavigationBar(for navigationBar: ARTWebNavigationBar) -> Bool { // 是否隐藏导航栏
        return false
    }
    
    open func navigationBarBackgroundColor(for navigationBar: ARTWebNavigationBar) -> UIColor { /// 导航栏背景颜色
        return .white
    }
    
    open func navigationBarAlpha(for navigationBar: ARTWebNavigationBar) -> CGFloat { /// 导航栏透明度
        return 1.0
    }
    
    open func shouldFollowScrollView(for navigationBar: ARTWebNavigationBar) -> Bool { /// 是否跟随滚动
        return false
    }
    
    open func backButtonImageName(for navigationBar: ARTWebNavigationBar) -> String? { /// 返回按钮图片名称
        return backButtonImageName
    }
    
    open func shouldHideBackButton(for navigationBar: ARTWebNavigationBar) -> Bool { /// 是否隐藏返回按钮
        return false
    }
    
    open func titleContent(for navigationBar: ARTWebNavigationBar) -> String { /// 标题内容
        return navigationBarTitle
    }
    
    open func titleFont(for navigationBar: ARTWebNavigationBar) -> UIFont { /// 标题字体
        return .art_medium(ARTAdaptedValue(17.0)) ?? .systemFont(ofSize: 17.0)
    }
    
    open func titleColor(for navigationBar: ARTWebNavigationBar) -> UIColor { /// 标题颜色
        return .art_color(withHEXValue: 0x000000)
    }
    
    open func customRightView(for navigationBar: ARTWebNavigationBar) -> UIView? { /// 自定义右侧视图
        return nil
    }
}

// MARK: - ARTWebToolbarProtocol

extension ARTWebViewController: ARTWebToolbarProtocol {
    
    open func toolbar(_ toolbar: ARTWebToolbar, didTapGoBackButton button: UIButton) { /// 点击返回按钮
        webView.goBack()
        resetLinkActivationFlag(after: 1.0) /// 重置 isLinkActivated
    }
    
    open func toolbar(_ toolbar: ARTWebToolbar, didTapGoForwardButton button: UIButton) { /// 点击前进按钮
        webView.goForward()
        resetLinkActivationFlag(after: 1.0) /// 重置 isLinkActivated
    }
}

// MARK: - ARTWebProgressBarProtocol

extension ARTWebViewController: ARTWebProgressBarProtocol {
    
    open func tintColor(for progressBar: ARTWebProgressBar) -> UIColor { /// 进度条的颜色
        return .art_color(withHEXValue: 0xFE5C01)
    }
    
    open func shouldHideProgressBar(for progressBar: ARTWebProgressBar) -> Bool { /// 是否隐藏进度条
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
