//
//  ARTVideoPlayerControlsViewDelegate.swift
//  ARTZeco
//
//  Created by mrSir18 on 2024/10/29.
//

import ARTZecoToolKit

protocol ARTVideoPlayerControlsViewDelegate: AnyObject {
    
    // MARK: - 顶部工具栏

    /// 顶部导航栏透明度发生变化
    /// - Parameter alpha: 透明度
    func controlsView(_ controlsView: ARTVideoPlayerControlsView, didChangeAlpha alpha: CGFloat)
    
    /// 顶部导航栏按钮点击事件
    /// - Parameter sender: 按钮对象
    func controlsView(_ controlsView: ARTVideoPlayerControlsView, didTapTopbarButton sender: UIButton)
    
    
// MARK: - 底部工具栏
    
    /// 请求播放器的播放状态
    /// - Returns: 播放状态
    func controlsViewDidRequestPlayerState(for controlsView: ARTVideoPlayerControlsView) -> PlayerState
    
    /// 滑块操作
    /// - Parameters:
    ///   - slider: 被操作的滑块
    ///   - action: 操作类型
    func controlsView(_ controlsView: ARTVideoPlayerControlsView, didPerformSliderAction slider: ARTVideoPlayerSlider, action: SliderAction)
    
    /// 底部工具栏按钮点击事件
    /// - Parameter sender: 按钮对象
    func controlsView(_ controlsView: ARTVideoPlayerControlsView, didTapBottombarButton sender: UIButton)
}
