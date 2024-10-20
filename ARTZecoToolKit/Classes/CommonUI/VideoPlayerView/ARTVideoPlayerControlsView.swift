//
//  ARTVideoPlayerControlsView.swift
//  Pods
//
//  Created by mrSir18 on 2024/10/19.
//

/// 协议方法
///
/// - NOTE: 可继承该协议方法
@objc public protocol ARTVideoPlayerControlsViewDelegate: AnyObject {
    
    /// 自定义播放模式
    ///
    /// - Parameters:
    ///   - playerControlsView: 控制层视图
    ///   - Returns: 自定义播放模式
    ///   - Note: 自定义播放模式 ARTVideoPlayerWrapperView.VideoPlayerMode
    @objc optional func customScreenOrientation(for playerControlsView: ARTVideoPlayerControlsView) -> ScreenOrientation
    
    /// 自定义顶部工具栏视图
    ///
    /// - Parameters:
    ///   - playerControlsView: 控制层视图
    ///   - screenOrientation: 当前屏幕方向
    ///   - Returns: 自定义顶部工具栏视图
    ///   - Note: 自定义顶部工具栏视图需继承 ARTVideoPlayerTopbar
    @objc optional func customTopBar(for playerControlsView: ARTVideoPlayerControlsView, screenOrientation: ScreenOrientation) -> ARTVideoPlayerTopbar?
    
    /// 自定义底部工具栏视图
    ///
    /// - Parameters:
    ///   - playerControlsView: 控制层视图
    ///   - screenOrientation: 当前屏幕方向
    ///   - Returns: 自定义底部工具栏视图
    ///   - Note: 自定义底部工具栏视图需继承 ARTVideoPlayerBottombar
    @objc optional func customBottomBar(for playerControlsView: ARTVideoPlayerControlsView, screenOrientation: ScreenOrientation) -> ARTVideoPlayerBottombar?
    
    /// 点击返回按钮
    ///
    /// - Note: 子类实现该方法处理返回操作
    @objc optional func videoPlayerControlsDidTapBack(_ playerControlsView: ARTVideoPlayerControlsView)
    
    /// 点击收藏按钮
    ///
    /// - Parameters:
    ///  - playerControlsView: 控制层视图
    ///  - isFavorited: `true` 表示添加收藏，`false` 表示取消收藏
    /// - Note: 子类实现该方法处理收藏状态的改变
    @objc optional func videoPlayerControlsDidTapFavorite(_ playerControlsView: ARTVideoPlayerControlsView, isFavorited: Bool)
    
    /// 点击分享按钮
    ///
    /// - Note: 子类实现该方法处理分享操作
    @objc optional func videoPlayerControlsDidTapShare(_ playerControlsView: ARTVideoPlayerControlsView)
    
    /// 全屏切换
    ///
    /// - Parameters:
    ///  - playerControlsView: 控制层视图
    ///  - orientation: 屏幕方向
    ///  - Note: 切换全屏和窗口模式
    ///  - Note: 重写父类方法，切换全屏和窗口模式
    @objc optional func transitionToFullscreen(for playerControlsView: ARTVideoPlayerControlsView, orientation: ScreenOrientation)
}

extension ARTVideoPlayerControlsView {
    
    /// 顶底栏显示状态
    public enum ToolbarVisibility: Int {
        case hidden     = 1 // 隐藏
        case visible    = 2 // 显示
    }
}

open class ARTVideoPlayerControlsView: UIView {
    
    // MARK: - Private Properties
    
    /// 代理对象
    private weak var delegate: ARTVideoPlayerControlsViewDelegate?
 
    /// 播放器当前的屏幕方向
    private lazy var screenOrientation: ScreenOrientation = {
        return delegate_customScreenOrientation()
    }()
    
    /// 当前顶底栏显示状态
    private var toolbarVisibility: ToolbarVisibility = .visible // 默认显示


    // MARK: - 播放器组件
    
    /// 导航栏视图
    private var topBar: ARTVideoPlayerTopbar!
    
    /// 底部工具栏视图
    private var bottomBar: ARTVideoPlayerBottombar!
    
    
    // MARK: - 自定义播放器属性
    
    /// 是否横向全屏
    public var isLandscape: Bool = true
    
    /// 自动获取视频屏幕方向
    private lazy var videoScreenOrientation: ScreenOrientation = {
        return isLandscape ? .landscapeFullScreen : .portraitFullScreen
    }()
    
    
    // MARK: - Initialization
    
    public init(_ delegate: ARTVideoPlayerControlsViewDelegate? = nil) {
        super.init(frame: .zero)
        self.delegate = delegate
        self.backgroundColor = .clear
        setupViews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Super Methods
    
    /// 重写父类方法，设置子视图
    ///
    /// - Note: 由于子类需要自定义视图，所以需要重写该方法
    open func setupViews() {
        setupToolBars()
    }
    
    // MARK: - Public Methods
    
    /// 旋转屏幕（设置屏幕方向并刷新顶部和底部栏）
    ///
    /// - Parameter orientation: 屏幕方向
    /// - Note: 重写父类方法，旋转屏幕时，切换全屏和窗口模式
    open func transitionToFullscreen(orientation: ScreenOrientation) {
        self.screenOrientation = orientation
        setupToolBars()
    }
}

// MARK: - Setup Initializer

extension ARTVideoPlayerControlsView {
    
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
                make.left.top.right.equalToSuperview()
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
    
    /// - Note: 移除顶部和底部工具栏
    private func removeToolBars() {
        topBar.removeFromSuperview()
        bottomBar.removeFromSuperview()
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
            return art_tabBarHeight() // 普通窗口模式的高度
        }
    }
}

// MARK: - ARTVideoPlayerTopbarDelegate

/// - Note: 通用顶部工具栏代理
extension ARTVideoPlayerControlsView: ARTVideoPlayerTopbarDelegate {
    
    public func videoPlayerTopbarDidTapBack(_ topbar: ARTVideoPlayerTopbar) { // 点击返回按钮
        removeToolBars() // 移除顶底栏
        delegate?.videoPlayerControlsDidTapBack?(self)
    }
    
    public func videoPlayerTopbarDidTapFavorite(_ topbar: ARTVideoPlayerTopbar, isFavorited: Bool) { // 点击收藏按钮
        delegate?.videoPlayerControlsDidTapFavorite?(self, isFavorited: isFavorited)
    }
    
    public func videoPlayerTopbarDidTapShare(_ topbar: ARTVideoPlayerTopbar) { // 点击分享按钮
        delegate?.videoPlayerControlsDidTapShare?(self)
    }
}

// MARK: - ARTVideoPlayerBottombarDelegate

/// - Note: 通用底部工具栏代理
extension ARTVideoPlayerControlsView: ARTVideoPlayerBottombarDelegate {
    
}

/// - Note: 窗口模式底部工具栏代理
extension ARTVideoPlayerControlsView: ARTVideoPlayerWindowBottombarDelegate {
    
    public func videoPlayerBottombarDidTapFullscreen(_ bottombar: ARTVideoPlayerWindowBottombar) { // 点击全屏按钮
        removeToolBars() // 移除顶底栏
        delegate?.transitionToFullscreen?(for: self, orientation: videoScreenOrientation)
    }
}

// MARK: - Private Delegate Methods

extension ARTVideoPlayerControlsView {
    
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
}
