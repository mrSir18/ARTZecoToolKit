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
    ///  - Returns: 自定义顶部工具栏视图
    ///  - Note: 返回自定义顶部工具栏视图，若返回 nil 则使用默认顶部工具栏视图
    ///  - Note: 自定义顶部工具栏视图需继承 ARTVideoPlayerTopBar
    @objc optional func customTopBar(for playerView: ARTVideoPlayerView) -> ARTVideoPlayerTopBar?
    
    /// 自定义底部工具栏视图
    ///
    /// - Parameters:
    ///  - playerView: 视频播放器视
    ///  - Returns: 自定义底部工具栏视图
    ///  - Note: 返回自定义底部工具栏视图，若返回 nil 则使用默认底部工具栏视图
    ///  - Note: 自定义底部工具栏视图需继承 ARTVideoPlayerBottomBar
    @objc optional func customBottomBar(for playerView: ARTVideoPlayerView) -> ARTVideoPlayerBottomBar?
}

extension ARTVideoPlayerView {
    /// 顶部和底部栏状态
    public enum TopBottomBarState {
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
    
    
    // MARK: - 控件属性
    
    /// 导航栏视图
    private var topBar: ARTVideoPlayerTopBar!
    
    ///  底部工具栏视图
    private var bottomBar: ARTVideoPlayerBottomBar!
    
    
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
        setupTopBar()
        setupBottomBar()
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
    /// - Note: 使用代理返回的自定义顶部工具栏视图，若返回 nil 则创建默认的底部工具栏视图
    /// - Note: 默认导航栏视图需继承 ARTVideoPlayerTopBar
    open func setupTopBar() {
        if let customTopBar = delegate?.customTopBar?(for: self) { // 使用代理返回的自定义顶部工具栏视图
            topBar = customTopBar
            
        } else { // 创建默认的导航栏视图
            topBar = ARTVideoPlayerTopBar(self)
            addSubview(topBar)
            topBar.snp.makeConstraints { make in
                make.top.left.right.equalToSuperview()
                make.height.equalTo(art_navigationFullHeight())
            }
        }
    }
    
    /// 创建底部工具栏
    ///
    /// 重写父类方法，设置子视图
    /// - Note: 使用代理返回的自定义底部工具栏视图，若返回 nil 则创建默认的底部工具栏视图
    /// - Note: 默认底部工具栏视图需继承 ARTVideoPlayerBottomBar
    open func setupBottomBar() {
        if let customBottomBar = delegate?.customBottomBar?(for: self) { // 使用代理返回的自定义底部工具栏视图
            bottomBar = customBottomBar
            
        } else { // 创建默认的底部工具栏视图
            bottomBar = ARTVideoPlayerBottomBar(self)
            addSubview(bottomBar)
            bottomBar.snp.makeConstraints { make in
                make.left.bottom.right.equalToSuperview()
                make.height.equalTo(art_tabBarFullHeight())
            }
        }
    }
}

// MARK: - ARTVideoPlayerTopBarDelegate

extension ARTVideoPlayerView: ARTVideoPlayerTopBarDelegate {
    
}

// MARK: - ARTVideoPlayerTopBar

extension ARTVideoPlayerView: ARTVideoPlayerBottomBarDelegate {
    
}
