//
//  ARTVideoPlayerControlsView+DelegateImplementations.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/10/29.
//

// MARK: - ARTVideoPlayerTopbarDelegate

/// 通用顶部工具栏代理
extension ARTVideoPlayerControlsView: ARTVideoPlayerTopbarDelegate {
    
    func topbarDidTapBack(for topbar: ARTVideoPlayerTopbar) { // 点击返回按钮
        removeToolBars()
        delegate?.controlsViewDidTapBack(for: self)
    }
    
    func topbarDidTapFavorite(for topbar: ARTVideoPlayerTopbar, isFavorited: Bool) { // 点击收藏按钮
        delegate?.controlsViewDidTapFavorite(for: self, isFavorited: isFavorited)
    }
    
    func topbarDidTapShare(for topbar: ARTVideoPlayerTopbar) { // 点击分享按钮
        delegate?.controlsViewDidTapShare(for: self)
    }
}


// MARK: - ARTVideoPlayerBottombarDelegate

/// 通用底部工具栏代理
extension ARTVideoPlayerControlsView: ARTVideoPlayerBottombarDelegate {
    
    func bottombarDidBeginTouch(for bottombar: ARTVideoPlayerBottombar, slider: ARTVideoPlayerSlider) { // 滑块开始触摸
        if isLandscape { // 横屏模式
            stopAutoHideTimer()
            toggleControls(visible: true)
        }
        delegate?.controlsViewDidBeginTouch(for: self, slider: slider)
    }
    
    func bottombarDidChangeValue(for bottombar: ARTVideoPlayerBottombar, slider: ARTVideoPlayerSlider) { // 滑块值改变
        delegate?.controlsViewDidChangeValue(for: self, slider: slider)
    }
    
    func bottombarDidEndTouch(for bottombar: ARTVideoPlayerBottombar, slider: ARTVideoPlayerSlider) { // 滑块结束触摸
        if isLandscape { resetAutoHideTimer() } // 横屏模式
        delegate?.controlsViewDidEndTouch(for: self, slider: slider)
    }
    
    func bottombarDidTap(for bottombar: ARTVideoPlayerBottombar, slider: ARTVideoPlayerSlider) { // 点击滑块
        if isLandscape { resetAutoHideTimer() } // 横屏模式
        delegate?.controlsViewDidTap(for: self, slider: slider)
    }
    
    func bottombarDidTapPause(for bottombar: ARTVideoPlayerBottombar, isPlaying: Bool) { // 点击暂停按钮
        delegate?.controlsViewDidTapPause(for: self, isPlaying: isPlaying)
    }
    
    func bottombarDidTapDanmakuToggle(for bottombar: ARTVideoPlayerBottombar, isDanmakuEnabled: Bool) { // 点击弹幕开关按钮
        saveDanmakuEnabled(isDanmakuEnabled: isDanmakuEnabled) // 本地存储弹幕状态
        delegate?.controlsViewDidTapDanmakuToggle(for: self, isDanmakuEnabled: isDanmakuEnabled)
    }
    
    func bottombarDidTapDanmakuSettings(for bottombar: ARTVideoPlayerBottombar) { // 点击弹幕设置按钮
        delegate?.controlsViewDidTapDanmakuSettings(for: self)
    }
    
    func bottombarDidTapDanmakuSend(for bottombar: ARTVideoPlayerBottombar, text: String) { // 点击发送弹幕按钮
        delegate?.controlsViewDidTapDanmakuSend(for: self, text: text)
    }
}

/// 窗口模式 - 底部工具栏代理
extension ARTVideoPlayerControlsView: ARTVideoPlayerWindowBottombarDelegate {
    
    func bottombarDidTapFullscreen(for bottombar: ARTVideoPlayerWindowBottombar) { // 点击全屏按钮
        removeToolBars()
        delegate?.controlsViewDidTransitionToFullscreen(for: self, orientation: autoVideoScreenOrientation())
    }
}

/// 横屏模式 - 底部工具栏代理
extension ARTVideoPlayerControlsView: ARTVideoPlayerLandscapeFullscreenBottombarDelegate {
    
    func bottombarDidTapFavorite(for bottombar: ARTVideoPlayerPortraitFullscreenBottombar, isFavorited: Bool) { // 点击收藏按钮
        delegate?.controlsViewDidTapFavorite(for: self, isFavorited: isFavorited)
    }
    
    func bottombarDidTapComment(for bottombar: ARTVideoPlayerPortraitFullscreenBottombar) { // 点击评论按钮
        delegate?.controlsViewDidTapComment(for: self)
    }
    
    func bottombarDidTapShare(for bottombar: ARTVideoPlayerPortraitFullscreenBottombar) { // 点击分享按钮
        delegate?.controlsViewDidTapShare(for: self)
    }
    
    func bottombarDidTapMore(for bottombar: ARTVideoPlayerPortraitFullscreenBottombar) { // 点击更多按钮
        delegate?.controlsViewDidTapMore(for: self)
    }
}

/// 竖屏模式 - 底部工具栏代理
extension ARTVideoPlayerControlsView: ARTVideoPlayerPortraitFullscreenBottombarDelegate {
    
    func bottombarDidTapNext(for bottombar: ARTVideoPlayerLandscapeFullscreenBottombar) { // 点击下一个按钮
        delegate?.controlsViewDidTapNext(for: self)
    }
    
    func bottombarDidTapSpeed(for bottombar: ARTVideoPlayerLandscapeFullscreenBottombar) { // 点击倍速按钮
        delegate?.controlsViewDidTapSpeed(for: self)
    }
    
    func bottombarDidTapCatalogue(for bottombar: ARTVideoPlayerLandscapeFullscreenBottombar) { // 点击目录按钮
        delegate?.controlsViewDidTapCatalogue(for: self)
    }
}
