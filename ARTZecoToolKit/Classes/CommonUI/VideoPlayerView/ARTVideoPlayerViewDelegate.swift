//
//  ARTVideoPlayerViewDelegate.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/11/2.
//

/// 协议方法
///
/// - NOTE: 可继承该协议方法
@objc public protocol ARTVideoPlayerViewDelegate: AnyObject {
    
    /// 获取播放器基类视图
    ///
    ///  Parameter playerView: 基类视图
    ///  Returns: 播放器基类视图
    @objc optional func playerViewWrapper(for playerView: ARTVideoPlayerView) -> ARTVideoPlayerWrapperView?
    
    /// 获取播放器图层（最底层：用于显示弹幕、广告等）
    ///
    ///  Parameter playerView: 基类视图
    ///  Returns: 播放器图层视图
    @objc optional func playerViewOverlay(for playerView: ARTVideoPlayerView) -> ARTVideoPlayerOverlayView?
    
    /// 获取播放器系统控制层（中间层：系统控制）
    ///
    ///  Parameter playerView: 基类视图
    ///  Returns: 播放器系统控制层视图
    @objc optional func playerViewSystemControls(for playerView: ARTVideoPlayerView) -> ARTVideoPlayerSystemControls?
    
    /// 获取播放器控制层（最顶层：顶部栏、侧边栏等）
    ///
    ///  Parameter playerView: 基类视图
    ///  Returns: 播放器控制层视图
    @objc optional func playerViewControls(for playerView: ARTVideoPlayerView) -> ARTVideoPlayerControlsView?
    
    /// 返回播放器的加载动画视图，用于显示加载动画
    ///
    ///  Parameter playerView: 基类视图
    ///  Returns: 加载动画视图
    @objc optional func playerViewLoading(for playerView: ARTVideoPlayerView) -> ARTVideoPlayerLoadingView?
}
