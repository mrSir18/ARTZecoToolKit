//
//  ARTVideoPlayerView.swift
//  Pods
//
//  Created by mrSir18 on 2024/10/19.
//

import AVFoundation
import MobileCoreServices

/// 视频播放器栈视图，管理视频播放器的显示
open class ARTVideoPlayerView: UIStackView {
    
    /// 视频播放器包装视图
    private var videoWrapperView: ARTVideoPlayerWrapperView!
    
    
    // MARK: - Initialization
    
    public init() {
        super.init(frame: .zero)
        setupDefaults()
        setupSupportedAVPlayerFileExtensions()
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
        videoWrapperView.startVideoPlayback(with: config)
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
    
    /// 设置支持的 AVPlayer 文件扩展名
    private func setupSupportedAVPlayerFileExtensions() {
        print("\n\n本框架基于 AVPlayer 封装，支持格式：\n\n【\(supportedAVPlayerFileExtensions())】\n")
    }
}

// MARK: - Setup Initializer

extension ARTVideoPlayerView {
    
    /// 初始化播放器视图
    ///
    /// - Parameter playerView: 播放器视图
    @objc open func setupVideoWrapperView() {
        videoWrapperView = ARTVideoPlayerWrapperView(self)
        addArrangedSubview(videoWrapperView)
    }
}

extension ARTVideoPlayerView: ARTVideoPlayerWrapperViewProtocol {
    
}

// MARK: - Supported AVPlayer File Extensions

extension ARTVideoPlayerView {
    
    /// 获取支持的 AVPlayer 文件扩展名
    ///
    /// - Returns: 支持的 AVPlayer 文件扩展名
    private func supportedAVPlayerFileExtensions() -> String {
        return AVURLAsset.audiovisualTypes().compactMap {
            UTTypeCopyPreferredTagWithClass($0 as CFString, kUTTagClassFilenameExtension)?.takeRetainedValue() as String?
        }.joined(separator: ", ")
    }
}
