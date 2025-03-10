//
//  ARTVideoPlayerView.swift
//  Pods
//
//  Created by mrSir18 on 2024/10/19.
//

import UIKit

/// 视频播放器栈视图，管理视频播放器的显示
open class ARTVideoPlayerView: UIStackView {
    
    // MARK: - Initialization
    
    public init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required public init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    open func setupViews() {
        setupDefaults()
        setupVideoWrapperView()
    }
}

// MARK: - Setup Initializer

extension ARTVideoPlayerView {
    
    /// 设置默认属性
    @objc open func setupDefaults() {
        insetsLayoutMarginsFromSafeArea = false // 不受安全区域影响
        distribution = .fill // 填充整个栈视图
        alignment = .fill // 子视图填充对齐
    }
    
    /// 设置视频包装视图
    @objc open func setupVideoWrapperView() {
        
    }
}
