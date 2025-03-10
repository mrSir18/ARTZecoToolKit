//
//  ARTVideoPlayerEnhancedViewDelegate.swift
//  ARTZecoToolKit_Example
//
//  Created by mrSir18 on 2025/3/10.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

protocol ARTVideoPlayerEnhancedViewDelegate: AnyObject {
    
    /// 顶部导航栏透明度发生变化
    /// - Parameter alpha: 透明度
    func enhancedView(_ enhancedView: ARTVideoPlayerEnhancedView, didChangeAlpha alpha: CGFloat)
    
    /// 全屏切换
    /// - Parameter isFullscreen: 是否全屏
    func enhancedView(_ enhancedView: ARTVideoPlayerEnhancedView, didToggleFullscreen isFullscreen: Bool)
    
    /// 顶底栏按钮点击事件
    /// - Parameter sender: 按钮对象
    func enhancedView(_ enhancedView: ARTVideoPlayerEnhancedView, didTapButton sender: UIButton)
}
