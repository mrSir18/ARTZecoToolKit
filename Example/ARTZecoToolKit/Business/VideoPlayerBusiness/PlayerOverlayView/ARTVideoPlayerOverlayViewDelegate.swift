//
//  ARTVideoPlayerOverlayViewDelegate.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/12/6.
//

import ARTZecoToolKit

/// 协议方法
///
/// - NOTE: 可继承该协议方法
protocol ARTVideoPlayerOverlayViewDelegate: AnyObject {
    
    /// 自定义弹幕视图
    /// - Returns: 自定义弹幕视图
    func overlayViewDidCustomDanmakuView(for overlayView: ARTVideoPlayerOverlayView) -> ARTDanmakuView?
    
    /// 创建弹幕回调
    /// - Returns: 新创建的弹幕单元
    func overlayViewDidCreateDanmakuCell(for overlayView: ARTVideoPlayerOverlayView) -> ARTDanmakuCell
    
    /// 点击弹幕事件回调
    func overlayViewDidTapDanmakuCell(for overlayView: ARTVideoPlayerOverlayView, danmakuCell: ARTDanmakuCell)
    
    /// 弹幕即将显示回调
    func overlayViewWillDisplayDanmakuCell(for overlayView: ARTVideoPlayerOverlayView, danmakuCell: ARTDanmakuCell)
    
    /// 弹幕显示完成回调
    func overlayViewDidEndDisplayDanmakuCell(for overlayView: ARTVideoPlayerOverlayView, danmakuCell: ARTDanmakuCell)
    
    /// 所有弹幕显示完成回调
    func overlayViewDidEndDisplayAllDanmaku(for overlayView: ARTVideoPlayerOverlayView)
}
