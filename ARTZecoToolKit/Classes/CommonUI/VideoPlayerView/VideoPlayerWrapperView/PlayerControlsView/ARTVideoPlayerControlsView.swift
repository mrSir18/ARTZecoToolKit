//
//  ARTVideoPlayerControlsView.swift
//  Pods
//
//  Created by mrSir18 on 2024/10/19.
//

import AVFoundation

open class ARTVideoPlayerControlsView: ARTPassThroughView {
    
    // MARK: - Private Properties
    
    /// 代理对象
    public weak var delegate: ARTVideoPlayerControlsViewDelegate?
    
    /// 是否横向全屏
    public var isLandscape: Bool = true {
        didSet {
            if !isLandscape {
                stopAutoHideTimer()
            }
        }
    }
    
    /// 播放器当前的屏幕方向
    public lazy var screenOrientation: ScreenOrientation = {
        return delegate_customScreenOrientation()
    }()
    
    /// 隐藏控件定时器
    public var hideControlsTimer: Timer?
    
    /// 是否隐藏顶底工具栏
    public var isHiddenControls: Bool = false
    
    
    // MARK: - 播放器组件
    
    /// 导航栏视图
    public var topBar: ARTVideoPlayerTopbar!
    
    /// 底部工具栏视图
    public var bottomBar: ARTVideoPlayerBottombar!
    
    /// 播放、重试图片
    public var playImageView: UIImageView!
    
    
    // MARK: - Initialization
    
    public init(_ delegate: ARTVideoPlayerControlsViewDelegate? = nil) {
        super.init(frame: .zero)
        self.delegate = delegate
        self.clipsToBounds = true
        setupViews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Super Methods
    
    /// 子类方法，设置子视图
    open func setupViews() {
        setupToolBars()
    }
    
    // MARK: - Public Methods
    
    /// 旋转屏幕并刷新工具栏
    /// - Parameter orientation: 新的屏幕方向
    open func transitionToFullscreen(orientation: ScreenOrientation, playerState: PlayerState) {
        self.screenOrientation = orientation
        setupToolBars()
        updatePlayerStateInControls(playerState: playerState)
    }

    /// 更新当前播放时间和总时长
    /// - Parameters:
    ///   - currentTime: 当前播放时间
    ///   - duration: 视频总时长
    ///   - shouldUpdateSlider: 是否拖动滑块
    open func updateTimeInControls(with currentTime: CMTime, duration: CMTime, shouldUpdateSlider: Bool = false) {
        bottomBar.updatePlaybackTime(currentTime: currentTime, duration: duration, shouldUpdateSlider: shouldUpdateSlider)
    }

    /// 更新缓冲时间和进度
    /// - Parameters:
    ///   - totalBuffer: 缓冲总时间
    ///   - bufferProgress: 缓冲进度
    ///   - shouldUpdateSlider: 是否拖动滑块
    open func updateBufferProgressInControls(totalBuffer: Double, bufferProgress: Float, shouldUpdateSlider: Bool = false) {
        bottomBar.updateBufferProgress(totalBuffer: totalBuffer, bufferProgress: bufferProgress, shouldUpdateSlider: shouldUpdateSlider)
    }

    /// 触摸开始时调用
    /// - Parameter sliderValue: 当前滑块值
    @objc open func updateSliderTouchBeganInControls(sliderValue: Float) {
        bottomBar.updateSliderTouchBegan(value: sliderValue)
    }

    /// 更新滑块值
    /// - Parameter sliderValue: 新滑块值
    open func updateSliderValueInControls(sliderValue: Float) {
        bottomBar.updateSliderValue(value: sliderValue)
    }

    /// 触摸结束时调用
    /// - Parameter sliderValue: 当前滑块值
    @objc open func updateSliderTouchEndedInControls(sliderValue: Float) {
        bottomBar.updateSliderTouchEnded(value: sliderValue)
    }

    /// 更新播放按钮状态
    /// - Parameter playerState: 播放状态
    open func updatePlayerStateInControls(playerState: PlayerState) {
        playImageView.isHidden = (playerState == .playing)
    }

    /// 初始化滑块值
    /// - Parameter value: 初始值，默认 0.0
    open func resetSliderValueInControls(value: Float = 0.0) {
        bottomBar.resetSliderValue(value: value)
    }

    /// 更新播放/暂停按钮状态
    /// - Parameter isPlaying: 是否正在播放
    open func updatePlayPauseButtonInControls(isPlaying: Bool) {
        bottomBar.updatePlayPauseButton(isPlaying: isPlaying)
    }
    
    /// 更新倍数按钮状态
    /// - Parameter rate: 当前倍数
    open func updateRateButtonInControls(rate: Float) {
        guard let bottomBar = bottomBar as? ARTVideoPlayerLandscapeFullscreenBottombar else { return }
        bottomBar.updateRateButtonTitle(rate: rate)
    }
}

// MARK: - Setup Initializer

extension ARTVideoPlayerControlsView {
    
    /// 创建顶部和底部工具栏
    @objc open func setupToolBars() {
        setupTopBar()
        setupBottomBar()
        setupPlayButton()
        startAutoHideTimer()
    }
    
    /// 创建顶部工具栏
    @objc open func setupTopBar() {
        let topBarHeight = topBarHeight(for: screenOrientation)
        topBar = delegate_customTopBar() ?? defaultTopBarForOrientation()
        addSubview(topBar)
        topBar.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(topBarHeight)
        }
    }
    
    /// 创建底部工具栏
    @objc open func setupBottomBar() {
        let bottomBarHeight = bottomBarHeight(for: screenOrientation)
        bottomBar = delegate_customBottomBar() ?? defaultBottomBarForOrientation()
        addSubview(bottomBar)
        bottomBar.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(bottomBarHeight)
        }
    }
    
    /// 创建播放和重试按钮
    @objc open func setupPlayButton() {
        playImageView = UIImageView()
        playImageView.isHidden = true
        playImageView.alpha = 0.5
        playImageView.image = UIImage(named: "video_play")
        addSubview(playImageView)
        playImageView.snp.makeConstraints { make in
            make.size.equalTo(ARTAdaptedSize(width: 40.0, height: 40.0))
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    /// 切换控制条的显示与隐藏状态
    @objc open func toggleControlsVisibility() {
        toggleControls(visible: isHiddenControls)
        resetAutoHideTimer()
    }
}

// MARK: - Private Methods

extension ARTVideoPlayerControlsView {
    
    /// 根据屏幕方向返认顶部栏
    internal func defaultTopBarForOrientation() -> ARTVideoPlayerTopbar {
        switch screenOrientation {
        case .portraitFullScreen:
            return ARTVideoPlayerPortraitFullscreenTopbar(self)
        case .landscapeFullScreen:
            return ARTVideoPlayerLandscapeFullscreenTopbar(self)
        case .window:
            return ARTVideoPlayerWindowTopbar(self)
        }
    }
    
    /// 根据屏幕方向返回底部栏
    internal func defaultBottomBarForOrientation() -> ARTVideoPlayerBottombar {
        switch screenOrientation {
        case .portraitFullScreen:
            return ARTVideoPlayerPortraitFullscreenBottombar(self)
        case .landscapeFullScreen:
            return ARTVideoPlayerLandscapeFullscreenBottombar(self)
        case .window:
            return ARTVideoPlayerWindowBottombar(self)
        }
    }
    
    /// 移除顶部和底部工具栏
    internal func removeToolBars() {
        topBar.removeFromSuperview()
        bottomBar.removeFromSuperview()
        playImageView.removeFromSuperview()
    }
    
    /// 切换到窗口模式，设置屏幕方向并刷新顶部和底部栏
    internal func topBarHeight(for orientation: ScreenOrientation) -> CGFloat {
        switch orientation {
        case .portraitFullScreen:
            return art_navigationFullHeight() // 竖屏高度
        case .landscapeFullScreen:
            return ARTAdaptedValue(60.0) // 横屏高度
        case .window:
            return art_navigationBarHeight() // 普通窗口模式的高度
        }
    }
    
    /// 切换到窗口模式，设置屏幕方向并刷新顶部和底部栏
    internal func bottomBarHeight(for orientation: ScreenOrientation) -> CGFloat {
        switch orientation {
        case .portraitFullScreen:
            return ARTAdaptedValue(240.0)+art_safeAreaBottom() // 竖屏高度
        case .landscapeFullScreen:
            return ARTAdaptedValue(90.0) // 横屏高度
        case .window:
            return ARTAdaptedValue(44.0) // 普通窗口模式的高度
        }
    }
    
    /// 自动获取视频屏幕方向
    internal func autoVideoScreenOrientation() -> ScreenOrientation {
        return isLandscape ? .landscapeFullScreen : .portraitFullScreen
    }
    
    /// 开启隐藏控件定时器
    internal func startAutoHideTimer() {
        guard hideControlsTimer == nil, isLandscape else { return }
        hideControlsTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(autoHideControls), userInfo: nil, repeats: false)
    }
    
    /// 自动隐藏控件
    @objc internal func autoHideControls() {
        toggleControls(visible: false)
    }
    
    /// 显隐控件
    ///
    /// - Parameters:
    ///  - visibility: 显示状态
    ///  - animated
    internal func toggleControls(visible: Bool) {
        isHiddenControls = !visible
        if screenOrientation == .window { // 窗口模式下调整透明度
            let targetAlpha: CGFloat = visible ? 1 : 0
            UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut], animations: {
                self.topBar.containerView.alpha = targetAlpha
                self.bottomBar.alpha = targetAlpha
            })
        } else { // 横屏全屏模式下调整约束
            updateBarConstraints(visible: visible)
            UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut], animations: {
                self.layoutIfNeeded()
            })
        }
    }
    
    /// 更新工具栏约束
    internal func updateBarConstraints(visible: Bool) {
        guard let topBarSuperview = topBar.superview, let bottomBarSuperview = bottomBar.superview else {
            return // 如果没有父视图，直接返回，避免崩溃
        }
        
        let topBarHeight = topBarHeight(for: screenOrientation)
        let bottomBarHeight = bottomBarHeight(for: screenOrientation)
        
        topBar.snp.remakeConstraints { make in
            make.left.right.equalTo(topBarSuperview)
            make.height.equalTo(topBarHeight)
            make.top.equalTo(visible ? 0 : -topBarHeight) // 显示时顶部对齐，隐藏时推到上方
        }
        
        bottomBar.snp.remakeConstraints { make in
            make.left.right.equalTo(bottomBarSuperview)
            make.height.equalTo(bottomBarHeight)
            make.bottom.equalTo(visible ? 0 : bottomBarHeight) // 显示时底部对齐，隐藏时推到下方
        }
    }
    
    /// 重置自动隐藏定时器
    internal func resetAutoHideTimer() {
        stopAutoHideTimer()
        startAutoHideTimer()
    }
    
    /// 停止并销毁定时器的方法
    internal func stopAutoHideTimer() {
        hideControlsTimer?.invalidate()
        hideControlsTimer = nil
    }
    
    /// 处理播放器状态
    internal func handleLandscapeControls(isPlaying: Bool) {
        if isPlaying {
            stopAutoHideTimer()
            toggleControls(visible: true)
        } else {
            resetAutoHideTimer()
        }
    }
    
    /// 本地存储弹幕状态
    internal func saveDanmakuEnabled(isDanmakuEnabled: Bool) {
        UserDefaults.standard.set(isDanmakuEnabled, forKey: "DanmakuEnabledKey")
    }
}

// MARK: - Private Delegate Methods

extension ARTVideoPlayerControlsView {
    
    /// 获取自定义播放模式
    /// - Returns: 自定义播放模式，如果代理未实现则返回默认模式
    private func delegate_customScreenOrientation() -> ScreenOrientation {
        return delegate?.customScreenOrientation?(for: self) ?? .window
    }
    
    /// 获取自定义顶部工具栏
    /// - Returns: 自定义顶部工具栏，如果代理未实现则返回 nil
    private func delegate_customTopBar() -> ARTVideoPlayerTopbar? {
        return delegate?.customTopBar?(for: self, screenOrientation: screenOrientation)
    }
    
    /// 获取自定义底部工具栏
    /// - Returns: 自定义底部工具栏，如果代理未实现则返回 nil
    private func delegate_customBottomBar() -> ARTVideoPlayerBottombar? {
        return delegate?.customBottomBar?(for: self, screenOrientation: screenOrientation)
    }
}
