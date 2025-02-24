//
//  ARTBaseVideoPlayerWrapperView.swift
//  Pods
//
//  Created by mrSir18 on 2024/10/15.
//

import AVFoundation

/// 播放器屏幕方向
@objc public enum ScreenOrientation: Int {
    case portraitFullScreen     = 1 // 竖屏全屏
    case landscapeFullScreen    = 2 // 横屏全屏
    case window                 = 3 // 普通窗口模式
}

/// 播放器状态枚举
@objc public enum PlayerState: Int {
    case buffering              = 1 // 视频加载中
    case waiting                = 2 // 视频等待播放
    case playing                = 3 // 视频正在播放
    case paused                 = 4 // 视频暂停
    case ended                  = 5 // 视频播放结束
    case error                  = 6 // 视频播放错误
    
    var description: String { // 状态描述
        switch self {
        case .buffering: return "视频加载中"
        case .waiting: return "视频等待播放"
        case .playing: return "视频正在播放"
        case .paused: return "视频暂停"
        case .ended: return "视频播放结束"
        case .error: return "视频播放错误"
        }
    }
}

open class ARTBaseVideoPlayerWrapperView: UIView {
    
    /// 视频播放器
    public var player: AVPlayer!
    
    /// 播放器的状态
    public var playerItem: AVPlayerItem!
    
    /// 图片生成器
    public var imageGenerator: AVAssetImageGenerator!
    
    /// 视频预览图缓存
    public var thumbnailCache: [CMTimeHashable: UIImage] = [:]
    
    /// 播放状态
    public var playerState: PlayerState = .buffering
    
    /// 播放器的时间观察者
    public var timeObserverToken: Any?
    
    /// 播放器的时间观察者间隔
    public let interval = CMTimeMake(value: 1, timescale: 5)
    
    /// 上次检测的播放时间
    public var lastCheckTime: Double = 0
    
    /// 播放器当前时间
    public var currentTime: CMTime = .zero
    
    /// 播放器总时长
    public var totalDuration: CMTime = .zero
    
    /// 是否横向全屏
    public var isLandscape: Bool = true
    
    
    // MARK: - 播放器观察者属性
    
    public var statusObserver: NSKeyValueObservation? // 播放器状态观察者
    public var loadedTimeRangesObserver: NSKeyValueObservation? // 加载时间范围观
    public var playbackBufferEmptyObserver: NSKeyValueObservation? // 播放缓冲是否为空观察者
    public var playbackLikelyToKeepUpObserver: NSKeyValueObservation? // 播放可能保持播
    public var presentationSizeObserver: NSKeyValueObservation? // 视频展示尺寸观察者
    public var timeControlStatusObserver: NSKeyValueObservation? // 时间控制状态观察者
    
    
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
    
    /// 播放器观察者
    open func addPlayerObservers() {
        guard let player = player, let playerItem = playerItem else {
            assert(player != nil, "【请先初始化 player 和 playerItem】")
            return
        }
        
        // 设置音频会话类别
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        try? AVAudioSession.sharedInstance().setActive(true)
        
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
        NotificationCenter.default.addObserver(self, selector: #selector(didAudioRouteChanged(_:)), name: AVAudioSession.routeChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        // 添加定时观察者以跟踪播放进度
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            self?.didPlayerProgressDidChange(time: time)
        }
    }
    
    // MARK: - Private KVO Methods
    
    /// 播放器状态变化
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
    
    /// 缓冲进度变化
    private func didLoadedTimeRangesChanged() {
        guard let duration = playerItem?.duration else { return }
        totalDuration = duration
        
        guard let timeRange = playerItem?.loadedTimeRanges.first?.timeRangeValue else { // 如果没有可用的缓冲时间，则返回
            onReceiveLoadedTimeRangesChanged(totalBuffer: 0, bufferProgress: 0)
            return
        }
        let startSeconds = CMTimeGetSeconds(timeRange.start)
        let bufferedDuration = startSeconds + CMTimeGetSeconds(timeRange.duration)
        
        // 计算缓冲进度，确保总时长有效，避免除以零
        let bufferProgress: Float = totalDuration.seconds > 0 ? Float(bufferedDuration / totalDuration.seconds) : 0.0
        onReceiveLoadedTimeRangesChanged(totalBuffer: bufferedDuration, bufferProgress: bufferProgress)
    }
    
    /// 播放缓冲是否为空
    private func didPlaybackBufferEmptyChanged() {
        onReceivePlaybackBufferEmptyChanged()
    }
    
    /// 播放可能性变化
    private func didPlaybackLikelyToKeepUpChanged() {
        if playerItem.isPlaybackLikelyToKeepUp {
            onReceivePlaybackLikelyToKeepUp()
        } else {
            onReceivePlaybackLikelyToKeepUpInsufficient()
        }
    }
    
    /// 视频尺寸变化
    private func didPresentationSizeChanged() {
        onReceivePresentationSizeChanged(size: playerItem.presentationSize)
    }
    
    /// 时间控制状态变化
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
    
    /// 音频路由改变耳机插拔
    @objc private func didAudioRouteChanged(_ notification: Notification) {
        onReceiveAudioRouteChanged(notification)
    }
    
    /// 应用程序进入前台
    @objc private func didBecomeActive(_ notification: Notification) {
        onReceiveBecomeActive(notification)
    }
    
    /// 应用程序进入后台
    @objc private func didEnterBackground(_ notification: Notification) {
        onReceiveEnterBackground(notification)
    }
    
    /// 更新当前播放时间
    /// - Parameter time: 播放时间
    @objc private func didPlayerProgressDidChange(time: CMTime) {
        guard CMTimeGetSeconds(time) > 0, CMTimeGetSeconds(totalDuration) > 0 else {
            return // 防止除零错误
        }
        onReceivePlayerProgressDidChange(time: time)
    }
    
    /// 移除观察者
    private func didRemovePeriodicTimeObserver() {
        onReceiveRemovePeriodicTimeObserver()
    }
    
    // MARK: Public Methods
    
    /// 播放完成
    open func onReceivePlayerItemDidPlayToEnd(_ notification: Notification) {
        playerState = .ended
        print("播放完成")
    }
    
    /// 播放失败
    open func onReceivePlayerItemFailedToPlayToEnd(_ notification: Notification) {
        playerState = .error
        print("播放失败")
    }
    
    /// 处理音频会话中断开始
    open func onReceiveAudioSessionInterruptionBegan(_ notification: Notification) {
        player.pause()
        print("音频会话中断开始")
    }
    
    /// 处理音频会话中断结束
    open func onReceiveAudioSessionInterruptionEnded(_ notification: Notification) {
        player.play()
        print("音频会话中断结束")
    }
    
    /// 音频路由改变耳机插拔
    open func onReceiveAudioRouteChanged(_ notification: Notification) {
        player.play()
        print("音频路由改变耳机插拔")
    }
    
    /// 应用程序进入前台
    open func onReceiveBecomeActive(_ notification: Notification) {
        try? AVAudioSession.sharedInstance().setActive(true)
        player.play()
        print("应用程序进入前台")
    }
    
    /// 应用程序进入后台
    open func onReceiveEnterBackground(_ notification: Notification) {
        try? AVAudioSession.sharedInstance().setActive(false)
        player.pause()
        print("应用程序进入后台")
    }
    
    /// 更新当前播放时间
    /// - Parameter time: 播放时间
    open func onReceivePlayerProgressDidChange(time: CMTime) {
        currentTime = time
        let currentTimeInSeconds = CMTimeGetSeconds(time)
        if abs(currentTimeInSeconds - lastCheckTime) >= 1 { // 判断是否发生快进/后退（假设阈值为1秒） 1秒内不重复执行，方便弹幕等功能
            lastCheckTime = currentTimeInSeconds // 如果当前时间距离上次检查时间超过 1 秒（快进或后退的情况），则更新上次检查时间
            print("当前播放时间: \(lastCheckTime) 秒")
        }
    }
    
    /// 准备播放
    open func onReceivePlayerReadyToPlay() {
        playerState = .waiting
        print("准备播放")
    }
    
    /// 播放器加载失败
    open func onReceivePlayerFailed() {
        playerState = .error
        print("播放器加载失败")
    }
    
    /// 缓冲进度变化
    /// - Parameters:
    ///  - totalBuffer: 总缓冲
    ///  - bufferProgress: 缓冲进度
    open func onReceiveLoadedTimeRangesChanged(totalBuffer: Double, bufferProgress: Float) {
        
    }
    
    /// 缓冲为空
    open func onReceivePlaybackBufferEmptyChanged() {
        
    }
    
    /// 缓冲充足，可以继续播放
    open func onReceivePlaybackLikelyToKeepUp() {
        
    }
    
    /// 缓冲不足，无法继续播放
    open func onReceivePlaybackLikelyToKeepUpInsufficient() {
        
    }
    
    /// 视频尺寸变化
    /// - Parameter size: 当前视频尺寸，最优解决方式从服务端获取视频尺寸，防止视频尺寸变化
    open func onReceivePresentationSizeChanged(size: CGSize) {
        guard size != .zero else { return }
        isLandscape = size.width > size.height // 根据视频尺寸判断是否横屏/竖屏 (全屏)
    }
    
    /// 正在播放
    open func onReceiveTimeControlStatusPlaying() {
        playerState = .playing
        print("正在播放")
    }
    
    /// 播放已暂停
    open func onReceiveTimeControlStatusPaused() {
        if playerState != .ended { playerState = .paused }
        print("播放已暂停")
    }
    
    /// 等待播放
    open func onReceiveTimeControlStatusWaiting() {
        playerState = .waiting
        print("等待播放")
    }
    
    /// 移除时间观察者
    open func onReceiveRemovePeriodicTimeObserver() {
        currentTime = .zero
        totalDuration = .zero
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
