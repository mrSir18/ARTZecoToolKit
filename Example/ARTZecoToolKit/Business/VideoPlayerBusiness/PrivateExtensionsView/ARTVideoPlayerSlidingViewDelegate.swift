//
//  ARTVideoPlayerSlidingViewDelegate.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/11/7.
//

/// 协议方法
///
/// - NOTE: 可继承该协议方法
public protocol ARTVideoPlayerSlidingViewDelegate: AnyObject {
    
    // MARK: 弹幕设置 - 公共方法
    
    /// 恢复按钮点击事件回调
    /// - Parameters: danmakuEntity: 弹幕实体
    func slidingViewDidTapRestoreButton(for danmakuEntity: ARTVideoPlayerGeneralDanmakuEntity)
    
    /// 滑块值改变事件回调
    /// - Parameters: sliderOption: 滑块选项
    func slidingViewDidSliderValueChanged(for sliderOption: ARTVideoPlayerGeneralDanmakuEntity.SliderOption)
}
