//
//  ARTVideoPlayerControlsViewDelegate.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/10/29.
//

/// 协议方法
///
/// - NOTE: 可继承该协议方法
@objc public protocol ARTVideoPlayerControlsViewDelegate: AnyObject {
    
    /// 自定义播放模式
    /// - Parameter playerControlsView: 控制层视图
    /// - Returns: 自定义播放模式
    @objc optional func customScreenOrientation(for playerControlsView: ARTVideoPlayerControlsView) -> ScreenOrientation
    
    /// 自定义顶部工具栏视图
    /// - Parameters:
    ///   - playerControlsView: 控制层视图
    ///   - screenOrientation: 当前屏幕方向
    /// - Returns: 自定义顶部工具栏视图（需继承自 ARTVideoPlayerTopbar）
    @objc optional func customTopBar(for playerControlsView: ARTVideoPlayerControlsView, screenOrientation: ScreenOrientation) -> ARTVideoPlayerTopbar?
    
    /// 自定义底部工具栏视图
    /// - Parameters:
    ///   - playerControlsView: 控制层视图
    ///   - screenOrientation: 当前屏幕方向
    /// - Returns: 自定义底部工具栏视图（需继承自 ARTVideoPlayerBottombar）
    @objc optional func customBottomBar(for playerControlsView: ARTVideoPlayerControlsView, screenOrientation: ScreenOrientation) -> ARTVideoPlayerBottombar?
    
    
// MARK: - 顶部工具栏 - 公共方法
    
    /// 当返回按钮被点击时调用
    @objc optional func controlsViewDidTapBack(for playerControlsView: ARTVideoPlayerControlsView)
    
    /// 当收藏按钮被点击时调用
    /// - Parameters:
    ///   - playerControlsView: 控制层视图
    ///   - isFavorited: 是否已收藏
    @objc optional func controlsViewDidTapFavorite(for playerControlsView: ARTVideoPlayerControlsView, isFavorited: Bool)
    
    /// 当分享按钮被点击时调用
    @objc optional func controlsViewDidTapShare(for playerControlsView: ARTVideoPlayerControlsView)
    
    
// MARK: - 底部工具栏 - 公共方法
    
    /// 当滑块触摸开始时调用
    /// - Parameters:
    ///   - controlsView: 控制层视图
    ///   - slider: 被触摸的滑块
    @objc optional func controlsViewDidBeginTouch(for controlsView: ARTVideoPlayerControlsView, slider: ARTVideoPlayerSlider)
    
    /// 当滑块值改变时调用
    /// - Parameters:
    ///   - controlsView: 控制层视图
    ///   - slider: 值已改变的滑块
    @objc optional func controlsViewDidChangeValue(for controlsView: ARTVideoPlayerControlsView, slider: ARTVideoPlayerSlider)
    
    /// 当滑块触摸结束时调用
    /// - Parameters:
    ///   - controlsView: 控制层视图
    ///   - slider: 被释放的滑块
    @objc optional func controlsViewDidEndTouch(for controlsView: ARTVideoPlayerControlsView, slider: ARTVideoPlayerSlider)
    
    /// 当滑块被点击时调用
    /// - Parameters:
    ///   - controlsView: 控制层视图
    ///   - slider: 被点击的滑块
    @objc optional func controlsViewDidTap(for controlsView: ARTVideoPlayerControlsView, slider: ARTVideoPlayerSlider)
    
    /// 当暂停按钮被点击时调用
    @objc optional func controlsViewDidTapPause(for controlsView: ARTVideoPlayerControlsView)
    
    /// 当弹幕开关按钮被点击时调用
    @objc optional func controlsViewDidTapDanmakuToggle(for controlsView: ARTVideoPlayerControlsView)
    
    /// 当弹幕设置按钮被点击时调用
    @objc optional func controlsViewDidTapDanmakuSettings(for controlsView: ARTVideoPlayerControlsView)
    
    /// 当发送弹幕按钮被点击时调用
    /// - Parameter text: 弹幕内容
    @objc optional func controlsViewDidTapDanmakuSend(for controlsView: ARTVideoPlayerControlsView, text: String)
    
    
// MARK: - 窗口模式 - 底部工具栏
    
    /// 全屏切换
    /// - Parameters:
    ///   - playerControlsView: 控制层视图
    ///   - orientation: 屏幕方向
    @objc optional func controlsViewDidTransitionToFullscreen(for playerControlsView: ARTVideoPlayerControlsView, orientation: ScreenOrientation)
    
    
// MARK: - 横屏模式 - 底部工具栏

    /// 当下一个按钮被点击时调用
    @objc optional func controlsViewDidTapNext(for playerControlsView: ARTVideoPlayerControlsView)
    
    /// 当倍速按钮被点击时调用
    @objc optional func controlsViewDidTapSpeed(for playerControlsView: ARTVideoPlayerControlsView)
    
    /// 当收藏按钮被点击时调用
    @objc optional func controlsViewDidTapCollection(for playerControlsView: ARTVideoPlayerControlsView)
    
    
// MARK: - 竖屏模式 - 底部工具栏
    
    /// 当评论按钮被点击时调用
    @objc optional func controlsViewDidTapComment(for playerControlsView: ARTVideoPlayerControlsView)
    
    /// 当更多按钮被点击时调用
    @objc optional func controlsViewDidTapMore(for playerControlsView: ARTVideoPlayerControlsView)
}
