//
//  ARTVideoPlayerView.swift
//  Pods
//
//  Created by mrSir18 on 2024/10/14.
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
    @objc optional func customTopBar(for playerView: ARTVideoPlayerView, playerMode: ARTVideoPlayerView.VideoPlayerMode) -> ARTVideoPlayerTopbar?
    
    /// 自定义底部工具栏视图
    ///
    /// - Parameters:
    ///  - playerView: 视频播放器视
    ///  - Returns: 自定义底部工具栏视图
    ///  - Note: 自定义底部工具栏视图需继承 ARTVideoPlayerBottombar
    @objc optional func customBottomBar(for playerView: ARTVideoPlayerView, playerMode: ARTVideoPlayerView.VideoPlayerMode) -> ARTVideoPlayerBottombar?
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

open class ARTVideoPlayerView: UIView {
    
    // MARK: - Private Properties
    
    /// 代理对象
    private weak var delegate: ARTVideoPlayerViewProtocol?
    
    
    // MARK: - 播放器相关属性
    
    /// 视频播放器
    private var player: AVPlayer!
    
    /// 播放器图层
    private var layerLayer: AVPlayerLayer!
    
    /// 播放器的状态
    private var playerItem: AVPlayerItem!
    
    /// 播放器的播放状态
    private var isPlaying = false
    
    /// 播放器的时间观察者
    private var timeObserver: Any?
    
    /// 播放器的时间观察者间隔
    private var timeObserverInterval = CMTime(value: 1, timescale: 1)

    /// 是否正在拖动音量条
    private var isDraggingVolumeSlider = false
    
    /// 是否正在拖动亮度条
    private var isDraggingBrightnessSlider = false
    
    /// 是否正在拖动进度条
    private var isDraggingProgressSlider = false
    
    /// 播放器视图模式
    private var playerMode: ARTVideoPlayerView.VideoPlayerMode = .window
    
    
    // MARK: - 控件属性
    
    /// 导航栏视图
    private var topBar: ARTVideoPlayerTopbar!
    
    ///  底部工具栏视图
    private var bottomBar: ARTVideoPlayerBottombar!
    
    
    // MARK: - Initialization
    
    public init(_ delegate: ARTVideoPlayerViewProtocol? = nil) {
        super.init(frame: .zero)
        self.delegate = delegate
        self.backgroundColor = .clear
        setupViews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Methods
    
    open func setupViews() {
        setupVideoPlayerView()
        setupWindowTopBar()
        setupWindowBottomBar()
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
    open func setupWindowTopBar() {
        if let customTopBar = delegate?.customTopBar?(for: self, playerMode: playerMode) { // 获取自定义顶部工具栏视图
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
    open func setupWindowBottomBar() {
        if let customBottomBar = delegate?.customBottomBar?(for: self, playerMode: playerMode) { // 获取自定义底部工具栏视图
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
}

// MARK: - ARTVideoPlayerTopbarDelegate

extension ARTVideoPlayerView: ARTVideoPlayerTopbarDelegate {
    
}

// MARK: - ARTVideoPlayerTopbar

extension ARTVideoPlayerView: ARTVideoPlayerBottombarDelegate {
    
}
