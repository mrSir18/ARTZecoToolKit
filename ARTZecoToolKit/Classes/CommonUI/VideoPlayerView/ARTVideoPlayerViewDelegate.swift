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
    
    /// 自定义播放模式
    /// - Parameter playerView: 基类视图
    /// - Returns: 自定义播放模式
    @objc optional func customScreenOrientation(for playerView: ARTVideoPlayerView) -> ScreenOrientation
    
    /// 自定义顶部工具栏视图
    /// - Parameters:
    ///   - playerView: 基类视图
    ///   - screenOrientation: 当前屏幕方向
    /// - Returns: 自定义顶部工具栏视图（需继承自 ARTVideoPlayerTopbar）
    @objc optional func customTopBar(for playerView: ARTVideoPlayerView, screenOrientation: ScreenOrientation) -> ARTVideoPlayerTopbar?
    
    /// 自定义底部工具栏视图
    /// - Parameters:
    ///   - playerView: 基类视图
    ///   - screenOrientation: 当前屏幕方向
    /// - Returns: 自定义底部工具栏视图（需继承自 ARTVideoPlayerBottombar）
    @objc optional func customBottomBar(for playerView: ARTVideoPlayerView, screenOrientation: ScreenOrientation) -> ARTVideoPlayerBottombar?
    
    /// 显示加载动画
    /// - Parameters:
    /// - playerView: 基类视图
    /// - loadingView
    @objc optional func playerViewDidBeginLoading(for playerView: ARTVideoPlayerView) -> ARTVideoPlayerLoadingView
    
    
// MARK: - 弹幕视图 - 公共方法

    /// 自定义弹幕视图
    /// - Returns: 自定义弹幕视图
    @objc optional func playerViewDidCustomDanmakuView(for playerView: ARTVideoPlayerView) -> ARTDanmakuView?
    
    /// 创建弹幕回调
    /// - Returns: 新创建的弹幕单元
    @objc optional func playerViewDidCreateDanmakuCell(for playerView: ARTVideoPlayerView) -> ARTDanmakuCell
    
    /// 点击弹幕事件回调
    @objc optional func playerViewDidTapDanmakuCell(for playerView: ARTVideoPlayerView, danmakuCell: ARTDanmakuCell)
    
    /// 弹幕即将显示回调
    @objc optional func playerViewWillDisplayDanmakuCell(for playerView: ARTVideoPlayerView, danmakuCell: ARTDanmakuCell)
    
    /// 弹幕显示完成回调
    @objc optional func playerViewDidEndDisplayDanmakuCell(for playerView: ARTVideoPlayerView, danmakuCell: ARTDanmakuCell)
    
    /// 所有弹幕显示完成回调
    @objc optional func playerViewDidEndDisplayAllDanmaku(for playerView: ARTVideoPlayerView)
    
    
// MARK: - 顶部工具栏 - 公共方法
    
    /// 当返回按钮被点击时调用
    @objc optional func playerViewDidTapBack(for playerView: ARTVideoPlayerView)
    
    /// 当收藏按钮被点击时调用
    /// - Parameters:
    ///   - playerView: 基类视图
    ///   - isFavorited: 是否已收藏
    @objc optional func playerViewDidTapFavorite(for playerView: ARTVideoPlayerView, isFavorited: Bool)
    
    /// 当分享按钮被点击时调用
    @objc optional func playerViewDidTapShare(for playerView: ARTVideoPlayerView)
    
    
// MARK: - 底部工具栏 - 公共方法
    
    /// 当滑块触摸开始时调用
    /// - Parameters:
    ///   - playerView: 基类视图
    ///   - slider: 被触摸的滑块
    @objc optional func playerViewDidBeginTouch(for playerView: ARTVideoPlayerView, slider: ARTVideoPlayerSlider)
    
    /// 当滑块值改变时调用
    /// - Parameters:
    ///   - playerView: 基类视图
    ///   - slider: 值已改变的滑块
    @objc optional func playerViewDidChangeValue(for playerView: ARTVideoPlayerView, slider: ARTVideoPlayerSlider)
    
    /// 当滑块触摸结束时调用
    /// - Parameters:
    ///   - playerView: 基类视图
    ///   - slider: 被释放的滑块
    @objc optional func playerViewDidEndTouch(for playerView: ARTVideoPlayerView, slider: ARTVideoPlayerSlider)
    
    /// 当滑块被点击时调用
    /// - Parameters:
    ///   - playerView: 基类视图
    ///   - slider: 被点击的滑块
    @objc optional func playerViewDidTap(for playerView: ARTVideoPlayerView, slider: ARTVideoPlayerSlider)
    
    /// 当暂停按钮被点击时调用
    @objc optional func playerViewDidTapPause(for playerView: ARTVideoPlayerView, isPlaying: Bool)
    
    /// 当弹幕开关按钮被点击时调用
    /// - Parameters: isDanmakuEnabled
    @objc optional func playerViewDidTapDanmakuToggle(for playerView: ARTVideoPlayerView, isDanmakuEnabled: Bool)
    
    /// 当弹幕设置按钮被点击时调用
    @objc optional func playerViewDidTapDanmakuSettings(for playerView: ARTVideoPlayerView)
    
    /// 当发送弹幕按钮被点击时调用
    /// - Parameter text: 弹幕内容
    @objc optional func playerViewDidTapDanmakuSend(for playerView: ARTVideoPlayerView, text: String)
    
    
// MARK: - 窗口模式 - 底部工具栏
    
    /// 全屏切换
    /// - Parameters:
    ///   - playerView: 基类视图
    ///   - orientation: 屏幕方向
    @objc optional func playerViewDidTransitionToFullscreen(for playerView: ARTVideoPlayerView, orientation: ScreenOrientation)
    
    
// MARK: - 横屏模式 - 底部工具栏
    
    /// 当下一个按钮被点击时调用
    @objc optional func playerViewDidTapNext(for playerView: ARTVideoPlayerView)
    
    /// 当倍速按钮被点击时调用
    @objc optional func playerViewDidTapSpeed(for playerView: ARTVideoPlayerView)
    
    /// 当目录按钮被点击时调用
    @objc optional func playerViewDidTapCatalogue(for playerView: ARTVideoPlayerView)
    
    
// MARK: - 竖屏模式 - 底部工具栏
    
    /// 当评论按钮被点击时调用
    @objc optional func playerViewDidTapComment(for playerView: ARTVideoPlayerView)
}
