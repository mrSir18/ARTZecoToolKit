//
//  ARTViewController+WebView.swift
//  ARTZecoToolKit_Example
//
//  Created by mrSir18 on 2024/8/19.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import ARTZecoToolKit

class ARTViewController_WebView: ARTBaseViewController {

    // MARK: - Life Cycle
    
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
        webViewController.customCookies = [
            "11111": "GarrettGao",
            "66666": "WkCookie"
        ]
        webViewController.url = "https://www.baidu.com"
        self.navigationController?.pushViewController(webViewController, animated: true)
    }
    
    @objc func customButtonAction () {
        let webViewController = ARTWebCustomViewController()
        self.navigationController?.pushViewController(webViewController, animated: true)
    }
}
