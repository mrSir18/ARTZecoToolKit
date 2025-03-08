//
//  ARTViewController_VideoPlayer+DelegateImplementations.swift
//  ARTZecoToolKit_Example
//
//  Created by mrSir18 on 2025/3/8.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import ARTZecoToolKit

// MARK: - ARTVideoPlayerViewDelegate

extension ARTViewController_VideoPlayer: ARTVideoPlayerViewDelegate {
    
    func playerViewWrapper(for playerView: ARTVideoPlayerView) -> ARTVideoPlayerWrapperView? { // 获取播放器基类
        return ARTVideoPlayerEnhancedWrapperView(self)
    }
}

// MARK: - ARTVideoPlayerEnhancedWrapperViewDelegate

extension ARTViewController_VideoPlayer: ARTVideoPlayerEnhancedWrapperViewDelegate {
    
    func wrapperView(_ wrapperView: ARTVideoPlayerEnhancedWrapperView, didChangeAlpha alpha: CGFloat) { // 改变顶底栏透明度
        print("透明度：\(alpha)")
    }
    
    func wrapperView(_ wrapperView: ARTVideoPlayerEnhancedWrapperView, didToggleFullscreen isFullscreen: Bool) { // 视频切换模式
        print("切换全屏：\(isFullscreen)")
    }
    
    func wrapperView(_ wrapperView: ARTVideoPlayerEnhancedWrapperView, didTapButton sender: UIButton) { // 顶底栏按钮点击事件
        guard let buttonType = ARTVideoPlayerControls.ButtonType(rawValue: sender.tag) else { return }
        print("点击了按钮：\(buttonType)")
    }
}
