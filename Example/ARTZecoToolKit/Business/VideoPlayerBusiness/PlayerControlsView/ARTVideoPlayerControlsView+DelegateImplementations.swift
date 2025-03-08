//
//  ARTVideoPlayerControlsView+DelegateImplementations.swift
//  ARTZeco
//
//  Created by mrSir18 on 2024/10/29.
//

import ARTZecoToolKit

// MARK: - ARTVideoPlayerTopbarDelegate

extension ARTVideoPlayerControlsView: ARTVideoPlayerTopbarDelegate {

    func topbar(_ topbar: ARTVideoPlayerTopbar, didTapButton sender: UIButton) { // 顶部导航栏按钮点击事件
        delegate?.controlsView(self, didTapTopbarButton: sender)
    }
}


// MARK: - ARTVideoPlayerBottombarDelegate

extension ARTVideoPlayerControlsView: ARTVideoPlayerBottombarDelegate {
    
    func bottombarDidRequestPlayerState(for bottombar: ARTVideoPlayerBottombar) -> PlayerState { // 请求播放器的播放状态
        return delegate?.controlsViewDidRequestPlayerState(for: self) ?? .buffering
    }
    
    func bottombar(_ bottombar: ARTVideoPlayerBottombar, didPerformSliderAction slider: ARTVideoPlayerSlider, action: SliderAction) { // 滑块操作
        delegate?.controlsView(self, didPerformSliderAction: slider, action: action)
    }
    
    func bottombar(_ bottombar: ARTVideoPlayerBottombar, didTapButton sender: UIButton) { // 底部工具栏按钮点击事件
        delegate?.controlsView(self, didTapBottombarButton: sender)
    }
}
