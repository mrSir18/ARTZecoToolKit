//
//  ARTCustomViewController.swift
//  ARTZecoToolKit_Example
//
//  Created by mrSir18 on 2024/8/20.
//  Copyright © 2024 CocoaPods. All rights reserved.
//
import ARTZecoToolKit

class ARTWebCustomViewController: ARTWebViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        createButtons()
        
        // 自定义 Cookie
        customCookies = [
            "name": "mrSir18",
            "bundleName": "zecoart"
        ]
        // 自定义 JS 方法名数组, webViewContentHeight 为获取 WebView 内容高度的方法，testMethod、customJumpToH5 为测试方法
        jsMethodNames = ["webViewContentHeight", "testMethod", "customJumpToH5"]
        loadURL("https://www.zecoart.com/privacy-policy.html") // 加载网页
        
        /// 设置脚本消息处理代理
        didReceiveScriptMessage = { message in
            print("接收到脚本消息：\(message.name) - \(message.body)")
        }
    }
    
    private func createButtons() { // 创建测试按钮方法
        let deleteCookieButton = ARTAlignmentButton(type: .custom)
        deleteCookieButton.titleLabel?.font = .art_regular(16.0)
        deleteCookieButton.backgroundColor  = .art_randomColor()
        deleteCookieButton.setTitle("删除Cookie", for: .normal)
        deleteCookieButton.setTitleColor(.black, for: .normal)
        deleteCookieButton.addTarget(self, action: #selector(deleteCookieButtonAction), for: .touchUpInside)
        view.addSubview(deleteCookieButton)
        deleteCookieButton.snp.makeConstraints { make in
            make.size.equalTo(ARTAdaptedSize(width: 150.0, height: 100.0))
            make.bottom.equalTo(-art_safeAreaBottom())
            make.left.equalToSuperview()
        }
        
        let addCookieButton = ARTAlignmentButton(type: .custom)
        addCookieButton.titleLabel?.font = .art_regular(16.0)
        addCookieButton.backgroundColor  = .art_randomColor()
        addCookieButton.setTitle("随机添加Cookie", for: .normal)
        addCookieButton.setTitleColor(.black, for: .normal)
        addCookieButton.addTarget(self, action: #selector(addCookieButtonAction), for: .touchUpInside)
        view.addSubview(addCookieButton)
        addCookieButton.snp.makeConstraints { make in
            make.size.equalTo(ARTAdaptedSize(width: 150.0, height: 100.0))
            make.bottom.equalTo(-art_safeAreaBottom())
            make.right.equalToSuperview()
        }
    }
    
    @objc func addCookieButtonAction () { // 添加Cookie
        customCookies["sex"] = "gg"
        customCookies["age"] = "24"
        reloadWebView()
    }
    
    @objc func deleteCookieButtonAction () { // 删除Cookie
        customCookies.removeValue(forKey: "age")
        reloadWebView()
    }

    override func backButtonImageName(for navigationBar: ARTWebNavigationBar) -> String? {
        return "navigation_back_black"
    }
}
