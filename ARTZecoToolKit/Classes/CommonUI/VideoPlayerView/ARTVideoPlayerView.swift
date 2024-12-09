//
//  ARTVideoPlayerView.swift
//  Pods
//
//  Created by mrSir18 on 2024/10/19.
//

/// 视频播放器栈视图，管理视频播放器的显示
open class ARTVideoPlayerView: UIStackView {
    
    /// 代理对象
    public weak var delegate: ARTVideoPlayerViewDelegate?
    
    /// 视频播放器包装视图
    public var wrapperView: ARTVideoPlayerWrapperView!
    
    
    // MARK: - Initialization
    
    public init(_ delegate: ARTVideoPlayerViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        setupDefaults()
        setupVideoWrapperView()
    }
    
    required public init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Public Methods
    
    /// 开始播放视频
    ///
    /// - Parameter config: 视频播放器配置模型
    /// - Note: 重写父类方法，播放视频
    open func startVideoPlayback(with config: ARTVideoPlayerConfig?) {
        wrapperView.startVideoPlayback(with: config)
    }
    
    /// 开始弹幕播放
    /// - Note: 重写父类方法，开始弹幕播放
    open func startDanmaku() {
        wrapperView.startDanmaku()
    }
}

// MARK: Private Methods

extension ARTVideoPlayerView {
    
    /// 设置默认属性
    private func setupDefaults() {
        insetsLayoutMarginsFromSafeArea = false // 不受安全区域影响
        distribution = .fill // 填充整个栈视图
        alignment = .fill // 子视图填充对齐
    }
}

// MARK: - Setup Initializer

extension ARTVideoPlayerView {
    
    /// 初始化播放器视图
    ///
    /// - Parameter playerView: 播放器视图
    @objc open func setupVideoWrapperView() {
        wrapperView = ARTVideoPlayerWrapperView(self)
        addArrangedSubview(wrapperView)
    }
}
