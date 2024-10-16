//
//  ARTVideoPlayerView.swift
//  Pods
//
//  Created by mrSir18 on 2024/10/15.
//

import AVFoundation

@objc public protocol ARTVideoPlayerViewProtocol: AnyObject {
    
    /// 自定义顶部工具栏视图
    ///
    /// - Parameters:
    ///  - playerView: 视频播放器视
    ///  - playerMode: 视频播放器视图模式
    ///  - Returns: 自定义顶部工具栏视图
    ///  - Note: 自定义顶部工具栏视图需继承 ARTVideoPlayerTopbar
    @objc optional func customTopBar(for playerView: ARTVideoPlayerView) -> ARTVideoPlayerTopbar?
    
    /// 自定义底部工具栏视图
    ///
    /// - Parameters:
    ///  - playerView: 视频播放器视
    ///  - Returns: 自定义底部工具栏视图
    ///  - Note: 自定义底部工具栏视图需继承 ARTVideoPlayerBottombar
    @objc optional func customBottomBar(for playerView: ARTVideoPlayerView) -> ARTVideoPlayerBottombar?
    
    /// 自定义播放模式
    ///
    /// - Parameters:
    /// - playerView: 视频播放器视
    /// - Returns: 自定义播放模式
    /// - Note: 自定义播放模式ARTVideoPlayerView.VideoPlayerMode
    @objc optional func customPlayerMode(for playerView: ARTVideoPlayerView) -> ARTVideoPlayerView.VideoPlayerMode
}

extension ARTVideoPlayerView {
    
    /// 视频播放器视图模式
    @objc public enum VideoPlayerMode: Int {
        /// 窗口模式
        case window = 1
        /// 全屏模式
        case fullscreen = 2
    }
    
    /// 顶部和底部栏状态
    public enum TopBottomBarState: Int  {
        /// 隐藏
        case hidden
        /// 显示
        case visible
    }
}

open class ARTVideoPlayerView: ARTBaseVideoPlayerView {
    
    // MARK: - Private Properties
    
    /// 代理对象
    private weak var delegate: ARTVideoPlayerViewProtocol?
    
    /// 播放器配置模型
    private var playerConfig: ARTVideoPlayerConfig?
    
    // MARK: - 播放器相关属性
    
    /// 播放器视图模式
    private var playerMode: ARTVideoPlayerView.VideoPlayerMode = .window
    
    
    // MARK: - 控件属性
    
    /// 导航栏视图
    private var topBar: ARTVideoPlayerTopbar!
    
    ///  底部工具栏视图
    private var bottomBar: ARTVideoPlayerBottombar!
    
    
    // MARK: - Initialization

    public init(_ delegate: ARTVideoPlayerViewProtocol) {
        self.delegate = delegate
        super.init()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Override Methods
    
    open override func setupViews() {
        setup_privateDelegate()
        setupVideoPlayerView()
        setupTopBar()
        setupBottomBar()
        super.setupViews()
    }
    
    // MARK: - Setup Methods
    
    /// 设置代理对象
    open func setup_privateDelegate() {
        self.playerMode = delegate_customPlayerMode()
    }
    
    /// 创建视频播放器视图
    ///
    /// 重写父类方法，设置子视图
    /// - Note: 使用代理返回的自定义视频播放器视图，若返回 nil 则创建默认的视频播放器视图
    open func setupVideoPlayerView() {

    }
    
    /// 创建顶部工具栏
    ///
    /// 重写父类方法，设置子视图
    /// - Note: 默认导航栏视图需继承 ARTVideoPlayerTopbar
    open func setupTopBar() {
        if let customTopBar = delegate?.customTopBar?(for: self) { // 获取自定义顶部工具栏视图
            topBar = customTopBar
            
        } else { // 创建顶部工具栏视图
            topBar = ARTVideoPlayerWindowTopbar(self)
            addSubview(topBar)
            topBar.snp.makeConstraints { make in
                make.top.left.right.equalToSuperview()
                make.height.equalTo(art_navigationBarHeight())
            }
//            make.height.equalTo(ARTAdaptedValue(66.0))
        }
    }
    
    /// 创建底部工具栏
    ///
    /// 重写父类方法，设置子视图
    /// - Note: 默认底部工具栏视图需继承 ARTVideoPlayerBottombar
    open func setupBottomBar() {
        if let customBottomBar = delegate?.customBottomBar?(for: self) { // 获取自定义底部工具栏视图
            bottomBar = customBottomBar
            
        } else { // 创建底部工具栏视图
            bottomBar = ARTVideoPlayerWindowBottombar(self)
            addSubview(bottomBar)
            bottomBar.snp.makeConstraints { make in
                make.left.bottom.right.equalToSuperview()
                make.height.equalTo(art_tabBarHeight())
            }
            
//            make.height.equalTo(ARTAdaptedValue(88.0))
        }
    }
    
    // MARK: - Public Methods
    
    /// 播放视频
    ///
    /// - Parameters:
    /// - config: 视频播放器配置模型
    /// - Note: 重写父类方法，播放视频
    open func playVideo(with config: ARTVideoPlayerConfig?) {
        guard let playerConfig = config, let url = playerConfig.url else {
            print("Invalid URL string")
            return
        }
        
    }
}

// MARK: - ARTVideoPlayerTopbarDelegate

extension ARTVideoPlayerView: ARTVideoPlayerTopbarDelegate {
    
    public func videoPlayerTopbarDidTapBack(_ topbar: ARTVideoPlayerTopbar) { // 点击返回按钮
        print("didTapBackButton")
    }
    
    public func videoPlayerTopbarDidTapFavorite(_ topbar: ARTVideoPlayerTopbar, isFavorited: Bool) { // 点击收藏按钮
        print("didTapFavoriteButton")
    }

    public func videoPlayerTopbarDidTapShare(_ topbar: ARTVideoPlayerTopbar) { // 点击分享按钮
        print("didTapShareButton")
    }
}

// MARK: - ARTVideoPlayerTopbar

extension ARTVideoPlayerView: ARTVideoPlayerBottombarDelegate {
    
}

// MARK: - Private ARTVideoPlayerViewProtocol

extension ARTVideoPlayerView {
    
    /// 获取自定义播放模式
    ///
    /// - Returns: 自定义播放模式
    /// - Note: 优先使用代理返回的自定义播放模式，若代理未实现则使用默认播放模式
    private func delegate_customPlayerMode() -> ARTVideoPlayerView.VideoPlayerMode {
        return self.delegate?.customPlayerMode?(for: self) ?? .window
    }
}
