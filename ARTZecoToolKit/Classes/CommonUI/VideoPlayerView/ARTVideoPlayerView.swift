//
//  ARTVideoPlayerView.swift
//  Pods
//
//  Created by mrSir18 on 2024/10/19.
//

/// 协议方法
///
/// - NOTE: 可继承该协议方法
@objc public protocol ARTVideoPlayerViewDelegate: AnyObject {
    
    /// 获取播放器基类视图
    ///
    ///  Parameter playerView: 基类视图
    ///  Returns: 播放器基类视图
    @objc optional func playerViewWrapper(for playerView: ARTVideoPlayerView) -> ARTVideoPlayerWrapperView?
}

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
    
    /// 开始播放视频
    /// - Parameter url: 视频文件或资源的 URL
    @objc open func startVideoPlayback(with url: URL?) {
        wrapperView.startVideoPlayback(with: url)
    }
    
    /// 播放下一集视频
    /// - Parameter url: 视频文件或资源的 URL
    @objc open func playNextVideo(with url: URL?) {
        wrapperView.playNextVideo(with: url)
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
        guard let wrapperView = delegate_customPlayerWrapper() else { return }
        addArrangedSubview(wrapperView)
        self.wrapperView = wrapperView
    }
}

// MARK: - Private Delegate Methods

extension ARTVideoPlayerView {
    
    /// 获取自定义播放器图层
    private func delegate_customPlayerWrapper() -> ARTVideoPlayerWrapperView? {
        return delegate?.playerViewWrapper?(for: self)
    }
}
