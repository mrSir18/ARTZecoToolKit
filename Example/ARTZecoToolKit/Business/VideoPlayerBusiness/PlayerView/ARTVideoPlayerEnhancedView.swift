//
//  ARTVideoPlayerEnhancedView.swift
//  ARTZecoToolKit_Example
//
//  Created by mrSir18 on 2025/3/10.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import ARTZecoToolKit

class ARTVideoPlayerEnhancedView: ARTVideoPlayerView {
    
    /// 代理对象
    public weak var delegate: ARTVideoPlayerEnhancedViewDelegate?
    
    /// 视频播放器包装视图
    public var wrapperView: ARTVideoPlayerEnhancedWrapperView!
    
    
    // MARK: - Initialization
    
    public init(_ delegate: ARTVideoPlayerEnhancedViewDelegate? = nil) {
        self.delegate = delegate
        super.init()
    }
    
    @MainActor required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    override func setupVideoWrapperView() { /// 设置视频包装视图
        wrapperView = ARTVideoPlayerEnhancedWrapperView(self)
        addArrangedSubview(wrapperView)
    }
}

// MARK: - Public Methods

extension ARTVideoPlayerEnhancedView {

    /// 开始播放视频
    /// - Parameter url: 视频文件或资源的 URL
    @objc open func startVideoPlayback(with url: URL?) {
        wrapperView?.startVideoPlayback(with: url)
    }
}
