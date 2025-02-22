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
    
    
// MARK: - 弹幕视图 - 公共方法
    
    /// 自定义弹幕视图
    /// - Returns: 自定义弹幕视图
    @objc optional func wrapperViewDidDidCustomDanmakuView(for wrapperView: ARTVideoPlayerCustomWrapperView) -> ARTDanmakuView?
    
    /// 创建弹幕回调
    /// - Returns: 新创建的弹幕单元
    @objc optional func wrapperViewDidCreateDanmakuCell(for wrapperView: ARTVideoPlayerCustomWrapperView) -> ARTDanmakuCell
    
    /// 点击弹幕事件回调
    @objc optional func wrapperViewDidTapDanmakuCell(for wrapperView: ARTVideoPlayerCustomWrapperView, danmakuCell: ARTDanmakuCell)
    
    /// 弹幕即将显示回调
    @objc optional func wrapperViewWillDisplayDanmakuCell(for wrapperView: ARTVideoPlayerCustomWrapperView, danmakuCell: ARTDanmakuCell)
    
    /// 弹幕显示完成回调
    @objc optional func wrapperViewDidEndDisplayDanmakuCell(for wrapperView: ARTVideoPlayerCustomWrapperView, danmakuCell: ARTDanmakuCell)
    
    /// 所有弹幕显示完成回调
    @objc optional func wrapperViewDidEndDisplayAllDanmaku(for wrapperView: ARTVideoPlayerCustomWrapperView)
    
    
// MARK: - 顶部工具栏 - 公共方法
    
    /// 当返回按钮被点击时调用
    @objc optional func wrapperViewDidTapBack(for wrapperView: ARTVideoPlayerCustomWrapperView)
    
    /// 当收藏按钮被点击时调用
    /// - Parameters:
    ///   - wrapperView: 播放器层视图
    ///   - isFavorited: 是否已收藏
    @objc optional func wrapperViewDidTapFavorite(for wrapperView: ARTVideoPlayerCustomWrapperView, isFavorited: Bool)
    
    /// 当分享按钮被点击时调用
    @objc optional func wrapperViewDidTapShare(for wrapperView: ARTVideoPlayerCustomWrapperView)
    
    
// MARK: - 底部工具栏 - 公共方法
    
    /// 当滑块触摸开始时调用
    /// - Parameters:
    ///   - wrapperView: 播放器层视图
    ///   - slider: 被触摸的滑块
    @objc optional func wrapperViewDidBeginTouch(for wrapperView: ARTVideoPlayerCustomWrapperView, slider: ARTVideoPlayerSlider)
    
    /// 当滑块值改变时调用
    /// - Parameters:
    ///   - wrapperView: 播放器层视图
    ///   - slider: 值已改变的滑块
    @objc optional func wrapperViewDidChangeValue(for wrapperView: ARTVideoPlayerCustomWrapperView, slider: ARTVideoPlayerSlider)
    
    /// 当滑块触摸结束时调用
    /// - Parameters:
    ///   - wrapperView: 播放器层视图
    ///   - slider: 被释放的滑块
    @objc optional func wrapperViewDidEndTouch(for wrapperView: ARTVideoPlayerCustomWrapperView, slider: ARTVideoPlayerSlider)
    
    /// 当滑块被点击时调用
    /// - Parameters:
    ///   - wrapperView: 播放器层视图
    ///   - slider: 被点击的滑块
    @objc optional func wrapperViewDidTap(for wrapperView: ARTVideoPlayerCustomWrapperView, slider: ARTVideoPlayerSlider)
    
    /// 当暂停按钮被点击时调用
    @objc optional func wrapperViewDidTapPause(for wrapperView: ARTVideoPlayerCustomWrapperView, isPlaying: Bool)
    
    /// 当弹幕开关按钮被点击时调用
    /// - Parameters: isDanmakuEnabled 弹幕是否开启
    @objc optional func wrapperViewDidTapDanmakuToggle(for wrapperView: ARTVideoPlayerCustomWrapperView, isDanmakuEnabled: Bool)
    
    /// 当弹幕设置按钮被点击时调用
    @objc optional func wrapperViewDidTapDanmakuSettings(for wrapperView: ARTVideoPlayerCustomWrapperView)
    
    /// 当发送弹幕按钮被点击时调用
    /// - Parameter text: 弹幕内容
    @objc optional func wrapperViewDidTapDanmakuSend(for wrapperView: ARTVideoPlayerCustomWrapperView, text: String)
    
    
// MARK: - 窗口模式 - 底部工具栏
    
    /// 全屏切换
    /// - Parameters:
    ///   - wrapperView: 播放器层视图
    ///   - orientation: 屏幕方向
    @objc optional func wrapperViewDidTransitionToFullscreen(for wrapperView: ARTVideoPlayerCustomWrapperView, orientation: ScreenOrientation)
    
    
// MARK: - 横屏模式 - 底部工具栏
    
    /// 当下一个按钮被点击时调用
    @objc optional func wrapperViewDidTapNext(for wrapperView: ARTVideoPlayerCustomWrapperView)
    
    /// 当倍速按钮被点击时调用
    @objc optional func wrapperViewDidTapSpeed(for wrapperView: ARTVideoPlayerCustomWrapperView)
    
    /// 当目录按钮被点击时调用
    @objc optional func wrapperViewDidTapCatalogue(for wrapperView: ARTVideoPlayerCustomWrapperView)
    
    
// MARK: - 竖屏模式 - 底部工具栏
    
    /// 当评论按钮被点击时调用
    @objc optional func wrapperViewDidTapComment(for wrapperView: ARTVideoPlayerCustomWrapperView)
}
