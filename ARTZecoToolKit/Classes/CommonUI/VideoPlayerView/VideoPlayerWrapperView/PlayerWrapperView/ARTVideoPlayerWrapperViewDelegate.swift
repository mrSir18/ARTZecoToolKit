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
    
    /// 自定义播放模式
    /// - Parameter wrapperView: 播放器层视图
    /// - Returns: 自定义播放模式
    @objc optional func customScreenOrientation(for wrapperView: ARTVideoPlayerWrapperView) -> ScreenOrientation
    
    /// 自定义顶部工具栏视图
    /// - Parameters:
    ///   - wrapperView: 播放器层视图
    ///   - screenOrientation: 当前屏幕方向
    /// - Returns: 自定义顶部工具栏视图（需继承自 ARTVideoPlayerTopbar）
    @objc optional func customTopBar(for wrapperView: ARTVideoPlayerWrapperView, screenOrientation: ScreenOrientation) -> ARTVideoPlayerTopbar?
    
    /// 自定义底部工具栏视图
    /// - Parameters:
    ///   - wrapperView: 播放器层视图
    ///   - screenOrientation: 当前屏幕方向
    /// - Returns: 自定义底部工具栏视图（需继承自 ARTVideoPlayerBottombar）
    @objc optional func customBottomBar(for wrapperView: ARTVideoPlayerWrapperView, screenOrientation: ScreenOrientation) -> ARTVideoPlayerBottombar?
    
    
// MARK: - 顶部工具栏 - 公共方法
    
    /// 当返回按钮被点击时调用
    @objc optional func wrapperViewDidTapBack(for wrapperView: ARTVideoPlayerWrapperView)
    
    /// 当收藏按钮被点击时调用
    /// - Parameters:
    ///   - wrapperView: 播放器层视图
    ///   - isFavorited: 是否已收藏
    @objc optional func wrapperViewDidTapFavorite(for wrapperView: ARTVideoPlayerWrapperView, isFavorited: Bool)
    
    /// 当分享按钮被点击时调用
    @objc optional func wrapperViewDidTapShare(for wrapperView: ARTVideoPlayerWrapperView)
    
    
// MARK: - 底部工具栏 - 公共方法
    
    /// 当滑块触摸开始时调用
    /// - Parameters:
    ///   - wrapperView: 播放器层视图
    ///   - slider: 被触摸的滑块
    @objc optional func wrapperViewDidBeginTouch(for wrapperView: ARTVideoPlayerWrapperView, slider: ARTVideoPlayerSlider)
    
    /// 当滑块值改变时调用
    /// - Parameters:
    ///   - wrapperView: 播放器层视图
    ///   - slider: 值已改变的滑块
    @objc optional func wrapperViewDidChangeValue(for wrapperView: ARTVideoPlayerWrapperView, slider: ARTVideoPlayerSlider)
    
    /// 当滑块触摸结束时调用
    /// - Parameters:
    ///   - wrapperView: 播放器层视图
    ///   - slider: 被释放的滑块
    @objc optional func wrapperViewDidEndTouch(for wrapperView: ARTVideoPlayerWrapperView, slider: ARTVideoPlayerSlider)
    
    /// 当滑块被点击时调用
    /// - Parameters:
    ///   - wrapperView: 播放器层视图
    ///   - slider: 被点击的滑块
    @objc optional func wrapperViewDidTap(for wrapperView: ARTVideoPlayerWrapperView, slider: ARTVideoPlayerSlider)
    
    /// 当暂停按钮被点击时调用
    @objc optional func wrapperViewDidTapPause(for wrapperView: ARTVideoPlayerWrapperView)
    
    /// 当弹幕开关按钮被点击时调用
    @objc optional func wrapperViewDidTapDanmakuToggle(for wrapperView: ARTVideoPlayerWrapperView)
    
    /// 当弹幕设置按钮被点击时调用
    @objc optional func wrapperViewDidTapDanmakuSettings(for wrapperView: ARTVideoPlayerWrapperView)
    
    /// 当发送弹幕按钮被点击时调用
    /// - Parameter text: 弹幕内容
    @objc optional func wrapperViewDidTapDanmakuSend(for wrapperView: ARTVideoPlayerWrapperView, text: String)
    
    
// MARK: - 窗口模式 - 底部工具栏
    
    /// 全屏切换
    /// - Parameters:
    ///   - wrapperView: 播放器层视图
    ///   - orientation: 屏幕方向
    @objc optional func wrapperViewDidTransitionToFullscreen(for wrapperView: ARTVideoPlayerWrapperView, orientation: ScreenOrientation)
    
    
// MARK: - 横屏模式 - 底部工具栏
    
    /// 当下一个按钮被点击时调用
    @objc optional func wrapperViewDidTapNext(for wrapperView: ARTVideoPlayerWrapperView)
    
    /// 当倍速按钮被点击时调用
    @objc optional func wrapperViewDidTapSpeed(for wrapperView: ARTVideoPlayerWrapperView)
    
    /// 当目录按钮被点击时调用
    @objc optional func wrapperViewDidTapCollection(for wrapperView: ARTVideoPlayerWrapperView)
    
    
// MARK: - 竖屏模式 - 底部工具栏
    
    /// 当评论按钮被点击时调用
    @objc optional func wrapperViewDidTapComment(for wrapperView: ARTVideoPlayerWrapperView)
    
    /// 当更多按钮被点击时调用
    @objc optional func wrapperViewDidTapMore(for wrapperView: ARTVideoPlayerWrapperView)
}
