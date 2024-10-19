//
//  ARTBaseVideoPlayerWrapperView.swift
//  Pods
//
//  Created by mrSir18 on 2024/10/15.
//

import AVFoundation

extension ARTBaseVideoPlayerWrapperView {
    
    // 定义常量，存储播放器和播放项的 KeyPath
    struct PlayerObserverKeyPath {
        /// 监听播放器状态
        static let status                   = "status"
        
        /// 监听缓冲进度
        static let loadedTimeRanges         = "loadedTimeRanges"
        
        /// 监听是否为空缓冲
        static let playbackBufferEmpty      = "playbackBufferEmpty"
        
        /// 监听是否可能保持播放
        static let playbackLikelyToKeepUp   = "playbackLikelyToKeepUp"
        
        /// 监听视频尺寸变化
        static let presentationSize         = "presentationSize"
        
        /// 监听时间控制状态 (是否正在播放、暂停等)
        static let timeControlStatus        = "timeControlStatus"
    }
}

open class ARTBaseVideoPlayerWrapperView: UIView {
    
    /// 播放器容器
    public var playerContainer: UIView!
    
    /// 视频播放器
    public var player: AVPlayer!
    
    /// 播放器图层
    public var playerLayer: AVPlayerLayer!
    
    /// 播放器的状态
    public var playerItem: AVPlayerItem!
    
    /// 播放器的播放状态
    public var isPlaying = false
    
    /// 播放器的时间观察者
    public var timeObserverToken: Any?
    
    /// 播放器的时间观察者间隔
    public let interval = CMTime(seconds: 1.0, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
    
    /// 是否正在拖动音量条
    public var isDraggingVolumeSlider = false
    
    /// 是否正在拖动亮度条
    public var isDraggingBrightnessSlider = false
    
    /// 是否正在拖动进度条
    public var isDraggingProgressSlider = false
    
    
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
        
        // 监听播放器状态（播放准备好、播放失败等）
        player.addObserver(self, forKeyPath: PlayerObserverKeyPath.status, options: [.new, .initial], context: nil)
        
        // 监听缓冲进度，确保获取到视频的加载进度
        playerItem.addObserver(self, forKeyPath: PlayerObserverKeyPath.loadedTimeRanges, options: [.new, .initial], context: nil)
        
        // 监听是否处于缓冲状态，适用于判断视频是否可以继续播放
        playerItem.addObserver(self, forKeyPath: PlayerObserverKeyPath.playbackBufferEmpty, options: [.new, .initial], context: nil)
        
        // 监听是否可能保持播放，用于优化播放体验，减少卡顿
        playerItem.addObserver(self, forKeyPath: PlayerObserverKeyPath.playbackLikelyToKeepUp, options: [.new, .initial], context: nil)
        
        // 监听视频的分辨率或尺寸变化
        playerItem.addObserver(self, forKeyPath: PlayerObserverKeyPath.presentationSize, options: [.new, .initial], context: nil)
        
        // 监听时间控制状态（正在播放、暂停、自动暂停）
        player.addObserver(self, forKeyPath: PlayerObserverKeyPath.timeControlStatus, options: [.new, .initial], context: nil)
        
        // 监听播放完成
        NotificationCenter.default.addObserver(self, selector: #selector(didPlayerItemDidPlayToEnd(_:)), name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
        
        // 监听播放失败
        NotificationCenter.default.addObserver(self, selector: #selector(didPlayerItemFailedToPlayToEnd(_:)), name: .AVPlayerItemFailedToPlayToEndTime, object: playerItem)
        
        // 监听播放中断（如电话打断）
        NotificationCenter.default.addObserver(self, selector: #selector(didAudioSessionInterrupted(_:)), name: AVAudioSession.interruptionNotification, object: nil)
        
        // 添加观察者以跟踪播放器的当前时间
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            self?.didPlayerProgressDidChange(time: time)
        }
    }
    
    // MARK: - Override KVO Methods
    
    /// 添加观察者
    ///
    /// - Parameters:
    ///  - keyPath: 观察的属性
    ///  - object: 观察的对象
    ///  - change: 属性变化
    ///  - context: 上下文
    ///  - Note: 重写此方法，监听播放器的状态
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        switch keyPath {
        case PlayerObserverKeyPath.status: // 监听播放器状态
            didPlayerStatusChanged(change: change)
            
        case PlayerObserverKeyPath.loadedTimeRanges: // 监听缓冲进度
            didLoadedTimeRangesChanged(change: change)
            
        case PlayerObserverKeyPath.playbackBufferEmpty: // 监听是否为空缓冲
            didPlaybackBufferEmptyChanged(change: change)
            
        case PlayerObserverKeyPath.playbackLikelyToKeepUp: // 监听是否可能保持播放
            didPlaybackLikelyToKeepUpChanged(change: change)
            
        case PlayerObserverKeyPath.presentationSize: // 监听视频尺寸变化
            didPresentationSizeChanged(change: change)
            
        case PlayerObserverKeyPath.timeControlStatus: // 监听时间控制状态
            didTimeControlStatusChanged(change: change)
            
        default:
            break
        }
    }
    
    // MARK: - Private KVO Methods
    
    /// 处理播放器状态变化
    private func didPlayerStatusChanged(change: [NSKeyValueChangeKey: Any]?) {
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
    private func didLoadedTimeRangesChanged(change: [NSKeyValueChangeKey: Any]?) {
        let timeRanges = playerItem.loadedTimeRanges
        if let timeRange = timeRanges.first?.timeRangeValue {
            let start = CMTimeGetSeconds(timeRange.start)
            let duration = CMTimeGetSeconds(timeRange.duration)
            let totalBuffer = start + duration
            onReceiveLoadedTimeRangesChanged(totalBuffer: totalBuffer)
        }
    }
    
    /// 处理播放缓冲是否为空
    private func didPlaybackBufferEmptyChanged(change: [NSKeyValueChangeKey: Any]?) {
        onReceivePlaybackBufferEmptyChanged()
    }
    
    /// 处理播放可能性变化
    private func didPlaybackLikelyToKeepUpChanged(change: [NSKeyValueChangeKey: Any]?) {
        if playerItem.isPlaybackLikelyToKeepUp {
            onReceivePlaybackLikelyToKeepUp()
        } else {
            onReceivePlaybackLikelyToKeepUpInsufficient()
        }
    }
    
    /// 处理视频尺寸变化
    private func didPresentationSizeChanged(change: [NSKeyValueChangeKey: Any]?) {
        onReceivePresentationSizeChanged(size: playerItem.presentationSize)
    }
    
    /// 处理时间控制状态变化
    private func didTimeControlStatusChanged(change: [NSKeyValueChangeKey: Any]?) {
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
        /// 子类重写: 处理播放完成
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
    
    /// 播放视频
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
    
    /// 更新播放时间
    ///
    /// - Parameter time: 当前播放时间
    /// - Note: 子类重写此方法，更新播放时间
    open func onReceivePlayerProgressDidChange(time: CMTime) {
        print("当前播放时间: \(time) 秒")
    }
    
    /// 播放器准备好时的处理
    ///
    /// - Note: 子类重写此方法以处理播放器准备好后的逻辑
    open func onReceivePlayerReadyToPlay() {
        player.play()
        print("播放器准备好了")
    }
    
    /// 播放器加载失败时的处理
    ///
    /// - Note: 子类重写此方法以处理播放器加载失败后的逻辑
    open func onReceivePlayerFailed() {
        print("播放器加载失败")
    }
    
    /// 处理缓冲进度变化
    ///
    /// - Parameter totalBuffer: 当前缓冲的总时间
    /// - Note: 子类重写此方法以处理缓冲进度变化
    open func onReceiveLoadedTimeRangesChanged(totalBuffer: Double) {
        print("缓冲进度：\(totalBuffer)")
    }
    
    /// 处理缓冲是否为空
    ///
    /// - Note: 子类重写此方法以处理缓
    open func onReceivePlaybackBufferEmptyChanged() {
        print("缓冲为空")
    }
    
    /// 处理缓冲可保持播放的
    ///
    /// - Note: 子类重写此方法以处理缓冲可保持播放的情况
    open func onReceivePlaybackLikelyToKeepUp() {
        print("缓冲可保持播放")
    }
    
    /// 处理缓冲不足，可能无法继续播放
    ///
    /// - Note: 子类重写此方法以处理缓冲不足，可能无法继续播放
    open func onReceivePlaybackLikelyToKeepUpInsufficient() {
        print("缓冲不足，可能无法继续播放")
    }
    
    /// 处理视频尺寸变化
    ///
    /// - Parameter size: 当前视频尺寸
    /// - Note: 子类重写此方法以处理视频尺寸变化
    open func onReceivePresentationSizeChanged(size: CGSize) {
        print("视频尺寸：\(size.width)x\(size.height)")
    }
    
    /// 处理播放器正在播放状态
    ///
    /// - Note: 子类重写此方法，处理播放器正在播放状态
    open func onReceiveTimeControlStatusPlaying() {
        print("播放器正在播放")
    }
    
    /// 处理播放器已暂停状态
    ///
    /// - Note: 子类重写此方法，处理播
    open func onReceiveTimeControlStatusPaused() {
        print("播放器已暂停")
    }
    
    /// 处理播放器正在等待状态
    ///
    /// - Note: 子类重写此方法，处理播放器正在等待状态
    open func onReceiveTimeControlStatusWaiting() {
        print("播放器正在等待")
    }
    
    /// 移除时间观察者
    open func onReceiveRemovePeriodicTimeObserver() {
        /// 子类重写: 移除时间观察者
        if let timeObserverToken = timeObserverToken {
            player?.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
        print("移除时间观察")
    }
    
    // MARK: - remove Observers
    
    deinit {
        // 移除播放器状态监听
        player.removeObserver(self, forKeyPath: PlayerObserverKeyPath.status)
        
        // 移除缓冲进度监听
        playerItem.removeObserver(self, forKeyPath: PlayerObserverKeyPath.loadedTimeRanges)
        
        // 移除缓冲空状态监听
        playerItem.removeObserver(self, forKeyPath: PlayerObserverKeyPath.playbackBufferEmpty)
        
        // 移除可能保持播放状态监听
        playerItem.removeObserver(self, forKeyPath: PlayerObserverKeyPath.playbackLikelyToKeepUp)
        
        // 移除视频尺寸变化监听
        playerItem.removeObserver(self, forKeyPath: PlayerObserverKeyPath.presentationSize)
        
        // 移除时间控制状态监听
        player.removeObserver(self, forKeyPath: PlayerObserverKeyPath.timeControlStatus)
        
        // 移除播放完成监听
        didRemovePeriodicTimeObserver()
        
        // 移除播放完成通知
        NotificationCenter.default.removeObserver(self)
    }
}
