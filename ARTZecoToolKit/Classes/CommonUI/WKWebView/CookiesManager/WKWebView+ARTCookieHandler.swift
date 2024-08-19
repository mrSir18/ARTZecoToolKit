//
//  WKWebView+ARTCookieHandler.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/8/19.
//

import WebKit

// 用于标识与 Cookie 相关的 JavaScript 代码片段的前缀
private let cookieScriptTagPrefix = "// 用于标识与 Cookie 相关的 JavaScript 代码片段"

extension WKWebView {
    
    /// 设置自定义 Cookie 处理
    public func setupCustomCookies() {
        injectJavaScriptForCookies()
        refreshCookies()
    }
    
    /// 注入应用的 JavaScript 代码以支持 Cookie 处理
    private func injectJavaScriptForCookies() {
        // 从资源中加载名为 "GGCookie.js" 的 JavaScript 代码
        guard let javaScriptCode = ARTJavaScriptBundleLoader.loadJavaScriptCode(fileName: "ARTCookieManager", ofType: "js") else {
            return
        }
        let userScript = WKUserScript(source: javaScriptCode, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        self.configuration.userContentController.addUserScript(userScript)
    }
    
    /// 刷新所有 Cookie
    public func refreshCookies() {
        clearAllCustomCookies()
        if let delegate = cookieDelegate {
            customCookies = delegate.webviewCustomCookies()
        }
        customCookies?.forEach { key, value in
            setCookie(key: key, value: value)
        }
    }
    
    /// 设置特定的 Cookie
    public func setCookie(key: String, value: String) {
        let javaScriptCode = "app_setCookie('\(key)', '\(value)')"
        evaluateJavaScript(javaScriptCode) { result, error in
            if let error = error { print("Error setting cookie: \(error.localizedDescription)") }
        }
        let tag = generateScriptTag(forKey: key)
        removeUserScript(withTag: tag)
        addUserScript(withJavaScriptCode: javaScriptCode, tag: tag)
    }
    
    /// 移除特定的 Cookie
    public func removeCookie(key: String) {
        let javaScriptCode = "app_deleteCookie('\(key)')"
        evaluateJavaScript(javaScriptCode) { result, error in
            if let error = error { print("Error removing cookie: \(error.localizedDescription)") }
        }
        let tag = generateScriptTag(forKey: key)
        removeUserScript(withTag: tag)
    }
    
    /// 清除所有自定义 Cookie
    public func clearAllCustomCookies() {
        customCookies?.keys.forEach { key in
            let javaScriptCode = "app_deleteCookie('\(key)')"
            evaluateJavaScript(javaScriptCode) { result, error in
                if let error = error { print("Error clearing cookie: \(error.localizedDescription)") }
            }
        }
        removeUserScript(withTag: generateScriptTag(forKey: nil))
        customCookies = [:]
    }
    
    /// 添加 JavaScript 代码片段
    public func addUserScript(withJavaScriptCode javaScriptCode: String, tag: String) {
        let fullJavaScriptCode = "\(javaScriptCode) \n\(tag)"
        let userScript = WKUserScript(source: fullJavaScriptCode, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        self.configuration.userContentController.addUserScript(userScript)
    }
    
    /// 移除 JavaScript 代码片段
    public func removeUserScript(withTag tag: String?) {
        guard let tag = tag else { return }
        let userContentController = self.configuration.userContentController
        let remainingScripts = userContentController.userScripts.filter { !$0.source.contains(tag) }
        userContentController.removeAllUserScripts()
        remainingScripts.forEach { userContentController.addUserScript($0) }
    }
    
    /// 生成用于标识 JavaScript 代码片段的标签
    public func generateScriptTag(forKey key: String?) -> String {
        return cookieScriptTagPrefix + (key ?? "")
    }
}
