//
//  ARTVideoPlayerView.swift
//  Pods
//
//  Created by mrSir18 on 2024/10/19.
//


import UIKit
import AVFoundation
import MobileCoreServices

/// 视频播放器栈视图，管理视频播放器的显示
open class ARTVideoPlayerView: UIStackView {

    // MARK: - Initialization
    
    public init() {
        super.init(frame: .zero)
        setupDefaults()
        setupSupportedAVPlayerFileExtensions()
        setupVideoPlayerView()
    }
    
    required public init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
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

    // MARK: - Override Methods
    
    /// 初始化播放器视图
    ///
    /// - Parameter playerView: 播放器视图
    open func setupVideoPlayerView() {
        let videoWrapperView = ARTVideoPlayerWrapperView(self)
        addArrangedSubview(videoWrapperView)
        
        
        // MARK: - Test Methods
        
        let config = ARTVideoPlayerConfig()
        config.url = URL(string: "https://www.apple.com/105/media/cn/mac/family/2018/46c4b917_abfd_45a3_9b51_4e3054191797/films/bruce/mac-bruce-tpl-cn-2018_1280x720h.mp4")
//        config.url = URL(fileURLWithPath: Bundle.main.path(forResource: "video", ofType: "MOV")!)
//        https://www.w3school.com.cn/example/html5/mov_bbb.mp4
//        http://vjs.zencdn.net/v/oceans.mp4
        videoWrapperView.startVideoPlayback(with: config)
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
