//
//  MRVideoPlayerView.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/10/19.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

/// 视频播放器栈视图，管理视频播放器的显示
open class MRVideoPlayerView: UIStackView {

    // MARK: - Initialization
    
    /// 初始化方法
    public init() {
        super.init(frame: .zero)
        setupDefaults()
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

    // MARK: - Override Methods
    
    /// 初始化播放器视图
    ///
    /// - Parameter playerView: 播放器视图
    open func setupVideoPlayerView() {
        let videoWrapperView = MRVideoPlayerWrapperView()
        addArrangedSubview(videoWrapperView)
        
        
        // MARK: - Test Methods
        
        let url = URL(string: "https://media.w3.org/2010/05/sintel/trailer.mp4")!
        videoWrapperView.playVideo(with: url) // 播放视频
    }
}
