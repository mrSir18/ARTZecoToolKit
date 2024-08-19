//
//  ARTViewController+WebView.swift
//  ARTZecoToolKit_Example
//
//  Created by mrSir18 on 2024/8/19.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import ARTZecoToolKit
import WebKit

class ARTViewController_WebView: ARTBaseViewController {

    private var cookieDict: [String: String] = [
        "11111": "GarrettGao",
        "66666": "WkCookie"
    ]
    
    /// 按钮
    private lazy var addCookieButton: ARTAlignmentButton = {
        let button = ARTAlignmentButton(type: .custom)
        button.titleLabel?.font = .art_regular(16.0)
        button.backgroundColor  = .art_randomColor()
        button.setTitle("随机添加Cookie", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(addCookieButtonAction), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var deleteCookieButton: ARTAlignmentButton = {
        let button = ARTAlignmentButton(type: .custom)
        button.titleLabel?.font = .art_regular(16.0)
        button.backgroundColor  = .art_randomColor()
        button.setTitle("删除Cookie", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(deleteCookieButtonAction), for: .touchUpInside)
        return button
    }()
    
    
    var webView: ARTWebView!
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Cookie自定义"
        initWebView()
        
        view.addSubview(deleteCookieButton)
        deleteCookieButton.snp.makeConstraints { make in
            make.size.equalTo(ARTAdaptedSize(width: 150.0, height: 100.0))
            make.bottom.equalTo(-art_safeAreaBottom())
            make.left.equalToSuperview()
        }
        
        view.addSubview(addCookieButton)
        addCookieButton.snp.makeConstraints { make in
            make.size.equalTo(ARTAdaptedSize(width: 150.0, height: 100.0))
            make.bottom.equalTo(-art_safeAreaBottom())
            make.right.equalToSuperview()
        }
    }
    
    private func initWebView() {
        
        webView = ARTWebView(self)
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        webView.loadURL("https://www.baidu.com")
    }
    
    @objc func addCookieButtonAction () {
        print("随机添加Cookie")
        cookieDict["33333"] = "MiaoEr"
        cookieDict["44444"] = "MiaoErCookie"
        webView.refreshCookies()
        webView.reload()
    }
    
    @objc func deleteCookieButtonAction () {
        print("删除Cookie")
        cookieDict.removeValue(forKey: "44444")
        webView.refreshCookies()
        webView.reload()
    }
}

extension ARTViewController_WebView: WKUIDelegate, WKNavigationDelegate, ARTWebViewDelegate {
    
     func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
         self.title = "加载中..."
     }
     
     func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
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
     
     func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
         // Handle completion
     }
     
     func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
         self.title = ""
         print("======sssss")
     }
     
    func webviewCustomCookies() -> [String : String] {
        return cookieDict
    }
}
