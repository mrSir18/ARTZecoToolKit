//
//  ARTViewController_VideoPlayer+DelegateImplementations.swift
//  ARTZecoToolKit_Example
//
//  Created by mrSir18 on 2025/3/8.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

extension ARTViewController_VideoPlayer: ARTVideoPlayerEnhancedViewDelegate {
    
    func enhancedView(_ enhancedView: ARTVideoPlayerEnhancedView, didChangeAlpha alpha: CGFloat) { // 改变顶底栏透明度
        print("透明度：\(alpha)")
    }
    
    func enhancedView(_ enhancedView: ARTVideoPlayerEnhancedView, didToggleFullscreen isFullscreen: Bool) { // 视频切换模式
        print("切换全屏：\(isFullscreen)")
    }
    
    func enhancedView(_ enhancedView: ARTVideoPlayerEnhancedView, didTapButton sender: UIButton) { // 顶底栏按钮点击事件
        guard let buttonType = ARTVideoPlayerControls.ButtonType(rawValue: sender.tag) else { return }
        print("点击了按钮：\(buttonType)")
    }
}
