//
//  ARTVideoPlayerWrapperViewDelegate.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/10/29.
//

/// 协议方法
///
/// - NOTE: 可继承该协议方法
@objc public protocol ARTVideoPlayerWrapperViewDelegate: AnyObject {
    
    /// 获取播放器图层（最底层：用于显示弹幕、广告等）
    ///
    /// - Parameter wrapperView: 视频播放器包装视图
    /// - Returns: 播放器图层视图
    @objc optional func wrapperViewOverlay(for wrapperView: ARTVideoPlayerWrapperView) -> ARTVideoPlayerOverlayView?

    /// 获取播放器系统控制层（中间层：系统控制）
    ///
    /// - Parameter wrapperView: 视频播放器包装视图
    /// - Returns: 播放器系统控制层视图
    @objc optional func wrapperViewSystemControls(for wrapperView: ARTVideoPlayerWrapperView) -> ARTVideoPlayerSystemControls?

    /// 获取播放器控制层（最顶层：顶部栏、侧边栏等）
    ///
    /// - Parameter wrapperView: 视频播放器包装视图
    /// - Returns: 播放器控制层视图
    @objc optional func wrapperViewControls(for wrapperView: ARTVideoPlayerWrapperView) -> ARTVideoPlayerControlsView?

    /// 获取播放器的加载动画视图，用于显示加载动画
    ///
    /// - Parameter wrapperView: 视频播放器包装视图
    /// - Returns: 加载动画视图
    @objc optional func wrapperViewLoading(for wrapperView: ARTVideoPlayerWrapperView) -> ARTVideoPlayerLoadingView?
}
