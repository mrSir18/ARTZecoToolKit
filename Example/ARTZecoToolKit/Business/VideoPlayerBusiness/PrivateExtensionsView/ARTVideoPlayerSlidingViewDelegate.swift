//
//  ARTVideoPlayerSlidingViewDelegate.swift
//  ARTZeco
//
//  Created by mrSir18 on 2024/11/7.
//

protocol ARTVideoPlayerSlidingViewDelegate: AnyObject {
    
    // MARK: 弹幕设置 - 公共方法
    
    /// 恢复按钮点击事件回调
    /// - Parameters: danmakuEntity: 弹幕实体
    func slidingViewDidTapRestoreButton(for danmakuEntity: ARTVideoPlayerGeneralDanmakuEntity)
    
    /// 滑块值改变事件回调
    /// - Parameters: sliderOption: 滑块选项
    func slidingViewDidSliderValueChanged(for sliderOption: ARTVideoPlayerGeneralDanmakuEntity.SliderOption)
}
