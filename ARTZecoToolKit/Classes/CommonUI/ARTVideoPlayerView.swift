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

open class ARTVideoPlayerView: ARTBaseVideoPlayerView {
    
    // MARK: - Private Properties
    
    /// 代理对象
    private weak var delegate: ARTVideoPlayerViewProtocol?
    
    
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
        super.init()
        self.delegate = delegate
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Override Methods
    
    open override func setupViews() {
        setupVideoPlayerView()
        setupTopBar()
        setupBottomBar()
        super.setupViews()
    }
    
    // MARK: - Setup Methods
    
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
    open func setupBottomBar() {
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
    
    // MARK: - Public Methods
    
    /// 播放视频
    ///
    /// - Parameters:
    ///  - url: 视频地址
    ///  - isLocal: 是否为本地视频
    ///  - isAutoPlay: 是否自动播放
    ///  - isLoop: 是否循环播放
    ///  - isMuted: 是否静音
    ///  - isFullScreen: 是否全屏
    ///  - isShowControl: 是否显示控制面板
    ///  - isShowTopBar: 是否显示顶部工具栏
    ///  - isShowBottomBar: 是否显示底部工具栏
    ///  - isShowLoading: 是否显示加载动画
    ///  - isShowPlayButton: 是否显示播放按钮
    ///  - isShowPauseButton: 是否显示暂停按钮
    ///  - isShowReplayButton: 是否显示重播按钮
    ///  - isShowFullScreenButton: 是否显示全屏按钮
    ///  - isShowExitFullScreenButton: 是否显示退出全屏按钮
    ///  - isShowMuteButton: 是否显示静音按钮
    ///  - isShowUnmuteButton: 是否显示取消静音按钮
    ///  - isShowBackButton: 是否显示返回按钮
    ///  - isShowTitle: 是否显示标题
    ///  - isShowCurrentTime: 是否显示当前时间
    ///  - isShowTotalTime: 是否显示总时间
    ///  - isShowProgressSlider: 是否显示进度条
    ///  - isShowBufferProgress: 是否显示缓冲进度
    ///  - isShowVolumeSlider: 是否显示音量条
    ///  - isShowBrightnessSlider: 是否显示亮度条
    ///  - isShowRateButton: 是否显示倍速按钮
    ///  - isShowDefinitionButton: 是否显示清晰度按钮
    ///  - isShowScreenshotButton: 是否显示截图按钮
    ///  - isShowDanmakuButton: 是否显示弹幕按钮
    ///  - isShowSubtitleButton: 是否显示字幕按钮
    ///  - isShowSettingButton: 是否显示设置按钮
    ///  - isShowShareButton: 是否显示分享按钮
    ///  - isShowMoreButton: 是否显示更多按钮
    ///  - isShowLockButton: 是否显示锁定按钮
    ///  - isShowUnlockButton: 是否显示解锁按钮
    ///  - isShowErrorView: 是否显示错误视图
    ///  - isShowCompleteView: 是否显示完成视图
    ///  - isShowLoadingView: 是否显示加载视图
    ///  - isShowCoverView: 是否显示封面视图
    ///  - isShowPreviewView: 是否显示预览视图
    ///  - isShowWatermarkView: 是否显示水印视图
    ///  - isShowBackgroundView: 是否显示背景视图
    ///  - isShowBrightnessView: 是否显示亮度视图
    ///  - isShowVolumeView: 是否显示音量视图
    ///  - isShowDefinitionView: 是否显示清晰度视图
    ///  - isShowDanmakuView: 是否显示弹幕视图
    ///  - isShowSubtitleView: 是否显示字幕视图
    ///  - isShowSettingView: 是否显示设置视图
    ///  - isShowShareView: 是否显示分享视图
    ///  - isShowMoreView: 是否显示更多视图
    ///  - isShowLockView: 是否显示锁定视图
    ///  - isShowUnlockView: 是否显示解锁视图
}

// MARK: - ARTVideoPlayerTopbarDelegate

extension ARTVideoPlayerView: ARTVideoPlayerTopbarDelegate {
    
}

// MARK: - ARTVideoPlayerTopbar

extension ARTVideoPlayerView: ARTVideoPlayerBottombarDelegate {
    
}
