//
//  ARTVideoPlayerCustomWrapperViewDelegate.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/10/29.
//

import ARTZecoToolKit

/// 协议方法
///
/// - NOTE: 可继承该协议方法
@objc protocol ARTVideoPlayerCustomWrapperViewDelegate: AnyObject {
    
    /// 自定义播放模式
    /// - Parameter wrapperView: 播放器层视图
    /// - Returns: 自定义播放模式
    @objc optional func customScreenOrientation(for wrapperView: ARTVideoPlayerCustomWrapperView) -> ScreenOrientation
    
    /// 自定义顶部工具栏视图
    /// - Parameters:
    ///   - wrapperView: 播放器层视图
    ///   - screenOrientation: 当前屏幕方向
    /// - Returns: 自定义顶部工具栏视图（需继承自 ARTVideoPlayerTopbar）
    @objc optional func customTopBar(for wrapperView: ARTVideoPlayerCustomWrapperView, screenOrientation: ScreenOrientation) -> ARTVideoPlayerTopbar?
    
    /// 自定义底部工具栏视图
    /// - Parameters:
    ///   - wrapperView: 播放器层视图
    ///   - screenOrientation: 当前屏幕方向
    /// - Returns: 自定义底部工具栏视图（需继承自 ARTVideoPlayerBottombar）
    @objc optional func customBottomBar(for wrapperView: ARTVideoPlayerCustomWrapperView, screenOrientation: ScreenOrientation) -> ARTVideoPlayerBottombar?
    
    /// 加载动画
    /// - Parameters:
    ///  - wrapperView: 播放器层视图
    /// - Returns: 加载动画视图
    @objc optional func wrapperViewDidBeginLoading(for wrapperView: ARTVideoPlayerCustomWrapperView) -> ARTVideoPlayerLoadingView?

// MARK: - 顶部工具栏 - 公共方法
    
    /// 当收藏按钮被点击时调用
    /// - Parameters:
    ///   - wrapperView: 播放器层视图
    ///   - isFavorited: 是否已收藏
    @objc optional func wrapperViewDidTapFavorite(for wrapperView: ARTVideoPlayerCustomWrapperView, isFavorited: Bool)
    
    
// MARK: - 底部工具栏 - 公共方法
    
    /// 当发送弹幕按钮被点击时调用
    /// - Parameter text: 弹幕内容
    @objc optional func wrapperViewDidTapDanmakuSend(for wrapperView: ARTVideoPlayerCustomWrapperView, text: String)
    
    
// MARK: - 竖屏模式 - 底部工具栏
    
    /// 当评论按钮被点击时调用
    @objc optional func wrapperViewDidTapComment(for wrapperView: ARTVideoPlayerCustomWrapperView)
}
