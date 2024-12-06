//
//  ARTViewController+WebView.swift
//  ARTZecoToolKit_Example
//
//  Created by mrSir18 on 2024/8/19.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

//import UIKit
//import WebKit
//import ARTZecoToolKit
//
//class ARTViewController_WebView: ARTBaseViewController, WKUIDelegate, WKScriptMessageHandler {
//
//    var webView: WKWebView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let webConfiguration = WKWebViewConfiguration()
//        webConfiguration.preferences.javaScriptEnabled = true  // 确保 JavaScript 被启用
//        // 注册消息处理器
////        webConfiguration.userContentController.add(self, name: "testMethod")
//
//        // 初始化WKWebView
//        webView = WKWebView(frame: self.view.frame, configuration: webConfiguration)
//        webView.uiDelegate = self  // 设置 WKUIDelegate 代理
//        webView.backgroundColor = .art_randomColor()
//        self.view.addSubview(webView)
//
//        // 加载本地HTML文件
//        if let filePath = Bundle.main.path(forResource: "test", ofType: "html") {
//            let url = URL(fileURLWithPath: filePath)
//            let request = URLRequest(url: url)
//            webView.load(request)
//        }
//    }
//
//    // MARK: - Life Cycle
//
//    open override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        webView.configuration.userContentController.add(self, name: "testMethod")
//    }
//
//    open override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        webView.configuration.userContentController.removeScriptMessageHandler(forName: "testMethod")
//    }
//
//    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
//        print("接收到脚本消息：\(message.name) - \(message.body)")
//    }
//
//    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
//        // 在这里可以调用 UIAlertController 来显示 alert
//        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
//            completionHandler()
//        }))
//        self.present(alert, animated: true, completion: nil)
//    }
//}

import ARTZecoToolKit

class ARTViewController_WebView: ARTBaseViewController {
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Cookie自定义"
        createButtons()
    }
    
    private func createButtons() {
        let buttonData: [(title: String, color: UIColor)] = [
            ("默认WebView", .art_randomColor()),
            ("自定义WebView", .art_randomColor()),
            ("WebViewJS", .art_randomColor())
        ]
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        
        for (index, data) in buttonData.enumerated() {
            let button = ARTAlignmentButton(type: .custom)
            button.tag = index
            button.titleLabel?.font = .art_regular(16.0)
            button.backgroundColor = data.color
            button.setTitle(data.title, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.snp.makeConstraints { make in
                make.size.equalTo(ARTAdaptedSize(width: 150.0, height: 100.0))
            }
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
        }
    }
    
    @objc private func buttonAction(sender: UIButton) {
        print("点击了按钮：\(sender.currentTitle ?? "")")
        switch sender.tag {
        case 0:
            defaultWebViewMethod()
        case 1:
            customWebViewMethod()
        case 2:
            webViewJSMethod()
        default:
            break
        }
    }
    
    /// 默认WebView
    func defaultWebViewMethod () {
        let webViewController = ARTWebViewController()
        webViewController.jsMethodNames = ["webViewContentHeight", "testMethod", "customJumpToH5"] // 自定义 JS 方法名数组, webViewContentHeight 为获取 WebView 内容高度的方法，testMethod、customJumpToH5 为测试方法
        webViewController.shouldAutoFetchTitle = false
        webViewController.navigationBarTitle = "育儿教育我们是认真的"
        webViewController.customCookies = [
            "name": "mrSir18",
            "bundleName": "zecoart"
        ]
        webViewController.url = "https://www.zecoart.com/"
        webViewController.didReceiveScriptMessage = { message in
            print("接收到脚本消息：\(message.name) - \(message.body)")
        }
        webViewController.dismissCompletion = {
            print("退出完成")
        }
        present(webViewController, animated: true, completion: nil)
    }
    
    /// 自定义WebView
    func customWebViewMethod () {
        let script = """
        document.documentElement.style.webkitTouchCallout = 'none';
        document.documentElement.style.webkitUserSelect = 'none';
        """
        let webViewController = ARTWebCustomViewController()
        webViewController.url = "https://www.zecoart.com/privacy-policy.html"
        webViewController.configurationInjectScripts(scripts: [script], injectionType: .userScript) // 设置脚本注入 - 注入类型为 `.userScript` 时，脚本会对后续加载的页面（主框架或子框架）自动生效，无需每次手动注入
        webViewController.dismissCompletion = {
            print("退出完成")
        }
        navigationController?.pushViewController(webViewController, animated: true)
    }
    
    /// 注册JS脚本
    func webViewJSMethod() {
        let script = """
        document.documentElement.style.webkitTouchCallout = 'none';
        document.documentElement.style.webkitUserSelect = 'none';
        """
        let webViewController = ARTWebCustomViewController()
        webViewController.url = "zeco-test"
        webViewController.shouldHideNavigationBar = false // 隐藏导航栏
        webViewController.configurationInjectScripts(scripts: [script], injectionType: .evaluateJavaScript) // 设置脚本注入 - 注入类型为 `.evaluateJavaScript` 时，脚本的作用是一次 性的，不需要对后续加载
        webViewController.dismissCompletion = {
            print("退出完成")
        }
        navigationController?.pushViewController(webViewController, animated: true)
    }
}
