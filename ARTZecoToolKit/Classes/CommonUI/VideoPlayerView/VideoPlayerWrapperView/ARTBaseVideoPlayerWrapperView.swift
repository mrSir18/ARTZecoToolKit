//
//  ARTBaseVideoPlayerWrapperView.swift
//  Pods
//
//  Created by mrSir18 on 2024/10/15.
//

import AVFoundation

/// 播放器当前的屏幕方向
@objc public enum ScreenOrientation: Int {
    case portraitFullScreen     = 1 // 竖屏全屏
    case landscapeFullScreen    = 2 // 横屏全屏
    case window                 = 3 // 普通窗口模式
}

open class ARTBaseVideoPlayerWrapperView: UIView {
    
    /// 视频播放器
    public var player: AVPlayer!
    
    /// 播放器图层
    public var playerLayer: AVPlayerLayer!
    
    /// 播放器的状态
    public var playerItem: AVPlayerItem!
    
    /// 图片生成器
    public var imageGenerator: AVAssetImageGenerator!
    
    /// 视频预览图缓存
    public var thumbnailCache: [CMTimeHashable: UIImage] = [:]
    
    /// 播放器的播放状态
    public var isPlaying = false
    
    /// 是否正在拖动音量条
    public var isDraggingVolumeSlider = false
    
    /// 是否正在拖动亮度条
    public var isDraggingBrightnessSlider = false
    
    /// 是否正在拖动进度条
    public var isDraggingSlider = false
    
    /// 播放器的时间观察者
    public var timeObserverToken: Any?
    
    /// 播放器的时间观察者间隔
    public let interval = CMTime(seconds: 0.2, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
    
    /// 播放器总时长
    public var totalDuration: Double = 0.0
    
    // MARK: - 播放器观察者属性
    
    public var statusObserver: NSKeyValueObservation?
    public var loadedTimeRangesObserver: NSKeyValueObservation?
    public var playbackBufferEmptyObserver: NSKeyValueObservation?
    public var playbackLikelyToKeepUpObserver: NSKeyValueObservation?
    public var presentationSizeObserver: NSKeyValueObservation?
    public var timeControlStatusObserver: NSKeyValueObservation?
    
    
    // MARK: - Initialization
    
    public init() {
        super.init(frame: .zero)
        self.backgroundColor = .black
        setupViews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setupViews() {
        /// 子类重写: 设置视图
    }
    
    // MARK: - add Observers
    
    /// 添加播放器的观察者
    ///
    /// - Note: 类重写此方法，添加播放器的观察者
    open func addPlayerObservers() {
        guard let player = player, let playerItem = playerItem else {
            assert(player != nil, "【请先初始化 player 和 playerItem】")
            return
        }

        // 观察播放器状态变化（例如，准备播放、播放失败）
        statusObserver = player.observe(\.status, options: [.new, .initial]) { [weak self] player, change in
            self?.didPlayerStatusChanged()
        }
        
        // 观察加载时间范围以跟踪缓冲进度
        loadedTimeRangesObserver = playerItem.observe(\.loadedTimeRanges, options: [.new, .initial]) { [weak self] playerItem, change in
            self?.didLoadedTimeRangesChanged()
        }

        // 观察播放缓冲是否为空
        playbackBufferEmptyObserver = playerItem.observe(\.isPlaybackBufferEmpty, options: [.new, .initial]) { [weak self] playerItem, change in
            self?.didPlaybackBufferEmptyChanged()
        }

        // 观察是否可能保持播放
        playbackLikelyToKeepUpObserver = playerItem.observe(\.isPlaybackLikelyToKeepUp, options: [.new, .initial]) { [weak self] playerItem, change in
            self?.didPlaybackLikelyToKeepUpChanged()
        }

        // 观察视频的展示尺寸（分辨率）变化
        presentationSizeObserver = playerItem.observe(\.presentationSize, options: [.new, .initial]) { [weak self] playerItem, change in
            self?.didPresentationSizeChanged()
        }

        // 观察时间控制状态（例如，播放、暂停）
        timeControlStatusObserver = player.observe(\.timeControlStatus, options: [.new, .initial]) { [weak self] player, change in
            self?.didTimeControlStatusChanged()
        }

        // 监听播放器项目事件的通知
        NotificationCenter.default.addObserver(self, selector: #selector(didPlayerItemDidPlayToEnd(_:)), name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
        NotificationCenter.default.addObserver(self, selector: #selector(didPlayerItemFailedToPlayToEnd(_:)), name: .AVPlayerItemFailedToPlayToEndTime, object: playerItem)
        NotificationCenter.default.addObserver(self, selector: #selector(didAudioSessionInterrupted(_:)), name: AVAudioSession.interruptionNotification, object: nil)

        // 添加定时观察者以跟踪播放进度
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            self?.didPlayerProgressDidChange(time: time)
        }
    }
    
    // MARK: - Private KVO Methods
    
    /// 处理播放器状态变化
    private func didPlayerStatusChanged() {
        switch player.status {
        case .readyToPlay:
            onReceivePlayerReadyToPlay()
            
        case .failed:
            onReceivePlayerFailed()
        default:
            break
        }
    }
    
    /// 处理缓冲进度变化
    private func didLoadedTimeRangesChanged() {
        guard let duration = playerItem?.duration else { return }
        totalDuration = CMTimeGetSeconds(duration)

        guard let timeRange = playerItem?.loadedTimeRanges.first?.timeRangeValue else { // 如果没有可用的缓冲时间，则返回
            onReceiveLoadedTimeRangesChanged(totalBuffer: 0, bufferProgress: 0)
            return
        }
        let startSeconds = CMTimeGetSeconds(timeRange.start)
        let bufferedDuration = startSeconds + CMTimeGetSeconds(timeRange.duration)

        // 计算缓冲进度，确保总时长有效，避免除以零
        let bufferProgress: Float = totalDuration > 0 ? Float(bufferedDuration / totalDuration) : 0.0
        onReceiveLoadedTimeRangesChanged(totalBuffer: bufferedDuration, bufferProgress: bufferProgress)
    }

    /// 处理播放缓冲是否为空
    private func didPlaybackBufferEmptyChanged() {
        onReceivePlaybackBufferEmptyChanged()
    }
    
    /// 处理播放可能性变化
    private func didPlaybackLikelyToKeepUpChanged() {
        if playerItem.isPlaybackLikelyToKeepUp {
            onReceivePlaybackLikelyToKeepUp()
        } else {
            onReceivePlaybackLikelyToKeepUpInsufficient()
        }
    }
    
    /// 处理视频尺寸变化
    private func didPresentationSizeChanged() {
        onReceivePresentationSizeChanged(size: playerItem.presentationSize)
    }
    
    /// 处理时间控制状态变化
    private func didTimeControlStatusChanged() {
        switch player.timeControlStatus {
        case .playing:
            onReceiveTimeControlStatusPlaying()
            
        case .paused:
            onReceiveTimeControlStatusPaused()
            
        case .waitingToPlayAtSpecifiedRate:
            onReceiveTimeControlStatusWaiting()
        default:
            break
        }
    }
    
    /// 播放完成的处理
    @objc private func didPlayerItemDidPlayToEnd(_ notification: Notification) {
        onReceivePlayerItemDidPlayToEnd(notification)
    }
    
    /// 播放失败的处理
    @objc private func didPlayerItemFailedToPlayToEnd(_ notification: Notification) {
        onReceivePlayerItemFailedToPlayToEnd(notification)
    }
    
    /// 音频会话中断的处理
    @objc private func didAudioSessionInterrupted(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let interruptionType = AVAudioSession.InterruptionType(rawValue: typeValue) else { // 获取通知中的用户信息
            return
        }
        
        switch interruptionType {
        case .began: // 音频会话中断开始
            onReceiveAudioSessionInterruptionBegan(notification)
            
        case .ended: // 音频会话中断结束
            if let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt { // 检查中断结束时的选项
                let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
                if options.contains(.shouldResume) { // 如果选项包含应恢复播放，则继续播放
                    onReceiveAudioSessionInterruptionEnded(notification)
                }
            }
        @unknown default:
            break
        }
    }
    
    /// 当前播放时间
    ///
    /// - Parameter time: 当前播放时间
    @objc private func didPlayerProgressDidChange(time: CMTime) {
        onReceivePlayerProgressDidChange(time: time)
    }
    
    /// 移除观察者
    private func didRemovePeriodicTimeObserver() {
        onReceiveRemovePeriodicTimeObserver()
    }
    
    // MARK: Public Methods
    
    /// 播放完成
    ///
    /// - Parameter notification: 通知
    /// - Note: 子类重写此方法，处理播放完成
    open func onReceivePlayerItemDidPlayToEnd(_ notification: Notification) {
        print("播放完成")
    }
    
    /// 播放失败
    ///
    /// - Parameter notification: 通知
    /// - Note: 子类重写此方法，处理播放完成
    open func onReceivePlayerItemFailedToPlayToEnd(_ notification: Notification) {
        print("播放失败")
    }
    
    /// 音频会话中断开始
    ///
    /// - Parameter notification: 通知
    /// - Note: 子类重写此方法，处理音频会话中断开始
    open func onReceiveAudioSessionInterruptionBegan(_ notification: Notification) {
        player.pause()
        print("音频会话中断开始")
    }
    
    /// 音频会话中断结束
    ///
    /// - Parameter notification: 通知
    /// - Note: 子类重写此方法，处理音频会话中断结束
    open func onReceiveAudioSessionInterruptionEnded(_ notification: Notification) {
        player.play()
        print("音频会话中断结束")
    }
    
    /// 当前播放时间
    ///
    /// - Parameter time: 当前播放时间
    /// - Note: 子类重写此方法，更新播放时间
    open func onReceivePlayerProgressDidChange(time: CMTime) {

    }
    
    /// 准备播放
    ///
    /// - Note: 子类重写此方法以处理播放器准备好后的逻辑
    open func onReceivePlayerReadyToPlay() {
        print("准备播放")
    }
    
    /// 播放器加载失败
    ///
    /// - Note: 子类重写此方法以处理播放器加载失败后的逻辑
    open func onReceivePlayerFailed() {
        print("播放器加载失败")
    }
    
    /// 缓冲进度变化
    ///
    /// - Parameters:
    ///  - totalBuffer: 缓冲总时间
    ///  - bufferProgress: 缓冲进度
    /// - Note: 子类重写此方法以处理缓冲进度变化
    open func onReceiveLoadedTimeRangesChanged(totalBuffer: Double, bufferProgress: Float) {
   
    }
    
    /// 缓冲为空
    ///
    /// - Note: 子类重写此方法以处理缓
    open func onReceivePlaybackBufferEmptyChanged() {
        
    }
    
    /// 缓冲可保持播放
    ///
    /// - Note: 子类重写此方法以处理缓冲可保持播放的情况
    open func onReceivePlaybackLikelyToKeepUp() {
    
    }
    
    /// 处理缓冲不足，可能无法继续播放
    ///
    /// - Note: 子类重写此方法以处理缓冲不足，可能无法继续播放
    open func onReceivePlaybackLikelyToKeepUpInsufficient() {
        
    }
    
    /// 视频尺寸变化
    ///
    /// - Parameter size: 当前视频尺寸，最优解决方式从服务端获取视频尺寸，防止视频尺寸变化
    /// - Note: 子类重写此方法以处理视频尺寸变化
    open func onReceivePresentationSizeChanged(size: CGSize) {
        
    }
    
    /// 正在播放
    ///
    /// - Note: 子类重写此方法，处理播放器正在播放状态
    open func onReceiveTimeControlStatusPlaying() {
        print("正在播放")
    }
    
    /// 播放已暂停
    ///
    /// - Note: 子类重写此方法，处理播
    open func onReceiveTimeControlStatusPaused() {
        print("播放器已暂停")
    }
    
    /// 等待播放
    ///
    /// - Note: 子类重写此方法，处理播放器正在等待状态
    open func onReceiveTimeControlStatusWaiting() {
        
    }
    
    /// 移除时间观察者
    ///
    /// - Note: 子类重写: 移除时间观察者
    open func onReceiveRemovePeriodicTimeObserver() {
        statusObserver?.invalidate()
        loadedTimeRangesObserver?.invalidate()
        playbackBufferEmptyObserver?.invalidate()
        playbackLikelyToKeepUpObserver?.invalidate()
        presentationSizeObserver?.invalidate()
        timeControlStatusObserver?.invalidate()
        if let timeObserverToken = timeObserverToken {
            player?.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
        NotificationCenter.default.removeObserver(self)
        print("移除时间观察")
    }
    
    // MARK: - remove Observers
    
    deinit { // 移除播放完成监听
        didRemovePeriodicTimeObserver()
    }
}
