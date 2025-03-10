//
//  ARTVideoPlayerEnhancedView+DelegateImplementations.swift
//  ARTZecoToolKit_Example
//
//  Created by mrSir18 on 2025/3/10.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

extension ARTVideoPlayerEnhancedView: ARTVideoPlayerEnhancedWrapperViewDelegate {
    
    func wrapperView(_ wrapperView: ARTVideoPlayerEnhancedWrapperView, didChangeAlpha alpha: CGFloat) { // 改变顶底栏透明度
        delegate?.enhancedView(self, didChangeAlpha: alpha)
    }
    
    func wrapperView(_ wrapperView: ARTVideoPlayerEnhancedWrapperView, didToggleFullscreen isFullscreen: Bool) { // 视频切换模式
        delegate?.enhancedView(self, didToggleFullscreen: isFullscreen)
    }
    
    func wrapperView(_ wrapperView: ARTVideoPlayerEnhancedWrapperView, didTapButton sender: UIButton) { // 顶底栏按钮点击事件
        delegate?.enhancedView(self, didTapButton: sender)
    }
}
