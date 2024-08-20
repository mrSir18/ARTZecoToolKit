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
    
    
    // MARK: - Life Cycle
    
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
        // 子类重写: 此方法以自定义网络状态视图
    }
    
    open func setupNavigationBarView() {
        // 子类重写: 此方法以自定义导航栏视图
        navigationBarView = ARTWebNavigationBarView(self)
        view.addSubview(navigationBarView)
        navigationBarView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(art_navigationFullHeight())
        }
    }
    
    open func setupWebView() {
        // 子类重写: 此方法以自定义 WebView
        webView = ARTWebView(self)
        view.addSubview(webView)
        view.sendSubviewToBack(webView)
        webView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(navigationBarView.snp.bottom)
        }
    }
    
    open func setupProgressBarView() {
        // 子类重写: 此方法以自定义进度条视图
        progressBarView = ARTProgressBarView(self)
        view.addSubview(progressBarView)
        progressBarView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(webView)
            make.height.equalTo(2.0)
        }
    }
    
    open func setupLoadwebView() {
        // 子类重写: 此方法以自定义加载 WebView
        if let url = url { webView.loadURL(url) }
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

// MARK: - Public Methods

extension ARTWebViewController {
    
    /// 加载 URL
    /// - Parameter url: URL 地址
    @objc open func loadURL(_ url: String) {
        if url.isEmpty { return }
        webView.loadURL(url)
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

extension ARTWebViewController: ARTWebViewDelegate {
    
    open func webviewCustomCookies() -> [String : String] { /// 获取自定义的 Cookie 字典
        return customCookies
    }
    
    open func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.title = "加载中..."
    }
    
    open func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.title = ""
        webView.evaluateJavaScript("document.cookie") { result, error in
            if let cookies = result as? String {
                // 用换行符替代分隔符，使得每个 cookie 另起一行
                let formattedCookies = cookies.replacingOccurrences(of: "; ", with: "\n")
                print("网页中的 cookies 为：\n\(formattedCookies)")
            } else if let error = error {
                print("获取 cookies 时发生错误：\(error.localizedDescription)")
            }
        }
    }
    
    open func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Handle completion
    }
    
    open func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.title = ""
        print("======sssss")
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
        navigationController?.popViewController(animated: true)
    }
    
    open func shouldHideNavigationBar(for navigationBar: ARTWebNavigationBarView) -> Bool { // 是否隐藏导航栏
        return false
    }
    
    open func navigationBarBackgroundColor(for navigationBar: ARTWebNavigationBarView) -> UIColor { /// 导航栏背景颜色
        return .art_randomColor()
    }
    
    open func navigationBarAlpha(for navigationBar: ARTWebNavigationBarView) -> CGFloat { /// 导航栏透明度
        return 1.0
    }
    
    open func shouldFollowScrollView(for navigationBar: ARTWebNavigationBarView) -> Bool { /// 是否跟随滚动
        return false
    }
    
    open func backButtonImageName(for navigationBar: ARTWebNavigationBarView) -> String? { /// 返回按钮图片名称
        return "back_black_left"
    }
    
    open func shouldHideBackButton(for navigationBar: ARTWebNavigationBarView) -> Bool { /// 是否隐藏返回按钮
        return false
    }
    
    open func titleContent(for navigationBar: ARTWebNavigationBarView) -> String { /// 标题内容
        return "成长智库"
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
