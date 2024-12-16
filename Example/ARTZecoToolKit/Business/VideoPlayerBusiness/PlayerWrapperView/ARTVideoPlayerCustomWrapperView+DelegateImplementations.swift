//
//  ARTVideoPlayerCustomWrapperView+DelegateImplementations.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/10/29.
//

import ARTZecoToolKit

// MARK: - ARTVideoPlayerControlsViewDelegate

extension ARTVideoPlayerCustomWrapperView: ARTVideoPlayerControlsViewDelegate {
    
// MARK: - 窗口模式 - 底部工具栏
    
    public func controlsViewDidTransitionToFullscreen(for controlsView: ARTVideoPlayerControlsView, orientation: ScreenOrientation) { // 点击全屏按钮
        print("点击全屏按钮")
        fullscreenManager.presentFullscreenWithRotation { [weak self] in // 切换全屏模式顶底栏
            guard let self = self else { return }
//            self.updateScreenMode(for: orientation)
//            self.delegate?.wrapperViewDidTransitionToFullscreen?(for: self, orientation: orientation)
        }
    }
}
