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
    @objc optional func customScreenOrientation(for playerWrapperView: ARTVideoPlayerWrapperView) -> ARTVideoPlayerWrapperView.ScreenOrientation
    
    /// 自定义顶部工具栏视图
    ///
    /// - Parameters:
    ///   - playerWrapperView: 视频播放器视图
    ///   - screenOrientation: 当前屏幕方向
    ///   - Returns: 自定义顶部工具栏视图
    ///   - Note: 自定义顶部工具栏视图需继承 ARTVideoPlayerTopbar
    @objc optional func customTopBar(for playerWrapperView: ARTVideoPlayerWrapperView, screenOrientation: ARTVideoPlayerWrapperView.ScreenOrientation) -> ARTVideoPlayerTopbar?
    
    /// 自定义底部工具栏视图
    ///
    /// - Parameters:
    ///   - playerWrapperView: 视频播放器视图
    ///   - screenOrientation: 当前屏幕方向
    ///   - Returns: 自定义底部工具栏视图
    ///   - Note: 自定义底部工具栏视图需继承 ARTVideoPlayerBottombar
    @objc optional func customBottomBar(for playerWrapperView: ARTVideoPlayerWrapperView, screenOrientation: ARTVideoPlayerWrapperView.ScreenOrientation) -> ARTVideoPlayerBottombar?
    
    /// 刷新状态栏外观
    ///
    /// - Parameters:
    ///   - playerWrapperView: 视频播放器视图
    ///   - isStatusBarHidden: 是否隐藏状态栏的状态
    ///   - Note: 调用此方法以更新状态栏外观
    @objc optional func refreshStatusBarAppearance(for playerWrapperView: ARTVideoPlayerWrapperView, isStatusBarHidden: Bool)
}

extension ARTVideoPlayerWrapperView {
    
    /// 播放器当前的屏幕方向
    @objc public enum ScreenOrientation: Int {
        case portraitFullScreen     = 1 // 竖屏全屏
        case landscapeFullScreen    = 2 // 横屏全屏
        case window                 = 3 // 普通窗口模式
    }
    
    /// 顶底栏显示状态
    public enum ToolbarVisibility: Int {
        case hidden     = 1 // 隐藏
        case visible    = 2 // 显示
    }
}

open class ARTVideoPlayerWrapperView: ARTBaseVideoPlayerWrapperView {
    
    // MARK: - Private Properties
    
    /// 代理对象
    private weak var delegate: ARTVideoPlayerWrapperViewProtocol?
    
    /// 播放器配置模型
    private var playerConfig: ARTVideoPlayerConfig?
    
    /// 播放器当前的屏幕方向
    private lazy var screenOrientation: ScreenOrientation = {
        return delegate_customScreenOrientation()
    }()
    
    /// 当前顶底栏显示状态
    private var toolbarVisibility: ToolbarVisibility = .visible // 默认显示
    
    /// 记录初始化Frame
    private var initialFrame: CGRect = .zero
    
    
    // MARK: - 播放器组件
    
    /// 导航栏视图
    private var topBar: ARTVideoPlayerTopbar!
    
    /// 底部工具栏视图
    private var bottomBar: ARTVideoPlayerBottombar!
    
    
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
        setupPlayerContainer()
        setupToolBars()
        super.setupViews()
    }
    
    // MARK: - Public Methods
    
    /// 播放视频
    ///
    /// - Parameters:
    /// - config: 视频播放器配置模型
    /// - Note: 重写父类方法，播放视频
    open func playVideo(with config: ARTVideoPlayerConfig?) {
        guard let config = config, let url = config.url else {
            print("Invalid video configuration or URL.")
            return
        }
        setupPreparePlayer(with: url)
        setupPlayerLayer()
        addPlayerObservers()
    }
    
    /// 播放下一集视频
    ///
    /// - Parameter url: 新的视频 URL
    /// - Note: 重写父类方法，播放下一集视频
    open func playNextEpisode(with url: URL) {
        let playerItem = AVPlayerItem(url: url)
        player?.replaceCurrentItem(with: playerItem)
        player?.play()
    }
    
    /// 旋转屏幕
    ///
    /// - Parameter orientation: 屏幕方向
    /// - Note: 重写父类方法，旋转屏幕时，切换全屏和窗口模式
    open func transitionToFullscreen(orientation: ScreenOrientation) {
        let duration: TimeInterval = 0.25 // 动画时长
        
        // 定义变换和框架
        let (transform, frame): (CGAffineTransform, CGRect) = {
            switch orientation {
            case .portraitFullScreen: // 竖屏全屏
                return (.identity, UIScreen.main.bounds)
            case .landscapeFullScreen: // 横屏全屏
                return (CGAffineTransform(rotationAngle: CGFloat.pi / 2), UIScreen.main.bounds)
            case .window: // 普通窗口模式
                return (.identity, initialFrame)
            }
        }()
        
        // 刷新状态栏外观
        delegate_refreshStatusBarAppearance(isHidden: (orientation == .landscapeFullScreen))
        
        UIView.animate(withDuration: duration, animations: {
            self.transform = transform
            self.topBar.removeFromSuperview()
            self.bottomBar.removeFromSuperview()
            
            // 更新播放器视图的框架
            self.frame = frame
            self.playerLayer.frame = self.bounds
            self.playerContainer.frame = self.bounds
            
            self.layoutIfNeeded()
        }) { _ in
            self.changeToFullscreen(orientation: orientation)
        }
    }
}

// MARK: - Setup Initializer

extension ARTVideoPlayerWrapperView {
    
    /// 创建播放器容器
    ///
    /// - Note: 重写父类方法，设置子视图
    @objc open func setupPlayerContainer() {
        playerContainer = UIView(frame: bounds)
        addSubview(playerContainer)
    }
    
    /// 创建顶部和底部工具栏
    ///
    /// - Note: 重写父类方法，设置子视图
    @objc open func setupToolBars() {
        setupTopBar()
        setupBottomBar()
    }
    
    /// 创建顶部工具栏
    ///
    /// 重写父类方法，设置子视图
    /// - Note: 默认导航栏视图需继承 ARTVideoPlayerTopbar
    @objc open func setupTopBar() {
        if let customTopBar = delegate_customTopBar() { // 获取自定义顶部工具栏视图
            topBar = customTopBar
        } else {
            topBar = defaultTopBarForOrientation()
            addSubview(topBar)
            topBar.snp.makeConstraints { make in
                make.top.left.right.equalToSuperview()
                make.height.equalTo(topBarHeight(for: screenOrientation))
            }
        }
    }
    
    /// 创建底部工具栏
    ///
    /// 重写父类方法，设置子视图
    /// - Note: 默认底部工具栏视图需继承 ARTVideoPlayerBottombar
    @objc open func setupBottomBar() {
        if let customBottomBar = delegate_customBottomBar() { // 获取自定义底部工具栏视图
            bottomBar = customBottomBar
        } else {
            bottomBar = defaultBottomBarForOrientation()
            addSubview(bottomBar)
            bottomBar.snp.makeConstraints { make in
                make.left.bottom.right.equalToSuperview()
                make.height.equalTo(bottomBarHeight(for: screenOrientation))
            }
        }
    }
    
    /// - Note: 准备播放器
    @objc open func setupPreparePlayer(with url: URL) {
        playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
    }
    
    /// - Note: 设置播放器图层
    @objc open func setupPlayerLayer() {
        guard let player = player else {
            print("Player is not initialized.")
            return
        }
        layoutIfNeeded()
        initialFrame = frame
        playerLayer?.removeFromSuperlayer()
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = bounds
        playerLayer.videoGravity = .resizeAspect
        
        if let playerLayer = playerLayer { // 添加播放器图层
            playerContainer.layer.addSublayer(playerLayer)
        }
    }
    
    // MARK: Private Methods
    
    /// - Note: 根据屏幕方向返认顶部栏
    private func defaultTopBarForOrientation() -> ARTVideoPlayerTopbar {
        switch screenOrientation {
        case .portraitFullScreen:
            return ARTVideoPlayerPortraitFullscreenTopbar(self)
        case .landscapeFullScreen:
            return ARTVideoPlayerLandscapeFullscreenTopbar(self)
        case .window:
            return ARTVideoPlayerWindowTopbar(self)
        }
    }
    
    /// - Note: 根据屏幕方向返回底部栏
    private func defaultBottomBarForOrientation() -> ARTVideoPlayerBottombar {
        switch screenOrientation {
        case .portraitFullScreen:
            return ARTVideoPlayerPortraitFullscreenBottombar(self)
        case .landscapeFullScreen:
            return ARTVideoPlayerLandscapeFullscreenBottombar(self)
        case .window:
            return ARTVideoPlayerWindowBottombar(self)
        }
    }
    
    /// - Note: 切换到全屏模式，设置屏幕方向并刷新顶部和底部栏
    private func changeToFullscreen(orientation: ScreenOrientation) {
        self.screenOrientation = orientation
        setupTopBar()
        setupBottomBar()
    }
    
    /// - Note: 切换到窗口模式，设置屏幕方向并刷新顶部和底部栏
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
    
    /// - Note: 切换到窗口模式，设置屏幕方向并刷新顶部和底部栏
    private func bottomBarHeight(for orientation: ScreenOrientation) -> CGFloat {
        switch orientation {
        case .portraitFullScreen:
            return ARTAdaptedValue(88.0) // 竖屏高度
        case .landscapeFullScreen:
            return ARTAdaptedValue(88.0) // 横屏高度
        case .window:
            return art_tabBarHeight()    // 普通窗口模式的高度
        }
    }
}

// MARK: - ARTVideoPlayerTopbarDelegate

extension ARTVideoPlayerWrapperView: ARTVideoPlayerTopbarDelegate {
    
    public func videoPlayerTopbarDidTapBack(_ topbar: ARTVideoPlayerTopbar) { // 点击返回按钮
        print("didTapBackButton")
    }
    
    public func videoPlayerTopbarDidTapFavorite(_ topbar: ARTVideoPlayerTopbar, isFavorited: Bool) { // 点击收藏按钮
        print("didTapFavoriteButton")
        transitionToFullscreen(orientation: .window) // 进入窗口
    }
    
    public func videoPlayerTopbarDidTapShare(_ topbar: ARTVideoPlayerTopbar) { // 点击分享按钮
        print("didTapShareButton")
        transitionToFullscreen(orientation: .landscapeFullScreen) // 进入横屏
    }
}

// MARK: - ARTVideoPlayerTopbar

extension ARTVideoPlayerWrapperView: ARTVideoPlayerBottombarDelegate {
    
}

// MARK: - Private Delegate Methods

extension ARTVideoPlayerWrapperView {
    
    /// 获取自定义播放模式
    ///
    /// - Returns: 自定义播放模式
    /// - Note: 优先使用代理返回的自定义播放模式，若代理未实现则使用默认播放模式
    private func delegate_customScreenOrientation() -> ScreenOrientation {
        guard let screenOrientation = delegate?.customScreenOrientation?(for: self) else {
            return .window
        }
        return screenOrientation
    }
    
    /// 获取自定义顶部工具栏
    ///
    /// - Returns: 自定义顶部工具栏
    /// - Note: 优先使用代理返回的自定义顶部工具栏，若代理未实现则使用默认
    private func delegate_customTopBar() -> ARTVideoPlayerTopbar? {
        guard let customTopBar = delegate?.customTopBar?(for: self, screenOrientation: screenOrientation) else {
            return nil
        }
        return customTopBar
    }
    
    /// 获取自定义底部工具栏
    ///
    /// - Returns: 自定义底部工具栏
    /// - Note: 优先使用代理返回的自定义底部工具栏，若代理未实现则使用默认
    private func delegate_customBottomBar() -> ARTVideoPlayerBottombar? {
        guard let customBottomBar = delegate?.customBottomBar?(for: self, screenOrientation: screenOrientation) else {
            return nil
        }
        return customBottomBar
    }
    
    /// 刷新状态栏外观
    ///
    /// - Note: 调用代理方法刷新状态栏外观
    private func delegate_refreshStatusBarAppearance(isHidden: Bool) {
        delegate?.refreshStatusBarAppearance?(for: self, isStatusBarHidden: isHidden)
    }
}
