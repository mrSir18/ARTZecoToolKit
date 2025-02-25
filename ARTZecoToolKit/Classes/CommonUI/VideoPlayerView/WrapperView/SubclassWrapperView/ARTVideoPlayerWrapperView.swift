//
//  ARTVideoPlayerWrapperView.swift
//  Pods
//
//  Created by mrSir18 on 2024/10/15.
//

import AVFoundation
import MediaPlayer

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
    
    /// 全屏管理器
    public var fullscreenManager: ARTVideoFullscreenManager!
    
    /// 手势方向
    public var swipeDirection: SwipeDirection = .unknown
    
    /// 倍速
    public var currentRate: Float = 1.0
    
    /// 音量滑块
    public lazy var volumeSlider: UISlider? = {
        MPVolumeView().subviews.compactMap { $0 as? UISlider }.first
    }()
    
    /// 触觉反馈发生器
    public var feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    
    // MARK: - Private Properties
    
    /// 记录上次点击的时间
    private var lastTapTime: TimeInterval = 0
    
    /// 双击最大时间间隔
    private let doubleTapDelay: TimeInterval = 0.3
    
    
    // MARK: - Initialization
    
    public override init() {
        super.init()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    open override func setupViews() {
        super.setupViews()
        setupFeedbackGenerator()
        setupFullscreenManager()
        setupOverlayView()
        setupSystemControls()
        setupLoadingView()
        setupControlsView()
        setupGestureRecognizers()
    }
    
    // MARK: - Override Setup Methods
    
    open override func onReceivePlayerItemDidPlayToEnd(_ notification: Notification) { // 播放结束
        super.onReceivePlayerItemDidPlayToEnd(notification)
        pausePlayer() // 暂停播放
    }
    
    open override func onReceivePlayerReadyToPlay() { // 准备播放
        super.onReceivePlayerReadyToPlay()
        didStopLoadingAnimation() // 停止加载动画
        resumePlayer() // 开始播放
    }
}

// MARK: - Setup Initializer

extension ARTVideoPlayerWrapperView {
    
    /// 创建播放器图层（最底层：用于显示弹幕、广告等）
    @objc open func setupOverlayView() {
        
    }
    
    /// 创建系统控制层（中间层：系统控制）
    @objc open func setupSystemControls() {
        
    }
    
    /// 创建加载动画视图
    @objc open func setupLoadingView() {
        
    }
    
    /// 创建播放器控制层（最顶层：顶部栏、侧边栏等）
    @objc open func setupControlsView() {
        
    }
    
    /// 创建全屏管理器
    @objc open func setupFullscreenManager() {
        fullscreenManager = ARTVideoFullscreenManager(wrapperView: self)
    }
    
    /// 创建触觉反馈发生器
    @objc open func setupFeedbackGenerator() {
        feedbackGenerator.prepare() // 准备好触觉反馈
    }
    
    /// 设置手势识别器
    @objc open func setupGestureRecognizers() {
        // 拖动手势
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.maximumNumberOfTouches = 1
        panGesture.delaysTouchesBegan = true
        panGesture.delaysTouchesEnded = true
        panGesture.cancelsTouchesInView = true
        addGestureRecognizer(panGesture)
        
        // 单击手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        tapGesture.delegate = self
        addGestureRecognizer(tapGesture)
        
        // 捏合手势
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        addGestureRecognizer(pinchGesture)
        
        // 长按手势
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPressGesture.minimumPressDuration = 0.5 // 设置长按时间
        addGestureRecognizer(longPressGesture)
    }
}

// MARK: - Gesture Recognizer

extension ARTVideoPlayerWrapperView: UIGestureRecognizerDelegate {
    
    /// 处理拖动手势
    /// - Parameter gesture: 拖动手势
    /// - Note: 重写父类方法，处理拖动手势，横向滑动更新播放进度，纵向滑动调整亮度或音量
    @objc open func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let locationPoint = gesture.location(in: self) // 获取当前触摸位置
        let velocityPoint = gesture.velocity(in: self) // 获取滑动速度信息
        let sliderValue   = Float(velocityPoint.x) / 60000 // 滑块值
        
        switch gesture.state {
        case .began:
            if abs(velocityPoint.x) > abs(velocityPoint.y) { // 横向滑动
                swipeDirection = .horizontal
                didReceiveSliderTouchBegan(sliderValue: sliderValue)
            } else { // 纵向滑动，判断是左半边还是右半边
                swipeDirection = locationPoint.x < bounds.width * 0.5 ? .verticalLeft : .verticalRight
            }
        case .changed:
            switch swipeDirection {
            case .horizontal: // 横向滑动时更新播放进度
                didReceiveSliderValue(sliderValue: sliderValue)
            case .verticalLeft: // 左侧滑动时调整亮度
                UIScreen.main.brightness -= velocityPoint.y / 10000
            case .verticalRight: // 右侧滑动时调整音量
                volumeSlider?.value -= Float(velocityPoint.y / 10000)
            default:
                break
            }
        case .ended: // 如果是横向滑动，恢复播放器
            if swipeDirection == .horizontal { didReceiveSliderTouchEnded(sliderValue: sliderValue) }
        default:
            break
        }
    }
    
    /// 处理单击 - 双击手势
    /// - Parameter gesture: 点击手势
    /// - Note: 重写父类方法，处理单击手势，根据横竖屏模式展示控制面板或切换播放状态
    @objc open func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        let currentTime = Date().timeIntervalSince1970
        if currentTime - lastTapTime < doubleTapDelay { // 双击事件
            guard isLandscape else { return }
            didReceivewDoubleTapGesture() // 通知外部双击事件
            
        } else { // 单击事件
            let location = gesture.location(in: self)
            didReceiveTapGesture(at: location) // 通知外部点击事件
        }
        lastTapTime = currentTime // 更新上次点击的时间
    }
    
    @objc open func handleDoubleTapGesture(_ gesture: UITapGestureRecognizer) {
        guard isLandscape else { return } // 如果是横屏模式
        didReceivewDoubleTapGesture() // 通知外部双击事件
    }
    
    /// 处理捏合手势
    /// - Parameter gesture: 捏合手势
    /// - Note: 重写父类方法，处理捏合手势来调整视频画面填充模式
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
    
    /// 处理长按手势
    /// - Parameter gesture: 长按手势
    /// - Note: 重写父类方法，处理长按手势，调整播放速率
    @objc open func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard player.timeControlStatus == .playing else { return }
        switch gesture.state {
        case .began: // 设置播放速率为3.0，表示三倍速播放
            guard let currentPlayer = player else { return }
            currentPlayer.rate = 3.0
        case .ended, .cancelled, .failed: // 恢复播放速率为正常值
            guard let currentPlayer = player else { return }
            currentPlayer.rate = currentRate
        default:
            break
        }
    }
    
    // MARK: - UIGestureRecognizerDelegate Methods
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false // 允许双击和单击手势同时识别
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UITapGestureRecognizer && otherGestureRecognizer is UITapGestureRecognizer { // 单击手势必须等待双击手势失败
            return (gestureRecognizer as! UITapGestureRecognizer).numberOfTapsRequired == 1 &&
            (otherGestureRecognizer as! UITapGestureRecognizer).numberOfTapsRequired == 2
        }
        return false
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UITapGestureRecognizer && otherGestureRecognizer is UITapGestureRecognizer { // 双击手势必须等待单击
            return (gestureRecognizer as! UITapGestureRecognizer).numberOfTapsRequired == 2 &&
            (otherGestureRecognizer as! UITapGestureRecognizer).numberOfTapsRequired == 1
        }
        return false
    }
}

// MARK: - Public Methods

extension ARTVideoPlayerWrapperView {
    
    /// 开始播放视频
    /// - Parameter url: 视频文件或资源的 URL
    @objc open func startVideoPlayback(with url: URL?) {
        guard let url = url else { return }
        setupPreparePlayer(with: url)
    }
    
    /// 播放下一集视频
    /// - Parameter url: 视频文件或资源的 URL
    @objc open func playNextVideo(with url: URL?) {
        guard let url = url else { return }
        prepareForNextVideo() // 准备播放下一集
        loadAssetAsync(url: url, keys: ["tracks"]) { [weak self] result in
            switch result {
            case .success(let asset):
                self?.finalizeNextVideoPlayback(with: asset) // 完成下一集视频的播放设置
            case .failure(let error):
                print("Tracks 属性加载失败: \(error.localizedDescription)")
                self?.didStopLoadingAnimation() // 移除加载动画
            }
        }
    }
    
    /// 暂停播放视频
    @objc open func pausePlayer() {
        player.pause()
    }
    
    /// 恢复播放视频
    @objc open func resumePlayer() {
        player.play()
        player.rate = currentRate
    }
    
    /// 重新播放视频
    @objc open func replayPlayer() {
        seek(to: .zero) { [weak self] _ in
            self?.resumePlayer()
        }
    }
    
    /// 更新播放倍速
    /// - Parameter rate: 播放倍速
    @objc open func updatePlaybackRate(rate: Float) {
        currentRate = rate
        resumePlayer() // 恢复播放
    }
    
    /// 指定时间播放视频
    /// - Parameters:
    ///  - time: 指定的时间
    ///  - completion: 播放完成后的回调
    @objc open func seekToTime(from time: Float, completion: (() -> Void)? = nil) {
        guard let duration = player.currentItem?.duration else { return }
        let currentTime = CMTimeMake(value: Int64(time * Float(duration.value)), timescale: duration.timescale)
        didUpdateCurrentTime(currentTime: currentTime) // 通知外部更新当前进度
        seek(to: currentTime) { [weak self] completed in
            guard let self = self else { return }
            completion?()
            self.player.rate = self.currentRate
        }
    }
    
    /// 跳转到指定时间
    @objc open func seek(to time: CMTime, completion: @escaping (Bool) -> Void) {
        player.seek(to: time, toleranceBefore: .zero, toleranceAfter: .zero, completionHandler: completion)
    }
    
    /// 更新进度预览图像
    /// - Parameter time: 预览时间
    @objc open func updatePreviewImage(at time: Float) {
        let duration = player.currentItem?.duration ?? totalDuration
        let currentTime = CMTime(seconds: Double(time) * duration.seconds, preferredTimescale: 600)
        didUpdatePreviewTime(currentTime: currentTime, totalTime: duration) // 更新时间
        fetchThumbnail(for: currentTime) // 获取缩略图
    }
}

// MARK: - 发送消息给外部

extension ARTVideoPlayerWrapperView {
    
    /// 通知外部准备播放下一集
    @objc open func didPrepareForNextVideo() {
        
    }
    
    /// 通知外部已完成下一集的播放设置
    @objc open func didCompleteSetupForNextVideo() {
        
    }
    
    /// 通知外部更新预览图像
    /// - Parameter previewImage: 生成的缩略图像
    @objc open func didUpdatePreviewImage(previewImage: UIImage) {
        
    }
    
    /// 通知外部更新当前预览视频的时间与视频总时长
    /// - Parameters:
    ///  - currentTime: 当前视频时间
    ///  - totalTime: 视频总时长
    @objc open func didUpdatePreviewTime(currentTime: CMTime, totalTime: CMTime) {
        
    }
    
    /// 通知外部更新当前播放进度
    /// - Parameter currentTime: 当前播放进度的时间
    @objc open func didUpdateCurrentTime(currentTime: CMTime) {

    }
    
    /// 通知外部加载动画已开始
    @objc open func didStartLoadingAnimation() {
        
    }
    
    /// 通知外部加载动画已停止
    @objc open func didStopLoadingAnimation() {
        
    }
    
    // MARK: - Gesture Recognizer
    
    /// 触摸开始时调用
    /// - Parameter sliderValue: 滑块的初始值
    /// - Note: 该方法在触摸开始时被调用，通常用于初始化滑块的位置或其他操作
    @objc open func didReceiveSliderTouchBegan(sliderValue: Float) {
        
    }
    
    /// 滑动过程中调用
    /// - Parameter sliderValue: 当前滑块的值
    /// - Note: 该方法在滑动过程中持续调用，通常用于动态更新控件的滑块值
    @objc open func didReceiveSliderValue(sliderValue: Float) {
        
    }
    
    /// 触摸结束时调用
    /// - Parameter sliderValue: 最终滑块值
    /// - Note: 该方法在触摸结束时被调用，通常用于最终确认滑块位置并执行相关操作
    @objc open func didReceiveSliderTouchEnded(sliderValue: Float) {
        
    }
    
    /// 点击手势
    /// - Parameter location: 点击的位置
    /// - Note: 该方法在接收到点击手势时被调用，通常用于显示或隐藏控制面板
    @objc open func didReceiveTapGesture(at location: CGPoint) {
        
    }
    
    /// 双击手势
    /// - Note: 该方法在接收到双击手势时被调用，通常用于切换播放状态
    @objc open func didReceivewDoubleTapGesture() {
        
    }
}

// MARK: - Private Methods

extension ARTVideoPlayerWrapperView {
    
    /// 开始准备播放器（最底层）
    /// - Parameter url: 视频文件或资源的 URL
    private func setupPreparePlayer(with url: URL) {
        guard validateURL(url) else { return }
        configureAudioSession() // 配置音频会话
        initializePlayer(with: url) // 初始化播放器
        didStartLoadingAnimation() // 显示加载动画
    }
    
    /// 初始化播放器
    /// - Parameter url: 视频 URL
    private func initializePlayer(with url: URL) {
        let asset = AVURLAsset(url: url)
        playerItem = AVPlayerItem(asset: asset)
        setPlayerVolume(playerItem: playerItem, volume: 2.0)  // 将音量设置为2倍
        player = AVPlayer(playerItem: playerItem)
        
        configurePlayerLayer() // 配置播放器 Layer
        setupImageGenerator(asset) // 配置图像生成器
    }
    
    /// 为播放下一集准备工作
    private func prepareForNextVideo() {
        thumbnailCache.removeAll()
        pausePlayer() // 暂停播放
        playerState = .playing // 更新播放器状态
        didPrepareForNextVideo() // 通知外部准备播放下一集
        onReceiveRemovePeriodicTimeObserver() // 移除周期性时间观察者
        if let playerLayer = self.layer as? AVPlayerLayer {
            playerLayer.player = nil
            playerLayer.backgroundColor = UIColor.black.cgColor
        }
        didStartLoadingAnimation() // 显示加载动画
    }
    
    /// 完成下一集视频的播放设置
    /// - Parameter asset: 加载完成的 AVAsset
    private func finalizeNextVideoPlayback(with asset: AVURLAsset) {
        didCompleteSetupForNextVideo() // 通知外部已完成下一集的播放设置
        playerItem = AVPlayerItem(asset: asset)
        player.replaceCurrentItem(with: playerItem)
        setPlayerVolume(playerItem: playerItem, volume: 2.0)
        setupImageGenerator(asset)
        configurePlayerLayer()
    }
    
    /// 配置播放器 Layer
    /// - Parameter player: AVPlayer 实例
    private func configurePlayerLayer() {
        guard let playerLayer = self.layer as? AVPlayerLayer else {
            print("当前 layer 不是 AVPlayerLayer，无法播放视频。")
            return
        }
        playerLayer.backgroundColor = UIColor.black.cgColor
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.player = self.player
        self.addPlayerObservers() // 添加播放器观察者
    }
    
    /// 设置播放器音量
    /// - Parameters:
    ///   - playerItem: 当前播放的 `AVPlayerItem`，其中包含了音频轨道信息。
    ///   - volume: 要设置的音量大小，范围通常为 `0.0` 到 `1.0`，但可以超过 `1.0` 来增加音量（如 `2.0` 为两倍音量）。
    private func setPlayerVolume(playerItem: AVPlayerItem, volume: Float) {
        let audioMix = AVMutableAudioMix()
        if let audioTrack = playerItem.asset.tracks(withMediaType: .audio).first {
            let inputParams = AVMutableAudioMixInputParameters(track: audioTrack)
            inputParams.setVolume(volume, at: CMTime.zero) // 调整音量
            audioMix.inputParameters = [inputParams]
            playerItem.audioMix = audioMix
        }
    }
    
    /// 配置图像生成器
    /// - Parameter asset: 视频资源
    /// - Note: 配置图像生成器并获取视频的第一帧
    private func setupImageGenerator(_ asset: AVURLAsset) {
        thumbnailCache.removeAll() // 清空缓存
        imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        imageGenerator.requestedTimeToleranceBefore   = CMTimeMake(value: 1, timescale: 10) // 0.1秒
        imageGenerator.requestedTimeToleranceAfter    = CMTimeMake(value: 1, timescale: 10)
        
        fetchFirstFrameFromVideo() // 获取视频的第一帧
    }
    
    /// 获取视频的第一帧图像
    /// - Note: 调用此方法将尝试从视频的开头获取第一帧图像
    private func fetchFirstFrameFromVideo() {
        let firstFrameTime = CMTime(seconds: 0, preferredTimescale: 600)
        fetchThumbnail(for: firstFrameTime)
    }
    
    /// 根据指定时间获取缩略图
    /// - Parameter time: 需要生成缩略图的时间
    /// - Note: 生成缩略图并更新预览图像 - 有条件的可以上云，这样缩略图更高效
    private func fetchThumbnail(for time: CMTime) {
        let timeKey = CMTimeHashable(time) // 创建时间键用于缓存
        if let cachedImage = thumbnailCache[timeKey] { // 如果有缓存，直接更新预览图像
            didUpdatePreviewImage(previewImage: cachedImage)
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
                self?.didUpdatePreviewImage(previewImage: uiImage)
            }
        }
    }
    
    /// 验证 URL 的有效性
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
    
    /// 添加播放器观察者
    /// - Note: 重写父类方法，添加播放器观察者
    private func loadAssetAsync(url: URL, keys: [String], completion: @escaping (Result<AVURLAsset, Error>) -> Void) {
        let asset = AVURLAsset(url: url)
        asset.loadValuesAsynchronously(forKeys: keys) {
            var error: NSError?
            let status = asset.statusOfValue(forKey: keys.first ?? "", error: &error)
            DispatchQueue.main.async { // 这里确保 completion 回调在主线程执行
                if status == .loaded {
                    completion(.success(asset))
                } else {
                    completion(.failure(error ?? NSError(domain: "ARTVideoPlayer", code: -1, userInfo: [NSLocalizedDescriptionKey: "Asset loading failed."])))
                }
            }
        }
    }
}

// MARK: - AVPlayerLayer layerClass

extension ARTVideoPlayerWrapperView {
    open override class var layerClass: AnyClass { // 重写 layerClass 方法
        return AVPlayerLayer.self
    }
}
