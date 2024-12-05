//
//  ARTViewController+WebView.swift
//  ARTZecoToolKit_Example
//
//  Created by mrSir18 on 2024/8/19.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import ARTZecoToolKit

class ARTViewController_WebView: ARTBaseViewController {
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Cookie自定义"
        createButtons()
    }
    
    private func createButtons() { // 创建测试按钮方法
        let defaultButton = ARTAlignmentButton(type: .custom)
        defaultButton.titleLabel?.font = .art_regular(16.0)
        defaultButton.backgroundColor  = .art_randomColor()
        defaultButton.setTitle("默认WebView", for: .normal)
        defaultButton.setTitleColor(.black, for: .normal)
        defaultButton.addTarget(self, action: #selector(defaultButtonAction), for: .touchUpInside)
        view.addSubview(defaultButton)
        defaultButton.snp.makeConstraints { make in
            make.size.equalTo(ARTAdaptedSize(width: 150.0, height: 100.0))
            make.bottom.equalTo(-art_safeAreaBottom())
            make.left.equalToSuperview()
        }
        
        let customButton = ARTAlignmentButton(type: .custom)
        customButton.titleLabel?.font = .art_regular(16.0)
        customButton.backgroundColor  = .art_randomColor()
        customButton.setTitle("自定义WebView", for: .normal)
        customButton.setTitleColor(.black, for: .normal)
        customButton.addTarget(self, action: #selector(customButtonAction), for: .touchUpInside)
        view.addSubview(customButton)
        customButton.snp.makeConstraints { make in
            make.size.equalTo(ARTAdaptedSize(width: 150.0, height: 100.0))
            make.bottom.equalTo(-art_safeAreaBottom())
            make.right.equalToSuperview()
        }
    }
    
    @objc func defaultButtonAction () {
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
    
    @objc func customButtonAction () {
        let webViewController = ARTWebCustomViewController()
        webViewController.shouldHideNavigationBar = true // 隐藏导航栏
        webViewController.dynamicScripts = [ // 设置动态脚本示例
            "console.log('Script 1 executed');",
            "console.log('Script 2 executed');"
        ]
        webViewController.dismissCompletion = {
            print("退出完成")
        }
        navigationController?.pushViewController(webViewController, animated: true)
    }
}
