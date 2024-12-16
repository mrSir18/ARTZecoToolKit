//
//  ARTVideoPlayerView+DelegateImplementations.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/11/2.
//

// MARK: - ARTVideoPlayerWrapperViewDelegate

extension ARTVideoPlayerView: ARTVideoPlayerWrapperViewDelegate {
    
    public func wrapperViewOverlay(for wrapperView: ARTVideoPlayerWrapperView) -> ARTVideoPlayerOverlayView? { // 获取播放器图层（最底层：用于显示弹幕、广告等）
        return delegate?.playerViewOverlay?(for: self)
    }
    
    public func wrapperViewSystemControls(for wrapperView: ARTVideoPlayerWrapperView) -> ARTVideoPlayerSystemControls? { // 获取播放器系统控制层（中间层：系统控制）
        return delegate?.playerViewSystemControls?(for: self)
    }
    
    public func wrapperViewControls(for wrapperView: ARTVideoPlayerWrapperView) -> ARTVideoPlayerControlsView? { // 获取播放器控制层（最顶层：顶部栏、侧边栏等）
        return delegate?.playerViewControls?(for: self)
    }
    
    public func wrapperViewLoading(for wrapperView: ARTVideoPlayerWrapperView) -> ARTVideoPlayerLoadingView? { // 返回播放器的加载动画视图，用于显示加载动画
        return delegate?.playerViewLoading?(for: self)
    }
}
