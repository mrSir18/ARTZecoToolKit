//
//  ARTVideoPlayerCustomWrapperView.swift
//  Pods
//
//  Created by mrSir18 on 2024/10/15.
//

import ARTZecoToolKit

class ARTVideoPlayerCustomWrapperView: ARTVideoPlayerWrapperView {
    
    // MARK: - 播放器组件 AVPlayer（最底层：播放器视图）
    
    /// 播放器图层（最底层：用于显示弹幕、广告等）
    public var overlayView: UIView!
    
    /// 播放器系统控制层（中间层：系统控制，位于弹幕、广告等之上）
    public var systemControls: UIView!
    
    /// 播放器控制层（最顶层：顶部栏、侧边栏等）
    public var controlsView: ARTVideoPlayerControlsView!
    
    /// 播放器加载动画视图
    public var loadingView: UIView!
    
    
    // MARK: - Initialization
    
    override func setupViews() {
        super.setupViews()
        
    }
    
    /// 创建播放器图层（最底层：用于显示弹幕、广告等）
    override func setupOverlayView() {

    }
    
    /// 创建系统控制层（中间层：系统控制）
    override func setupSystemControls() {

    }
    
    /// 创建加载动画视图
    override func setupLoadingView() {

    }
    
    /// 创建播放器控制层（最顶层：顶部栏、侧边栏等）
    override func setupControlsView() {
        controlsView = ARTVideoPlayerControlsView(self)
        addSubview(controlsView)
        controlsView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: Override Methods

extension ARTVideoPlayerCustomWrapperView {
    
}
