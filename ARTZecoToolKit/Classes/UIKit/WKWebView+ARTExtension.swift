//
//  WKWebView+ARTExtension.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/9/22.
//

import WebKit

extension WKWebView {
    
    /// 预加载空白的 WKWebView
    public static func preload() {
        let webView = WKWebView()
        webView.load(URLRequest(url: URL(string: "about:blank")!))
    }
}
