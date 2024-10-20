//
//  ARTVideoPlayerWrapperView.swift
//  Pods
//
//  Created by mrSir18 on 2024/10/15.
//

import AVFoundation

@objc public protocol ARTVideoPlayerWrapperViewProtocol: AnyObject {
    
    /// 自定义播放模式
    ///
    /// - Parameters:
    ///   - playerWrapperView: 视频播放器视图
    ///   - Returns: 自定义播放模式
    ///   - Note: 自定义播放模式 ARTVideoPlayerWrapperView.VideoPlayerMode
    //    @objc optional func customScreenOrientation(for playerWrapperView: ARTVideoPlayerWrapperView) -> ARTVideoPlayerWrapperView.ScreenOrientation
    //
    //    /// 自定义顶部工具栏视图
    //    ///
    //    /// - Parameters:
    //    ///   - playerWrapperView: 视频播放器视图
    //    ///   - screenOrientation: 当前屏幕方向
    //    ///   - Returns: 自定义顶部工具栏视图
    //    ///   - Note: 自定义顶部工具栏视图需继承 ARTVideoPlayerTopbar
    //    @objc optional func customTopBar(for playerWrapperView: ARTVideoPlayerWrapperView, screenOrientation: ARTVideoPlayerWrapperView.ScreenOrientation) -> ARTVideoPlayerTopbar?
    //
    //    /// 自定义底部工具栏视图
    //    ///
    //    /// - Parameters:
    //    ///   - playerWrapperView: 视频播放器视图
    //    ///   - screenOrientation: 当前屏幕方向
    //    ///   - Returns: 自定义底部工具栏视图
    //    ///   - Note: 自定义底部工具栏视图需继承 ARTVideoPlayerBottombar
    //    @objc optional func customBottomBar(for playerWrapperView: ARTVideoPlayerWrapperView, screenOrientation: ARTVideoPlayerWrapperView.ScreenOrientation) -> ARTVideoPlayerBottombar?
    //
    //    /// 刷新状态栏外观
    //    ///
    //    /// - Parameters:
    //    ///   - playerWrapperView: 视频播放器视图
    //    ///   - isStatusBarHidden: 是否隐藏状态栏的状态
    //    ///   - Note: 调用此方法以更新状态栏外观
    //    @objc optional func refreshStatusBarAppearance(for playerWrapperView: ARTVideoPlayerWrapperView, isStatusBarHidden: Bool)
}

open class ARTVideoPlayerWrapperView: ARTBaseVideoPlayerWrapperView {
    
    // MARK: - Private Properties
    
    /// 代理对象
    private weak var delegate: ARTVideoPlayerWrapperViewProtocol?
    
    /// 全屏管理器
    private var fullscreenManager: ARTVideoFullscreenManager!
    
    /// 播放器配置模型
    public var playerConfig: ARTVideoPlayerConfig!
    
    
    // MARK: - 播放器组件 AVPlayer（最底层：播放器视图）
    
    /// 播放器图层（中间层：用于显示弹幕、广告等）
    private var playerOverlayView: ARTVideoPlayerOverlayView!
    
    /// 播放器控制层（最顶层：顶底栏、侧边栏等）
    private var playControlsView: ARTVideoPlayerControlsView!
    
    
    // MARK: - Initialization
    
    public init(_ delegate: ARTVideoPlayerWrapperViewProtocol) {
        self.delegate = delegate
        super.init()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Override Methods
    
    open override func setupViews() {
        super.setupViews()
        setupFullscreenManager()
        setupOverlayView()
        setupControlsView()
    }
    
    open override func onReceivePlayerFailed() { // 播放器加载失败
        super.onReceivePlayerFailed()
    }
    
    open override func onReceivePlayerReadyToPlay() { // 播放器准备好
        super.onReceivePlayerReadyToPlay()
        player.play()
    }
    
    open override func onReceiveLoadedTimeRangesChanged(totalBuffer: Double, bufferProgress: Float) { // 缓冲进度
        super.onReceiveLoadedTimeRangesChanged(totalBuffer: totalBuffer, bufferProgress: bufferProgress)
        playControlsView.updateBufferProgressInControls(totalBuffer: totalBuffer,
                                                        bufferProgress: bufferProgress,
                                                        shouldUpdateSlider: isDraggingSlider)
    }
    
    open override func onReceivePlayerProgressDidChange(time: CMTime) { // 更新播放时间
        super.onReceivePlayerProgressDidChange(time: time)
        let duration = player.currentItem?.duration ?? interval // 获取当前视频的时长
        guard CMTimeGetSeconds(time) > 0, CMTimeGetSeconds(duration) > 0 else {
            return // 防止除零错误
        }
        playControlsView.updateTimeInControls(with: time,
                                              duration: duration,
                                              shouldUpdateSlider: isDraggingSlider)
    }
    
    open override func onReceivePresentationSizeChanged(size: CGSize) { // 视频尺寸变化，最优方案根据服务器返回的视频尺寸判断是否横屏/竖屏 (全屏)
        super.onReceivePresentationSizeChanged(size: size)
        guard size != .zero else { return }
        playerConfig.isLandscape = size.width > size.height // 根据视频尺寸判断是否横屏/竖屏 (全屏)
        playControlsView.isLandscape = playerConfig.isLandscape
    }
    
    open override func onReceiveTimeControlStatusPlaying() { // 播放器正在播放
        super.onReceiveTimeControlStatusPlaying()
    }
    
    open override func onReceiveTimeControlStatusPaused() { // 播放器已暂停
        super.onReceiveTimeControlStatusPaused()
    }
    
    open override func onReceiveTimeControlStatusWaiting() { // 播放器正在等待
        super.onReceiveTimeControlStatusWaiting()
    }
    
    open override func onReceivePlayerItemDidPlayToEnd(_ notification: Notification) { // 播放完成
        super.onReceivePlayerItemDidPlayToEnd(notification)
    }
    
    open override func onReceivePlayerItemFailedToPlayToEnd(_ notification: Notification) { // 播放失败
        super.onReceivePlayerItemFailedToPlayToEnd(notification)
    }
    
    // MARK: - Public Methods
    
    /// 开始播放视频
    ///
    /// - Parameter config: 视频播放器配置模型
    /// - Note: 重写父类方法，播放视频
    open func startVideoPlayback(with config: ARTVideoPlayerConfig?) {
        guard let config = config, let url = config.url else {
            print("无效的视频配置或 URL。")
            return
        }
        playerConfig = config
        setupPreparePlayer(with: url)
        addPlayerObservers()
    }
    
    /// 播放下一集视频
    ///
    /// - Parameter url: 新的视频 URL
    /// - Note: 重写父类方法，播放下一集视频
    open func playNextVideo(with url: URL) {
        playerItem = AVPlayerItem(asset: AVAsset(url: url))
        player?.replaceCurrentItem(with: playerItem)
        player?.play()
    }
    
    /// 指定播放时间
    ///
    /// - Parameters:
    ///   - slider: 滑块
    ///   - completion: 播放完成后的回调
    /// - Note: 重写
    open func seekToSliderValue(_ slider: ARTVideoPlayerSlider, completion: (() -> Void)? = nil) {
        guard let duration = player.currentItem?.duration else { return }
        let time = CMTimeMake(value: Int64(slider.value * Float(duration.value)), timescale: duration.timescale)
        player.seek(to: time, toleranceBefore: .zero, toleranceAfter: .zero) { completed in
            guard completed else { return }
            completion?()
        }
    }
}

// MARK: - Setup Initializer

extension ARTVideoPlayerWrapperView {
    
    /// 开始准备播放器（最底层）
    ///
    /// - Parameter url: 视频文件或资源的 URL
    /// - Note: 验证 URL 后，配置音频会话并初始化播放器
    /// - Note: 重写父类方法，设置子视图
    @objc open func setupPreparePlayer(with url: URL) {
        guard validateURL(url) else { return }
        
        // 配置音频会话
        configureAudioSession()
        
        playerItem = AVPlayerItem(asset: AVAsset(url: url))
        player = AVPlayer(playerItem: playerItem)
        guard let playerLayer = layer as? AVPlayerLayer else {
            print("当前 layer 不是 AVPlayerLayer，无法播放视频。")
            return
        }
        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspect
    }
    
    /// 创建播放器图层（中间层）
    ///
    /// - Note: 重写父类方法，设置子视图
    @objc open func setupOverlayView() {
        playerOverlayView = ARTVideoPlayerOverlayView(self)
        addSubview(playerOverlayView)
        playerOverlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    /// 创建播放器控制层（最顶层）
    ///
    /// - Note: 重写父类方法，设置子视图
    @objc open func setupControlsView() {
        playControlsView = ARTVideoPlayerControlsView(self)
        addSubview(playControlsView)
        playControlsView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    /// 创建全屏管理器
    ///
    /// - Note: 重写父类方法，设置全屏管理器
    @objc open func setupFullscreenManager() {
        fullscreenManager = ARTVideoFullscreenManager(videoWrapperView: self)
    }
}

// MARK: - Private Methods

extension ARTVideoPlayerWrapperView {
    
    /// 验证 URL 的有效性
    ///
    /// - Parameter url: 需要验证的 URL
    /// - Returns: 如果有效返回 true，否则返回 false
    private func validateURL(_ url: URL) -> Bool {
        if url.absoluteString.isEmpty { // 检查 URL 是否为空
            print("无效的 URL。")
            return false
        }
        
        if url.isFileURL { // 检查本地文件是否存在
            if !FileManager.default.fileExists(atPath: url.path) {
                print("本地视频文件不存在：\(url.path)")
                return false
            }
        } else if url.scheme == "file",
                  Bundle.main.path(forResource: url.lastPathComponent, ofType: nil) == nil { // 检查应用内资源是否存在
            print("应用内视频资源不存在：\(url.lastPathComponent)")
            return false
        }
        
        return true
    }
    
    /// 配置音频会话
    ///
    /// - Note: 设置音频会话为播放模式并激活
    private func configureAudioSession() {
        do { // 获取共享音频会话实例并配置
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default)
            try session.setActive(true)
        } catch {
            print("设置音频会话时发生错误: \(error.localizedDescription)")
        }
    }
}

// MARK: - ARTVideoPlayerOverlayViewDelegate

extension ARTVideoPlayerWrapperView: ARTVideoPlayerOverlayViewDelegate {
    
}


// MARK: - ARTVideoPlayerControlsViewDelegate

extension ARTVideoPlayerWrapperView: ARTVideoPlayerControlsViewDelegate {
    
    /*
     public func customScreenOrientation(for playerControlsView: ARTVideoPlayerControlsView) -> ScreenOrientation { // 自定义播放模式
     
     }
     
     public func customTopBar(for playerControlsView: ARTVideoPlayerControlsView, screenOrientation: ScreenOrientation) -> ARTVideoPlayerTopbar? { // 自定义顶部工具栏视图
     
     }
     
     public func customBottomBar(for playerControlsView: ARTVideoPlayerControlsView, screenOrientation: ScreenOrientation) -> ARTVideoPlayerBottombar? { // 自定义底部工具栏视图
     
     }
     */
    
    public func videoPlayerControlsDidTapBack(for playerControlsView: ARTVideoPlayerControlsView) { // 点击返回按钮
        fullscreenManager.dismiss { [weak self] in // 切换窗口模式顶底栏
            self?.playControlsView.transitionToFullscreen(orientation: .window)
        }
    }
    
    public func videoPlayerControlsDidTapFavorite(for playerControlsView: ARTVideoPlayerControlsView, isFavorited: Bool) { // 点击收藏按钮
        
    }
    
    public func videoPlayerControlsDidTapShare(for playerControlsView: ARTVideoPlayerControlsView) { // 点击分享按钮
        
    }
    
    public func transitionToFullscreen(for playerControlsView: ARTVideoPlayerControlsView, orientation: ScreenOrientation) { // 点击全屏按钮
        fullscreenManager.presentFullscreenWithRotation { [weak self] in // 切换全屏模式顶底栏
            self?.playControlsView.transitionToFullscreen(orientation: orientation)
        }
    }
    
    public func controlsViewDidBeginTouch(for controlsView: ARTVideoPlayerControlsView, slider: ARTVideoPlayerSlider) { // 暂停播放 (开始拖动滑块)
        isDraggingSlider = true
        player.pause()
    }
    
    public func controlsViewDidChangeValue(for controlsView: ARTVideoPlayerControlsView, slider: ARTVideoPlayerSlider) { // 快进/快退 (拖动滑块)
        seekToSliderValue(slider)
    }
    
    public func controlsViewDidEndTouch(for controlsView: ARTVideoPlayerControlsView, slider: ARTVideoPlayerSlider) { // 恢复播放 (结束拖动滑块)
        isDraggingSlider = false
        player.play()
    }
    
    public func controlsViewDidTap(for controlsView: ARTVideoPlayerControlsView, slider: ARTVideoPlayerSlider) { // 指定播放时间 (点击滑块)
        controlsViewDidBeginTouch(for: controlsView, slider: slider)
        seekToSliderValue(slider) { [weak self] in // 指定播放时间
            self?.controlsViewDidEndTouch(for: controlsView, slider: slider)
        }
    }
}

// MARK: - AVPlayerLayer layerClass

extension ARTVideoPlayerWrapperView {
    open override class var layerClass: AnyClass { // 重写 layerClass 方法
        return AVPlayerLayer.self
    }
}
