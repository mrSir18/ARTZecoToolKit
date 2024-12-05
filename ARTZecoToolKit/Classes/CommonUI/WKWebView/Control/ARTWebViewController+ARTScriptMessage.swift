//
//  ARTWebViewController+ARTScriptMessage.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/12/5.
//

import WebKit

extension ARTWebViewController {
    
    /// 自定义模拟 WKScriptMessage 的结构体
    public struct ARTScriptMessage {
        
        /// 消息体，支持的类型包括 NSNumber、NSString、NSDate、NSArray、NSDictionary 和 NSNull
        public var body: Any
        
        /// 发送消息的 WebView 实例
        public weak var webView: WKWebView?
        
        /// 发送消息的框架信息
        public var frameInfo: WKFrameInfo?
        
        /// 消息发送到的消息处理器名称
        public var name: String
        
        /// 消息发送的内容世界（仅 iOS 14.0 及以上支持）
        public var _world: Any?
        
        /// 计算属性，返回内容世界
        @available(iOS 14.0, *)
        var world: WKContentWorld? {
            return _world as? WKContentWorld
        }
        
        /// 初始化自定义消息结构体
        /// - Parameters:
        ///   - body: 消息体
        ///   - webView: 发送消息的 WebView 实例
        ///   - frameInfo: 框架信息
        ///   - name: 消息处理器名称
        ///   - world: 消息内容世界
        public init(body: Any, webView: WKWebView?, frameInfo: WKFrameInfo? = nil, name: String, world: Any? = nil) {
            self.body = body
            self.webView = webView
            self.frameInfo = frameInfo
            self.name = name
            self._world = world
        }
    }
    
    /// 将 `WKScriptMessage` 转换为 `ARTScriptMessage`
    /// - Parameter scriptMessage: 原始的 `WKScriptMessage`
    /// - Returns: 转换后的 `ARTScriptMessage`
    public func convertToCustomScriptMessage(from scriptMessage: WKScriptMessage) -> ARTScriptMessage {
        if #available(iOS 14.0, *) {
            return ARTScriptMessage(
                body: scriptMessage.body,
                webView: scriptMessage.webView,
                frameInfo: scriptMessage.frameInfo,
                name: scriptMessage.name,
                world: scriptMessage.world
            )
        } else {
            return ARTScriptMessage(
                body: scriptMessage.body,
                webView: scriptMessage.webView,
                frameInfo: scriptMessage.frameInfo,
                name: scriptMessage.name
            )
        }
    }
}
