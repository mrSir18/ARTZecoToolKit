//
//  WKWebView+Attribute.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/8/19.
//

import WebKit

// MARK: - ARTWebViewDelegate 协议

public protocol ARTWebViewDelegate: WKUIDelegate, WKNavigationDelegate {
    
    /// 获取自定义的 Cookie 字典
    ///
    /// - Returns: 自定义的 Cookie 字典，键为 Cookie 名称，值为 Cookie 值
    func webviewCustomCookies() -> [String: String]
}

// MARK: - WKWebView 扩展

extension WKWebView {
    
    // MARK: - 关联对象的键值
    
    /// 关联对象的键值定义
    ///
    /// - Parameters:
    ///  - cookieDelegate: Cookie 代理
    ///  - customCookies:  自定义 Cookies
    private enum AssociatedKeys {
        static let cookieDelegate   = "cookieDelegate"
        static let customCookies    = "customCookies"
    }
    
    // MARK: - 获取键值的指针
    
    /// 根据给定的键值字符串生成 `UnsafeRawPointer` 指针
    ///
    /// - Parameter key: 键值字符串
    /// - Returns: 对应的 `UnsafeRawPointer` 指针
    private static func key(for key: String) -> UnsafeRawPointer {
        return UnsafeRawPointer(bitPattern: key.hashValue)!
    }
    
    // MARK: - Cookie 代理
    
    /// 获取或设置 Cookie 代理
    ///
    /// - Note: 用于获取自定义的 Cookie 字典
    public var cookieDelegate: ARTWebViewDelegate? {
        get {
            return objc_getAssociatedObject(self, Self.key(for: AssociatedKeys.cookieDelegate)) as? ARTWebViewDelegate
        }
        set {
            objc_setAssociatedObject(self, Self.key(for: AssociatedKeys.cookieDelegate), newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    // MARK: - 自定义 Cookies
    
    /// 获取或设置自定义 Cookies
    ///
    /// - Note: 用于在请求中注入自定义的 Cookies
    public var customCookies: [String: String]? {
        get {
            return objc_getAssociatedObject(self, Self.key(for: AssociatedKeys.customCookies)) as? [String: String]
        }
        set {
            objc_setAssociatedObject(self, Self.key(for: AssociatedKeys.customCookies), newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
}
