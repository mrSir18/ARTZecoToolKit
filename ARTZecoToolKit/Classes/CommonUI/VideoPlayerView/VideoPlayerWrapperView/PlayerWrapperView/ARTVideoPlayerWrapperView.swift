//
//  ARTVideoPlayerWrapperView.swift
//  Pods
//
//  Created by mrSir18 on 2024/10/15.
//

import AVFoundation
import MediaPlayer

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

extension ARTVideoPlayerWrapperView {
    // 定义枚举，用于区分手势方向
    public enum SwipeDirection {
        case horizontal     // 横向滑动
        case verticalLeft   // 纵向滑动 - 左半边屏幕
        case verticalRight  // 纵向滑动 - 右半边屏幕
        case unknown        // 未知手势方向
    }
}

open class ARTVideoPlayerWrapperView: ARTBaseVideoPlayerWrapperView {
    
    // MARK: - Private Properties
    
    /// 代理对象
    private weak var delegate: ARTVideoPlayerWrapperViewProtocol?
    
    /// 全屏管理器
    private var fullscreenManager: ARTVideoFullscreenManager!
    
    /// 播放器配置模型
    public var playerConfig: ARTVideoPlayerConfig!
    
    /// 手势方向
    public var swipeDirection: SwipeDirection = .unknown
    
    
    // MARK: - 播放器组件 AVPlayer（最底层：播放器视图）
    
    /// 播放器系统控制层（最底层：系统控制）
    public var systemControlsView: ARTVideoPlayerSystemControls!
    
    /// 播放器图层（中间层：用于显示弹幕、广告等）
    public var playerOverlayView: ARTVideoPlayerOverlayView!
    
    /// 播放器控制层（最顶层：顶底栏、侧边栏等）
    public var playControlsView: ARTVideoPlayerControlsView!
    
    /// 音量滑块
    public lazy var volumeSlider: UISlider? = {
        MPVolumeView().subviews.compactMap { $0 as? UISlider }.first
    }()
    
    /// 触觉反馈发生器
    public var feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    
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
        setupFeedbackGenerator()
        setupFullscreenManager()
        setupSystemControlsView()
        setupOverlayView()
        setupControlsView()
        setupGestureRecognizers()
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
        systemControlsView.updateContentModeInSystemControls(isLandscape: playerConfig.isLandscape)
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
        thumbnailCache.removeAll() // 清空缓存
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
    
    /// 获取视频的第一帧
    ///
    /// - Note: 调用此方法将尝试从视频的开头获取第一帧图像
    open func fetchFirstFrameFromVideo() {
        let firstFrameTime = CMTime(seconds: 0, preferredTimescale: 600)
        fetchThumbnail(for: firstFrameTime)
    }
    
    /// 根据滑动条的值更新预览图像
    ///
    /// - Parameter slider: 代表视频播放进度的滑动条
    /// - Note: 子类重写该方法更新预览
    open func updatePreviewImageForSliderValueChange(_ slider: ARTVideoPlayerSlider) {
        let currentTime = CMTime(seconds: Double(slider.value) * totalDuration, preferredTimescale: 600)
        let duration = player.currentItem?.duration ?? interval
        systemControlsView.updateTimeInSystemControls(with: currentTime, duration: duration)
        
        // 获取当前时间的缩略图
        fetchThumbnail(for: currentTime)
    }
    
    /// 根据指定时间获取缩略图
    ///
    /// - Parameter time: 需要生成缩略图的时间
    /// - Note: 生成缩略图并更新预览图像 - 有条件的可以上云，这样缩略图更高效
    open func fetchThumbnail(for time: CMTime) {
        let timeKey = CMTimeHashable(time) // 创建时间键用于缓存
        if let cachedImage = thumbnailCache[timeKey] { // 如果有缓存，直接更新预览图像
            systemControlsView.updatePreviewImageInSystemControls(previewImage: cachedImage)
            return
        }
        
        imageGenerator.cancelAllCGImageGeneration() // 取消所有正在进行的图像生成请求
        imageGenerator.generateCGImagesAsynchronously(forTimes: [NSValue(time: time)]) { [weak self] _, image, _, _, error in
            if let error = error {
                print("Error generating image: \(error.localizedDescription)")
                return
            }
            guard let image = image else { return }
            
            let uiImage = UIImage(cgImage: image)
            self?.thumbnailCache[timeKey] = uiImage // 缓存图像
            DispatchQueue.main.async {
                self?.systemControlsView.updatePreviewImageInSystemControls(previewImage: uiImage)
            }
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
    @objc open func setupPreparePlayer(with videoUrl: URL) {
        guard validateURL(videoUrl) else { return }
        
        // 配置音频会话
        configureAudioSession()
        
        let asset = AVURLAsset(url: videoUrl)
        playerItem = AVPlayerItem(asset: asset)
        setPlayerVolume(playerItem: playerItem, volume: 2.0)  // 将音量设置为2倍
        player = AVPlayer(playerItem: playerItem)
        guard let playerLayer = layer as? AVPlayerLayer else {
            print("当前 layer 不是 AVPlayerLayer，无法播放视频。")
            return
        }
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.player = player
        setupImageGenerator(asset)
    }
    
    /// 设置播放器音量
    ///
    /// 该方法通过修改 `AVPlayerItem` 的音轨音量来调节播放声音。
    ///
    /// - Parameters:
    ///   - playerItem: 当前播放的 `AVPlayerItem`，其中包含了音频轨道信息。
    ///   - volume: 要设置的音量大小，范围通常为 `0.0` 到 `1.0`，但可以超过 `1.0` 来增加音量（如 `2.0` 为两倍音量）。
    ///
    /// - Note:
    ///   音量值 `1.0` 表示原始音量，`0.0` 表示静音，超过 `1.0` 可以增大音量。
    @objc open func setPlayerVolume(playerItem: AVPlayerItem, volume: Float) {
        let audioMix = AVMutableAudioMix()
        if let audioTrack = playerItem.asset.tracks(withMediaType: .audio).first {
            let inputParams = AVMutableAudioMixInputParameters(track: audioTrack)
            inputParams.setVolume(volume, at: CMTime.zero) // 调整音量
            audioMix.inputParameters = [inputParams]
            playerItem.audioMix = audioMix
        }
    }
    
    /// 配置图像生成器
    ///
    /// - Parameter asset: 视频资源
    /// - Note: 配置图像生成器并获取视频的第一帧
    /// - Note: 重写父类方法，设置子视图
    @objc open func setupImageGenerator(_ asset: AVURLAsset) {
        thumbnailCache.removeAll() // 清空缓存
        imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        imageGenerator.requestedTimeToleranceBefore   = .zero
        imageGenerator.requestedTimeToleranceAfter    = .zero
        fetchFirstFrameFromVideo() // 获取视频的第一帧
    }
    
    /// 创建系统控制层（最底层）
    ///
    /// - Note: 重写父类方法，设置子视图
    @objc open func setupSystemControlsView() {
        systemControlsView = ARTVideoPlayerSystemControls(self)
        addSubview(systemControlsView)
        systemControlsView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
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
    
    /// 创建触觉反馈发生器
    ///
    /// - Note: 重写父类方法，设置触觉反馈发生器
    @objc open func setupFeedbackGenerator() {
        feedbackGenerator.prepare() // 准备好触觉反馈
    }
    
    /// 创建手势识别器
    ///
    /// - Note: 重写父类方法，设置手势识别器
    @objc open func setupGestureRecognizers() {
        // 拖动手势
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSortingPan(_:)))
        panGesture.maximumNumberOfTouches = 1
        panGesture.delaysTouchesBegan = true
        panGesture.delaysTouchesEnded = true
        panGesture.cancelsTouchesInView = true
        addGestureRecognizer(panGesture)
        
        // 点击手势
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleSortingTap(_:)))
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        addGestureRecognizer(tapRecognizer)
        
        // 捏合手势
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        addGestureRecognizer(pinchGesture)
    }
}

// MARK: - Gesture Recognizer

extension ARTVideoPlayerWrapperView {
    
    /// 拖动手势
    ///
    /// - Parameter gesture: 拖动手势
    /// - Note: 重写父类方法，处理拖动手势
    @objc func handleSortingPan(_ gesture: UIPanGestureRecognizer) {
        let locationPoint = gesture.location(in: self) // 获取当前触摸位置
        let velocityPoint = gesture.velocity(in: self) // 获取滑动速度信息
        let sliderValue   = Float(velocityPoint.x) / 60000 // 滑块值
        
        switch gesture.state {
        case .began:
            if abs(velocityPoint.x) > abs(velocityPoint.y) { // 横向滑动
                swipeDirection = .horizontal
                playControlsView.updateSliderTouchBeganInControls(sliderValue: sliderValue)
            } else { // 纵向滑动，判断是左半边还是右半边
                swipeDirection = locationPoint.x < bounds.width * 0.5 ? .verticalLeft : .verticalRight
            }
        case .changed:
            switch swipeDirection {
            case .horizontal: // 更新播放控件中的滑块值
                playControlsView.updateSliderValueInControls(sliderValue: sliderValue)
            case .verticalLeft: // 左侧滑动时降低屏幕亮度
                UIScreen.main.brightness -= velocityPoint.y / 10000
            case .verticalRight: // 右侧滑动时调整音量
                volumeSlider?.value -= Float(velocityPoint.y / 10000)
            default:
                break
            }
        case .ended: // 如果是横向滑动，恢复播放器
            if swipeDirection == .horizontal { playControlsView.updateSliderTouchEndedInControls(sliderValue: sliderValue) }
        default:
            break
        }
    }
    
    /// 点击手势
    ///
    /// - Parameter gesture: 点击手势
    /// - Note: 重写父类方法，处理点击手势
    @objc open func handleSortingTap(_ gesture: UITapGestureRecognizer) {
        print("TopView: Tap gesture")
    }
    
    /// 捏合手势
    ///
    /// - Parameter gesture: 捏合手势
    /// - Note: 重写父类方法，处理捏合手势
    @objc open func handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {
        guard let playerLayer = layer as? AVPlayerLayer else { return }

        switch gesture.state {
        case .changed:
            playerLayer.videoGravity = gesture.scale > 1 ? .resizeAspectFill : .resizeAspect
        case .ended, .cancelled:
            feedbackGenerator.impactOccurred() // 触发触觉反馈
            break
        default:
            break
        }
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
    
    /// 播放器暂停播放
    ///
    /// - Note: 暂停播放器并更新播放状态
    private func pausePlayer() {
        isDraggingSlider = true
        player.pause()
    }
    
    /// 播放器恢复播放
    ///
    /// - Note: 恢复播放器并更新播放状态
    private func resumePlayer() {
        systemControlsView.hideVideoPlayerDisplay()
        isDraggingSlider = false
        player.play()
    }
}

// MARK: - ARTVideoPlayerSystemControlsDelegate

extension ARTVideoPlayerWrapperView: ARTVideoPlayerSystemControlsDelegate {
    
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
            self?.systemControlsView.updateScreenOrientationInSystemControls(screenOrientation: .window)
            self?.playControlsView.transitionToFullscreen(orientation: .window)
        }
    }
    
    public func videoPlayerControlsDidTapFavorite(for playerControlsView: ARTVideoPlayerControlsView, isFavorited: Bool) { // 点击收藏按钮
 
    }
    
    public func videoPlayerControlsDidTapShare(for playerControlsView: ARTVideoPlayerControlsView) { // 点击分享按钮
 
    }
    
    public func transitionToFullscreen(for playerControlsView: ARTVideoPlayerControlsView, orientation: ScreenOrientation) { // 点击全屏按钮
        fullscreenManager.presentFullscreenWithRotation { [weak self] in // 切换全屏模式顶底栏
            self?.systemControlsView.updateScreenOrientationInSystemControls(screenOrientation: orientation)
            self?.playControlsView.transitionToFullscreen(orientation: orientation)
        }
    }
    
    public func controlsViewDidBeginTouch(for controlsView: ARTVideoPlayerControlsView, slider: ARTVideoPlayerSlider) { // 暂停播放 (开始拖动滑块)
        pausePlayer()
    }
    
    public func controlsViewDidChangeValue(for controlsView: ARTVideoPlayerControlsView, slider: ARTVideoPlayerSlider) { // 快进/快退 (拖动滑块)
        seekToSliderValue(slider)
        updatePreviewImageForSliderValueChange(slider)
    }
    
    public func controlsViewDidEndTouch(for controlsView: ARTVideoPlayerControlsView, slider: ARTVideoPlayerSlider) { // 恢复播放 (结束拖动滑块)
        resumePlayer()
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
