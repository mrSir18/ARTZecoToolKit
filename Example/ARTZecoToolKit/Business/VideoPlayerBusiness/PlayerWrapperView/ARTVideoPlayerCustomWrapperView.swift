//
//  ARTVideoPlayerCustomWrapperView.swift
//  Pods
//
//  Created by mrSir18 on 2024/10/15.
//

import AVFoundation
import ARTZecoToolKit

class ARTVideoPlayerCustomWrapperView: ARTVideoPlayerWrapperView {
    
    // MARK: - Private Properties
    
    /// 代理对象
    public weak var delegate: ARTVideoPlayerCustomWrapperViewDelegate?
    
    /// 是否正在拖动进度条
    public var isDraggingSlider = false
    
    
    // MARK: - 播放器组件 AVPlayer（最底层：播放器视图）
    
    /// 播放器图层（最底层：用于显示弹幕、广告等）
    public var overlayView: ARTVideoPlayerOverlayView!
     
    /// 播放器系统控制层（中间层：系统控制，位于弹幕、广告等之上）
    public var systemControls: ARTVideoPlayerSystemControls!
    
    /// 播放器控制层（最顶层：顶部栏、侧边栏等）
    public var controlsView: ARTVideoPlayerControlsView!
     
    /// 播放器加载动画视图
    public var loadingView: ARTVideoPlayerLoadingView!
    

    // MARK: - 私有扩展视图（个人项目使用）
    
    /// 懒加载弹幕设置视图
    public lazy var danmakuView: ARTVideoPlayerLandscapeDanmakuView = {
        let danmakuView = ARTVideoPlayerLandscapeDanmakuView(self)
        return danmakuView
    }()
    
    /// 懒加载倍速视图
    public lazy var rateView: ARTVideoPlayerLandscapeSlidingView = {
        let rateView = ARTVideoPlayerLandscapePlaybackRateView(self)
        rateView.rateCallback = { [weak self] rate in
            guard let self = self else { return }
            self.controlsView.didUpdatePlaybackRateButtonInControls(rate: rate)
            self.currentRate = rate
            self.player.rate = rate
            self.resumePlayer()
        }
        return rateView
    }()
    
    /// 懒加载目录视图
    public lazy var chaptersView: ARTVideoPlayerLandscapeSlidingView = {
        let chaptersView = ARTVideoPlayerLandscapeChaptersView()
        chaptersView.chapterCallback = { [weak self] index in
            guard let self = self else { return }
            self.playNextVideo(with: URL(string: "https://media.w3.org/2010/05/sintel/trailer.mp4"))
        }
        return chaptersView
    }()
    
    /// 懒加载竖屏弹幕视图
    public lazy var portraitDanmakuView: ARTVideoPlayerPortraitDanmakuView = {
        let danmakuView = ARTVideoPlayerPortraitDanmakuView(self)
        return danmakuView
    }()
    
    
    // MARK: - Initialization
    
    public init(_ delegate: ARTVideoPlayerCustomWrapperViewDelegate) {
        self.delegate = delegate
        super.init()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Initialization
    
    override func setupViews() {
        super.setupViews()
        
    }
    
    /// 创建播放器图层（最底层：用于显示弹幕、广告等）
    override func setupOverlayView() {
        overlayView = ARTVideoPlayerOverlayView(self)
        addSubview(overlayView)
        overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    /// 创建系统控制层（中间层：系统控制）
    override func setupSystemControls() {
        systemControls = ARTVideoPlayerSystemControls(self)
        addSubview(systemControls)
        systemControls.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    /// 创建加载动画视图
    override func setupLoadingView() {
        loadingView = ARTVideoPlayerLoadingView(self)
        addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    /// 创建播放器控制层（最顶层：顶部栏、侧边栏等）
    override func setupControlsView() {
        controlsView = ARTVideoPlayerControlsView(self)
        addSubview(controlsView)
        controlsView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: Override Methods
    
    override func onReceivePlayerItemDidPlayToEnd(_ notification: Notification) { // 播放结束
        super.onReceivePlayerItemDidPlayToEnd(notification)
        overlayView.stopDanmaku() // 停止弹幕
        controlsView.didUpdatePlayPauseStateInControls(playerState: playerState) // 更新播放器状态
        controlsView.didUpdatePlayPauseButtonStateInControls(isPlaying: false) // 更新播放按钮状态
    }
    
    override func onReceivePlayerProgressDidChange(time: CMTime) { // 播放进度改变
        super.onReceivePlayerProgressDidChange(time: time)
        controlsView.didUpdatePlaybackTimeInControls(with: time,
                                                     duration: totalDuration,
                                                     shouldUpdateSlider: isDraggingSlider)
    }
    
    override func onReceivePlayerReadyToPlay() { // 播放器准备好播
        super.onReceivePlayerReadyToPlay()
    }
    
    override func onReceiveLoadedTimeRangesChanged(totalBuffer: Double, bufferProgress: Float) { // 缓冲进度改变
        super.onReceiveLoadedTimeRangesChanged(totalBuffer: totalBuffer, bufferProgress: bufferProgress)
        controlsView.didUpdateBufferingProgressInControls(totalBuffer: totalBuffer,
                                                          bufferProgress: bufferProgress,
                                                          shouldUpdateSlider: isDraggingSlider)
    }
    
    override func onReceivePresentationSizeChanged(size: CGSize) { // 视频尺寸改变
        super.onReceivePresentationSizeChanged(size: size)
        controlsView.isLandscape = isLandscape
        systemControls.updateContentModeInSystemControls(isLandscape: isLandscape)
    }
}

// MARK: - 发送消息给外部

extension ARTVideoPlayerCustomWrapperView {
    
    override func didPrepareForNextVideo() { // 准备好播放下一集
        controlsView.didUpdatePlayPauseStateInControls(playerState: playerState) // 更新播放按钮状态
        isDraggingSlider = true // 设置正在拖动状态
        overlayView.stopDanmaku() // 停止弹幕
        controlsView.didResetSliderPositionInControls() // 重置进度条时间
    }
  
    override func didCompleteSetupForNextVideo() { // 播放下一集
        isDraggingSlider = (playerState == .paused) // 设置拖动滑块状态
        controlsView.didUpdatePlayPauseButtonStateInControls(isPlaying: playerState == .playing)
        overlayView.startDanmaku() // 开始弹幕
    }

    override func didUpdatePreviewImage(previewImage: UIImage) { // 更新预览图像
        systemControls.updatePreviewImageInSystemControls(previewImage: previewImage)
    }

    override func didUpdatePreviewTime(currentTime: CMTime, totalTime: CMTime) { // 更新当前预览视频的时间与视频总时长
        systemControls.updateTimeInSystemControls(with: currentTime, duration: totalTime)
    }
 
    override func didStartLoadingAnimation() { // 开始加载动画
        loadingView.startLoading()
    }

    override func didStopLoadingAnimation() { // 停止加载动画
        loadingView.stopLoading()
    }
    
    // MARK: - Gesture Recognizer

    override func didReceiveSliderTouchBegan(sliderValue: Float) { // 触摸开始时调用
        controlsView.didBeginSliderTouchInControls(sliderValue: sliderValue)
    }
   
    override func didReceiveSliderValue(sliderValue: Float) { // 滑动过程中调用
        controlsView.didUpdateSliderPositionInControls(sliderValue: sliderValue)
    }
    
    override func didReceiveSliderTouchEnded(sliderValue: Float) { // 触摸结束时调用
        controlsView.didEndSliderTouchInControls(sliderValue: sliderValue)
    }

    override func didReceiveTapGesture(at location: CGPoint) { // 点击手势
        if overlayView.handleTapOnOverlay(at: location) { return } // 如果弹幕视图处理了点击事件，直接返回
        if isLandscape { // 如果是横屏模式，切换控制
            controlsView.didToggleControlsVisibilityInControls()
        } else { // 如果是竖屏模
            togglePlayerState()
        }
    }

    override func didReceivewDoubleTapGesture() { // 双击手势
        togglePlayerState()
    }
}

// MARK: - Public Methods

extension ARTVideoPlayerCustomWrapperView {
    
    /// 切换播放器状态
    public func togglePlayerState() {
        switch playerState {
        case .paused: // 恢复播放
            overlayView.resumeDanmaku()
            syncControlsWithPlayerState(to: .playing)
        case .playing: // 暂停播放
            syncControlsWithPlayerState(to: .paused)
        case .ended: // 重新播放
            overlayView.startDanmaku()
            controlsView.didResetSliderPositionInControls()
            controlsView.didUpdatePlayPauseButtonStateInControls(isPlaying: true)
            seek(to: CMTime.zero) { [weak self] _ in
                self?.syncControlsWithPlayerState(to: .playing)
            }
        default:
            break
        }
    }
    
    /// 更新播放器状态
    ///
    /// - Parameter newState: 新的播放器状态
    /// - Note: 根据新的状态进行对应的播放或暂停操作，避免重复状态更新
    private func syncControlsWithPlayerState(to newState: PlayerState) {
        guard playerState != newState else { return }
        
        // 更新播放器状态
        playerState = newState
        controlsView.didUpdatePlayPauseStateInControls(playerState: playerState)
        
        // 根据不同的状态处理是否正在拖动滑块
        isDraggingSlider = (newState == .paused)
        controlsView.didUpdatePlayPauseButtonStateInControls(isPlaying: newState == .playing)
        
        if isLandscape { controlsView.didUpdatePlayerStateInControls(isPlaying: isDraggingSlider) } // 如果是横屏模式
        switch newState {
        case .playing: // 如果是播放状态，隐藏系统控制视图并开始播放
            systemControls.hideVideoPlayerDisplay()
            resumePlayer()
        case .paused: // 如果是暂停状态，暂停播放
            pausePlayer()
            overlayView.pauseDanmaku()
        default:
            break
        }
    }
    
    /// 更新屏幕方向
    ///
    /// - Parameter orientation: 屏幕方向
    /// - Note: 根据屏幕方向更新播放器视图的约束
    public func updateScreenOrientation(for orientation: ScreenOrientation) {
        let sliderValue = controlsView.getSliderPositionInControls()
        isDraggingSlider = true // 设置正在拖动滑块
        overlayView.resizeDanmakuCellPosition(for: orientation) // 更新弹幕位置
        systemControls.updateScreenOrientationInSystemControls(screenOrientation: orientation) // 更新系统控制视图
        controlsView.didTransitionToFullscreenInControls(orientation: orientation, playerState: playerState) // 更新播放控制视图
        controlsView.didResetSliderPositionInControls(value: sliderValue) // 重置滑块值
        controlsView.didUpdatePlaybackTimeInControls(with: currentTime, duration: totalDuration) // 更新时间
        isDraggingSlider = false // 设置拖动滑块
    }
    
    /// 开始弹幕播放
    public func startDanmaku() {
        overlayView.startDanmaku()
        if playerState == .paused { // 如果是暂停状态
            pausePlayer()
            overlayView.pauseDanmaku() // 暂停弹幕
            controlsView.didUpdatePlayPauseButtonStateInControls(isPlaying: false) // 更新播放按钮状态
        }
    }
}
