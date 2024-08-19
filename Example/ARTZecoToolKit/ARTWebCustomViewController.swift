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
        createButtons()
        loadURL("https://www.zecoart.com")
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
    
    @objc func addCookieButtonAction () {
        print("随机添加Cookie")
        //        cookieDict["33333"] = "MiaoEr"
        //        cookieDict["44444"] = "MiaoErCookie"
        //        webView.refreshCookies()
        //        webView.reload()
    }
    
    @objc func deleteCookieButtonAction () {
        print("删除Cookie")
        //        cookieDict.removeValue(forKey: "44444")
        //        webView.refreshCookies()
        //        webView.reload()
        //    }
    }

    override func backButtonImageName(for navigationBar: ARTWebNavigationBarView) -> String? {
        return "navigation_back_black"
    }
}
