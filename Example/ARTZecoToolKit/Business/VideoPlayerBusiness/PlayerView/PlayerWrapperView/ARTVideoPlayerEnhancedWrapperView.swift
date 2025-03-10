//
//  ARTVideoPlayerEnhancedWrapperView.swift
//  ARTZeco
//
//  Created by mrSir18 on 2024/10/15.
//

import AVFoundation
import ARTZecoToolKit

class ARTVideoPlayerEnhancedWrapperView: ARTVideoPlayerWrapperView {
    
    // MARK: - Private Properties
    
    /// 代理对象
    public weak var delegate: ARTVideoPlayerEnhancedWrapperViewDelegate?

    /// 屏幕模式
    public var screenOrientation: ScreenOrientation = .window
    
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
    
    
    // TODO: 模拟 - 弹幕时间戳匹配功能
    
    /// 弹幕时间戳 [时间]
    public var timestamps: [Double] = [2.0, 3.5, 5.0, 5.3, 6.0, 7.1, 10.0, 15.0, 28.0, 40.0, 52.0, 60.0, 61.0, 75.0, 80.0]
    
    /// 已匹配的时间戳 [时间段索引: 时间]
    public var matchedTimestamps: [Int: Set<Double>] = [:]
    
    /// 分割弹幕时间段 [时间段索引: 时间] 5秒为一个时间段
    public let segmentDuration: Double = 5.0
    
    
    // MARK: - Initialization
    
    public init(_ delegate: ARTVideoPlayerEnhancedWrapperViewDelegate) {
        self.delegate = delegate
        super.init()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Setup Methods
    
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
        systemControls = ARTVideoPlayerSystemControls()
        addSubview(systemControls)
        systemControls.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    /// 创建加载动画视图
    override func setupLoadingView() {
        loadingView = ARTVideoPlayerLoadingView()
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
        matchedTimestamps = [:]
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
    
    override func onReceiveDanmaku(atTime currentTime: Double) { // 收到弹幕
        if screenOrientation == .window { return } // 屏幕模式，全屏下展示弹幕
    
        let tolerance: Double = 2.0 // 容差范围，±2秒内匹配
        
        // 计算当前时间所在的时间段，使用半开区间 [start, end) 的方式
        let segmentIndex = Int(currentTime / segmentDuration)
        
        // 计算当前时间段的起始和结束时间（左闭右开区间）
        let segmentStart = Double(segmentIndex) * segmentDuration
        let segmentEnd = segmentStart + segmentDuration
        
        // 获取当前时间段已匹配的时间戳集合
        var matchedForSegment = matchedTimestamps[segmentIndex] ?? Set<Double>()
        
        // 使用二分查找获取与当前时间最接近的所有时间戳
        let nearbyTimestamps = binarySearch(arr: timestamps, target: currentTime, tolerance: tolerance)
        
        // 只遍历一次，进行条件检查和插入
        var newMatchedTimestamps: [Double] = []
        
        for timestamp in nearbyTimestamps {
            // 如果匹配的时间戳在当前时间段内，并且是新的时间戳（未匹配过）
            if timestamp >= segmentStart && timestamp < segmentEnd && matchedForSegment.insert(timestamp).inserted {
                newMatchedTimestamps.append(timestamp)
            }
        }
        
        if !newMatchedTimestamps.isEmpty {
            matchedTimestamps[segmentIndex] = matchedForSegment
            for _ in newMatchedTimestamps { overlayView.addDanmaku(ARTEnhancedDanmakuCell()) }
        }
    }
    
    override func didUpdateCurrentTime(currentTime: CMTime) {
        let formattedTime = currentTime.art_formattedTime()
        guard let seconds = formattedTime.art_secondsFromFormattedTime() else { return }
        overlayView.stopDanmaku() // 重置弹幕
        let segmentIndex = Int(seconds / segmentDuration) // 计算当前时间所在的时间段索引
        for index in matchedTimestamps.keys where index >= segmentIndex { // 清理当前时间以及之后的所有时间段
            let segmentStart = Double(index) * segmentDuration
            let segmentEnd = segmentStart + segmentDuration
            if segmentEnd >= seconds { matchedTimestamps.removeValue(forKey: index) } // 如果当前时间段结束时间大于当前时间，移除该时间段
        }
        overlayView.startDanmaku() // 启动弹幕
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
    
    override func onReceiveAudioSessionInterruptionBegan(_ notification: Notification) { /// 处理音频会话中断开始
        super.onReceiveAudioSessionInterruptionBegan(notification)
        syncControlsWithPlayerState(to: .paused)
    }
    
    override func onReceiveAudioSessionInterruptionEnded(_ notification: Notification) { /// 处理音频会话中断结束
        super.onReceiveAudioSessionInterruptionEnded(notification)
        if playerState == .paused { togglePlayerState() }
    }
    
    override func onReceiveAudioRouteChanged(_ notification: Notification) { /// 音频路由改变耳机插拔
        super.onReceiveAudioRouteChanged(notification)
        syncControlsWithPlayerState(to: .paused)
    }
    
    override func onReceiveBecomeActive(_ notification: Notification) { // 应用进入前台
        super.onReceiveBecomeActive(notification)
        if playerState == .paused { togglePlayerState() }
    }
    
    override func onReceiveEnterBackground(_ notification: Notification) { // 应用进入后台
        super.onReceiveEnterBackground(notification)
        syncControlsWithPlayerState(to: .paused)
    }
}

// MARK: - 重写点击手势

extension ARTVideoPlayerEnhancedWrapperView {
    
    /// 默认无需重写点击手势
    /// - Note: 根据个人业务定制点击手势，特殊需求处理.window
    override func handleTapGesture(_ gesture: UITapGestureRecognizer) { // 点击手势
        let currentTime = Date().timeIntervalSince1970
        if currentTime - lastTapTime < doubleTapDelay { // 双击事件
            guard isLandscape || screenOrientation == .window else { return }
            didReceivewDoubleTapGesture() // 通知外部双击事件
            
        } else { // 单击事件
            let location = gesture.location(in: self)
            didReceiveTapGesture(at: location) // 通知外部点击事件
        }
        lastTapTime = currentTime // 更新上次点击的时间
    }
}

// MARK: - 发送消息给外部

extension ARTVideoPlayerEnhancedWrapperView {
    
    override func didPrepareForNextVideo() { // 准备好播放下一集
        controlsView.didUpdatePlayPauseStateInControls(playerState: playerState) // 更新播放按钮状态
        isDraggingSlider = true // 设置正在拖动状态
        overlayView.stopDanmaku() // 停止弹幕
        controlsView.didResetSliderPositionInControls() // 重置进度条时间
    }
    
    override func didCompleteSetupForNextVideo() { // 播放下一集
        isDraggingSlider = (playerState == .paused) // 设置拖动滑块状态
        let hiddenStates: Set<PlayerState> = [.buffering, .waiting, .playing, .error]
        controlsView.didUpdatePlayPauseButtonStateInControls(isPlaying: hiddenStates.contains(playerState))
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
        guard playerState != .buffering else { return }
        controlsView.didBeginSliderTouchInControls(sliderValue: sliderValue)
    }
    
    override func didReceiveSliderValue(sliderValue: Float) { // 滑动过程中调用
        guard playerState != .buffering else { return }
        controlsView.didUpdateSliderPositionInControls(sliderValue: sliderValue)
    }
    
    override func didReceiveSliderTouchEnded(sliderValue: Float) { // 触摸结束时调用
        guard playerState != .buffering else { return }
        controlsView.didEndSliderTouchInControls(sliderValue: sliderValue)
    }
    
    override func didReceiveTapGesture(at location: CGPoint) { // 点击手势
        guard playerState != .buffering else { return }
        if overlayView.handleTapOnOverlay(at: location) { return } // 如果弹幕视图处理了点击事件，直接返回
        if isLandscape || screenOrientation == .window { // 如果是横屏模式，切换控制
            controlsView.didToggleControlsVisibilityInControls()
        } else { // 如果是竖屏模
            togglePlayerState()
        }
        print("屏幕模式：\(screenOrientation.rawValue)")
    }
    
    override func didReceivewDoubleTapGesture() { // 双击手势
        togglePlayerState()
    }
}

// MARK: - Public Methods

extension ARTVideoPlayerEnhancedWrapperView {
    
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
        // 更新播放器状态
        playerState = newState
        controlsView.didUpdatePlayPauseStateInControls(playerState: playerState)
        
        // 根据不同的状态处理是否正在拖动滑块
        isDraggingSlider = (newState == .paused)
        let hiddenStates: Set<PlayerState> = [.buffering, .waiting, .playing, .error]
        controlsView.didUpdatePlayPauseButtonStateInControls(isPlaying: hiddenStates.contains(newState))
        
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
        screenOrientation = orientation
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

// MARK: - Private Methods

extension ARTVideoPlayerEnhancedWrapperView {
    
    /// 二分查找算法
    /// - Parameters:
    ///   - arr: 已排序的数组
    ///   - target: 目标时间戳
    ///   - tolerance: 容差范围，±该值内的时间戳视为匹配
    /// - Returns: 返回所有与目标时间戳匹配的时间戳（按升序排列）
    /// - Note: 该算法用于查找与目标时间戳最接近的时间戳，支持容差范围匹配
    func binarySearch(arr: [Double], target: Double, tolerance: Double) -> [Double] {
        var low = 0
        var high = arr.count - 1
        var result: [Double] = []
        while low <= high {
            let mid = low + (high - low) / 2
            let midValue = arr[mid]
            
            if abs(midValue - target) <= tolerance { // 如果时间戳在容差范围内，添加到结果中
                result.append(midValue)
            }
            
            // 关系调整查找范围
            if midValue == target {
                break // 找到目标值，提前退出
            } else if midValue < target {
                low = mid + 1 // 调整左边界
            } else {
                high = mid - 1 // 调整右边界
            }
        }
        
        return result.sorted() // 返回升序排列的匹配时间戳
    }
}
