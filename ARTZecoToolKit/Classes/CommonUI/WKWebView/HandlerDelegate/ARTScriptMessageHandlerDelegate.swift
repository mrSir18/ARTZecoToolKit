//
//  ARTScriptMessageHandlerDelegate.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/8/20.
//

import WebKit

/// `ARTScriptMessageHandlerDelegate` 类用于作为 `WKWebView` 的脚本消息处理代理。
public class ARTScriptMessageHandlerDelegate: NSObject, WKScriptMessageHandler {
    
    /// 脚本消息处理代理
    private weak var delegate: WKScriptMessageHandler?
    
    
    // MARK: - Life Cycle

    init(_ delegate: WKScriptMessageHandler) {
        self.delegate = delegate
        super.init()
    }
    
    // MARK: - WKScriptMessageHandler
    
    /// 当从网页接收到脚本消息时调用该方法。
    /// 它将消息转发给弱引用的代理（如果存在）。
    ///
    /// - Parameters:
    ///   - userContentController: 收到脚本消息的用户内容控制器。
    ///   - message: 接收到的脚本消息。
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        delegate?.userContentController(userContentController, didReceive: message)
    }
}
