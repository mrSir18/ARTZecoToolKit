//
//  ARTVideoPlayerEnhancedWrapperViewDelegate.swift
//  ARTZeco
//
//  Created by mrSir18 on 2024/10/29.
//

protocol ARTVideoPlayerEnhancedWrapperViewDelegate: AnyObject {

    /// 顶部导航栏透明度发生变化
    /// - Parameter alpha: 透明度
    func wrapperView(_ wrapperView: ARTVideoPlayerEnhancedWrapperView, didChangeAlpha alpha: CGFloat)
    
    /// 全屏切换
    /// - Parameter isFullscreen: 是否全屏
    func wrapperView(_ wrapperView: ARTVideoPlayerEnhancedWrapperView, didToggleFullscreen isFullscreen: Bool)
    
    /// 顶底栏按钮点击事件
    /// - Parameter sender: 按钮对象
    func wrapperView(_ wrapperView: ARTVideoPlayerEnhancedWrapperView, didTapButton sender: UIButton)
}
