//
//  ARTVideoPlayerControlsView.swift
//  ARTZeco
//
//  Created by mrSir18 on 2024/10/19.
//

import AVFoundation
import ARTZecoToolKit

class ARTVideoPlayerControlsView: ARTPassThroughView {
    
    // MARK: - Private Properties
    
    /// 代理对象
    weak var delegate: ARTVideoPlayerControlsViewDelegate?
    
    /// 是否横向全屏
    public var isLandscape: Bool = true {
        didSet {
            if !isLandscape { stopAutoHideTimer() }
        }
    }
    
    /// 播放器当前的屏幕方向
    public var screenOrientation: ScreenOrientation = .window
    
    /// 自动隐藏控件的定时器
    public var autoHideControlsTimer: Timer?
    
    /// 是否隐藏顶底工具栏
    public var isHiddenControls: Bool = false
    
    
    // MARK: - 播放器组件
    
    /// 导航栏视图
    private var topBar: ARTVideoPlayerTopbar!
    
    /// 底部工具栏视图
    private var bottomBar: ARTVideoPlayerBottombar!
    
    /// 播放、重试图片
    private var playImageView: UIImageView!
    
    
    // MARK: - Initialization
    
    init(_ delegate: ARTVideoPlayerControlsViewDelegate? = nil) {
        super.init(frame: .zero)
        self.delegate = delegate
        self.clipsToBounds = true
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Super Methods
    
    func setupViews() {
        setupToolBars()
    }
    
    // MARK: - Public Methods
    
    /// 旋转屏幕并刷新工具栏
    /// - Parameter orientation: 新的屏幕方向
    public func didTransitionToFullscreenInControls(orientation: ScreenOrientation, playerState: PlayerState) {
        self.screenOrientation = orientation
        setupToolBars()
        didUpdatePlayPauseStateInControls(playerState: playerState)
    }
    
    /// 更新当前播放时间和总时长
    /// - Parameters:
    ///   - currentTime: 当前播放时间
    ///   - duration: 视频总时长
    ///   - shouldUpdateSlider: 是否拖动滑块
    public func didUpdatePlaybackTimeInControls(with currentTime: CMTime, duration: CMTime, shouldUpdateSlider: Bool = false) {
        bottomBar.updatePlaybackTime(currentTime: currentTime, duration: duration, shouldUpdateSlider: shouldUpdateSlider)
    }
    
    /// 更新缓冲时间和进度
    /// - Parameters:
    ///   - totalBuffer: 缓冲总时间
    ///   - bufferProgress: 缓冲进度
    ///   - shouldUpdateSlider: 是否拖动滑块
    public func didUpdateBufferingProgressInControls(totalBuffer: Double, bufferProgress: Float, shouldUpdateSlider: Bool = false) {
        bottomBar.updateBufferingProgress(totalBuffer: totalBuffer, bufferProgress: bufferProgress, shouldUpdateSlider: shouldUpdateSlider)
    }
    
    /// 触摸开始时调用
    /// - Parameter sliderValue: 当前滑块值
    public func didBeginSliderTouchInControls(sliderValue: Float) {
        bottomBar.updateSliderTouchBegan(value: sliderValue)
    }
    
    /// 更新滑块值
    /// - Parameter sliderValue: 新滑块值
    public func didUpdateSliderPositionInControls(sliderValue: Float) {
        bottomBar.updateSliderPosition(value: sliderValue)
    }
    
    /// 触摸结束时调用
    /// - Parameter sliderValue: 当前滑块值
    public func didEndSliderTouchInControls(sliderValue: Float) {
        bottomBar.updateSliderTouchEnded(value: sliderValue)
    }
    
    /// 更新播放按钮状态
    /// - Parameter playerState: 播放状态
    public func didUpdatePlayPauseStateInControls(playerState: PlayerState) {
        let hiddenStates: Set<PlayerState> = [.buffering, .waiting, .playing, .error]
        playImageView.isHidden = hiddenStates.contains(playerState)
    }
    
    /// 初始化滑块值
    /// - Parameter value: 初始值，默认 0.0
    public func didResetSliderPositionInControls(value: Float = 0.0) {
        bottomBar.resetSliderPosition(value: value)
    }
    
    /// 更新播放/暂停按钮状态
    /// - Parameter isPlaying: 是否正在播放
    public func didUpdatePlayPauseButtonStateInControls(isPlaying: Bool) {
        bottomBar.updatePlayPauseButtonState(isPlaying: isPlaying)
    }
    
    /// 更新倍数按钮状态
    /// - Parameter rate: 当前倍数
    public func didUpdatePlaybackRateButtonInControls(rate: Float) {
        guard let bottomBar = bottomBar as? ARTVideoPlayerLandscapeFullscreenBottombar else { return }
        bottomBar.updateRateButtonTitle(rate: rate)
    }
    
    /// 切换控制条的显示与隐藏状态
    public func didToggleControlsVisibilityInControls() {
        toggleControlsInControls(visible: isHiddenControls)
        didResetAutoHideTimerInControls()
    }
    
    /// 移除顶部和底部工具栏
    public func didRemoveToolBarsInControls() {
        topBar.removeFromSuperview()
        bottomBar.removeFromSuperview()
        playImageView.removeFromSuperview()
    }
    
    /// 自动获取视频屏幕方向
    public func didAutoVideoScreenOrientation() -> ScreenOrientation {
        return autoVideoScreenOrientation()
    }
    
    /// 自动隐藏控件
    @objc public func didAutoHideControls() {
        autoHideControls()
    }
    
    /// 重置自动隐藏定时器
    public func didResetAutoHideTimerInControls() {
        stopAutoHideTimer()
        startAutoHideTimer()
    }
    
    /// 停止并销毁定时器的方法
    public func didStopAutoHideTimer() {
        stopAutoHideTimer()
    }
    
    /// 显隐控件
    /// - Parameter visible: 是否显示
    public func didToggleControlsInControls(visible: Bool) {
        toggleControlsInControls(visible: visible)
    }
    
    /// 处理播放器状态
    /// - Parameter isPlaying: 是否正在播放
    public func didUpdatePlayerStateInControls(isPlaying: Bool) {
        if isPlaying {
            stopAutoHideTimer()
        } else {
            didResetAutoHideTimerInControls()
        }
    }
    
    /// 本地存储弹幕状态
    public func didSaveDanmakuStateInControls(_ isDanmakuEnabled: Bool) {
        UserDefaults.standard.set(isDanmakuEnabled, forKey: "DanmakuEnabledKey")
    }
    
    /// 获取当前滑块的值
    public func getSliderPositionInControls() -> Float {
        return bottomBar.sliderView.value
    }
}

// MARK: - Setup Initializer

extension ARTVideoPlayerControlsView {
    
    /// 创建顶部和底部工具栏
    private func setupToolBars() {
        setupTopBar()
        setupBottomBar()
        setupPlayButton()
        startAutoHideTimer()
    }
    
    /// 创建顶部工具栏
    private func setupTopBar() {
        let topBarHeight = topBarHeight(for: screenOrientation)
        topBar = defaultCustomTopBar()
        addSubview(topBar)
        topBar.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(topBarHeight)
        }
    }
    
    /// 创建底部工具栏
    private func setupBottomBar() {
        let bottomBarHeight = bottomBarHeight(for: screenOrientation)
        bottomBar = defaultCustomBottomBar()
        addSubview(bottomBar)
        bottomBar.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(bottomBarHeight)
        }
    }
    
    /// 创建播放和重试按钮
    private func setupPlayButton() {
        playImageView = UIImageView()
        playImageView.isHidden = true
        playImageView.alpha = 0.5
        playImageView.image = UIImage(named: "icon_video_play")
        addSubview(playImageView)
        playImageView.snp.makeConstraints { make in
            make.size.equalTo(ARTAdaptedSize(width: 40.0, height: 40.0))
            make.centerX.centerY.equalToSuperview()
        }
    }
}

// MARK: - Private Methods

extension ARTVideoPlayerControlsView {
    
    /// 根据屏幕方向返认顶部栏
    private func defaultCustomTopBar() -> ARTVideoPlayerTopbar {
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
    private func defaultCustomBottomBar() -> ARTVideoPlayerBottombar {
        switch screenOrientation {
        case .portraitFullScreen:
            return ARTVideoPlayerPortraitFullscreenBottombar(self)
        case .landscapeFullScreen:
            return ARTVideoPlayerLandscapeFullscreenBottombar(self)
        case .window:
            return ARTVideoPlayerWindowBottombar(self)
        }
    }
    
    /// 切换到窗口模式，设置屏幕方向并刷新顶部和底部栏
    private func topBarHeight(for orientation: ScreenOrientation) -> CGFloat {
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
    private func bottomBarHeight(for orientation: ScreenOrientation) -> CGFloat {
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
    private func autoVideoScreenOrientation() -> ScreenOrientation {
        return isLandscape ? .landscapeFullScreen : .portraitFullScreen
    }
    
    /// 开启隐藏控件定时器
    private func startAutoHideTimer() {
        guard autoHideControlsTimer == nil, isLandscape else { return }
        autoHideControlsTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(autoHideControls), userInfo: nil, repeats: false)
    }
    
    /// 自动隐藏控件
    @objc private func autoHideControls() {
        toggleControlsInControls(visible: false)
    }
      
    /// 显隐控件
    /// - Parameter visible: 是否显示
    private func toggleControlsInControls(visible: Bool) {
        isHiddenControls = !visible
        if screenOrientation == .window { // 窗口模式下调整透明度
            let targetAlpha: CGFloat = visible ? 1 : 0
            UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut], animations: {
                self.delegate_controlsViewDidChangeAlpha(alpha: targetAlpha)
                self.bottomBar.alpha = targetAlpha
            })
        } else { // 横屏全屏模式下调整约束
            updateBarsVisibility(visible: visible)
            UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut], animations: {
                self.layoutIfNeeded()
            })
        }
    }
    
    /// 更新工具栏约束
    private func updateBarsVisibility(visible: Bool) {
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
    
    /// 停止并销毁定时器的方法
    private func stopAutoHideTimer() {
        autoHideControlsTimer?.invalidate()
        autoHideControlsTimer = nil
    }
}

// MARK: - Private Delegate Methods

extension ARTVideoPlayerControlsView {
    
    /// 控制层视图已经显示
    /// - Parameters: alpha 控制层视图透明度
    private func delegate_controlsViewDidChangeAlpha(alpha: CGFloat) {
        delegate?.controlsView(self, didChangeAlpha: alpha)
    }
}
