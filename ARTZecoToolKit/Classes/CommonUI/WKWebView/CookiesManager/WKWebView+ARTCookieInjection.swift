//
//  WKWebView+ARTCookieInjection.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/8/19.
//

import WebKit

// MARK: - WKWebView Cookie 注入扩展

extension WKWebView {
    
    // MARK: - 静态常量
    
    /// 静态常量，用于执行 `load(_:)` 方法交换
    private static let swizzleLoadRequestImplementation: Void = {
        // 原始方法的选择器
        let originalSelector = #selector(WKWebView.load(_:))
        // 替换方法的选择器
        let swizzledSelector = #selector(WKWebView.swizzled_load(_:))
        
        // 获取原始方法和替换方法的 Method 对象
        guard let originalMethod = class_getInstanceMethod(WKWebView.self, originalSelector),
              let swizzledMethod = class_getInstanceMethod(WKWebView.self, swizzledSelector) else {
            return
        }
        
        // 尝试将替换方法的实现添加到原始方法中，如果添加失败，则交换两者的实现
        if !class_addMethod(WKWebView.self,
                            originalSelector,
                            method_getImplementation(swizzledMethod),
                            method_getTypeEncoding(swizzledMethod)) {
            // 交换原始方法和替换方法的实现
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }()
    
    // MARK: - 替换的方法
    
    /// 自定义的 `load(_:)` 方法，用于在请求中添加自定义的 Cookie
    /// - Parameter request: 原始的 URL 请求
    /// - Returns: 返回 `WKNavigation` 对象，表示导航
    @objc private func swizzled_load(_ request: URLRequest) -> WKNavigation? {
        var modifiedRequest = request
        
        // 如果存在自定义的 Cookies，将其添加到请求的 Header 中
        if let cookies = customCookies {
            let cookieString = cookies.map { "\($0.key)=\($0.value)" }.joined(separator: "; ")
            modifiedRequest.setValue(cookieString, forHTTPHeaderField: "Cookie")
        }
        // 调用交换后的原始 `load(_:)` 方法，并传入修改后的请求
        return swizzled_load(modifiedRequest)
    }
    
    // MARK: - 公共方法
    
    /// 执行 `load(_:)` 方法交换，以便在请求中注入自定义 Cookies
    public static func loadSwizzling() {
        _ = swizzleLoadRequestImplementation
    }
}
