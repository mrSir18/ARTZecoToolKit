//
//  ARTVideoPlayerControlsView+DelegateImplementations.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/10/29.
//

// MARK: - ARTVideoPlayerTopbarDelegate

/// 通用顶部工具栏代理
extension ARTVideoPlayerControlsView: ARTVideoPlayerTopbarDelegate {
    
    public func topbarDidTapBack(for topbar: ARTVideoPlayerTopbar) { // 点击返回按钮
        removeToolBars()
        delegate?.controlsViewDidTapBack?(for: self)
    }
    
    public func topbarDidTapFavorite(for topbar: ARTVideoPlayerTopbar, isFavorited: Bool) { // 点击收藏按钮
        delegate?.controlsViewDidTapFavorite?(for: self, isFavorited: isFavorited)
    }
    
    public func topbarDidTapShare(for topbar: ARTVideoPlayerTopbar) { // 点击分享按钮
        delegate?.controlsViewDidTapShare?(for: self)
    }
}


// MARK: - ARTVideoPlayerBottombarDelegate

/// 通用底部工具栏代理
extension ARTVideoPlayerControlsView: ARTVideoPlayerBottombarDelegate {
    
    public func bottombarDidBeginTouch(for bottombar: ARTVideoPlayerBottombar, slider: ARTVideoPlayerSlider) { // 滑块开始触摸
        if isLandscape { // 横屏模式
            stopAutoHideTimer()
            toggleControls(visible: true)
        }
        delegate?.controlsViewDidBeginTouch?(for: self, slider: slider)
    }
    
    public func bottombarDidChangeValue(for bottombar: ARTVideoPlayerBottombar, slider: ARTVideoPlayerSlider) { // 滑块值改变
        delegate?.controlsViewDidChangeValue?(for: self, slider: slider)
    }
    
    public func bottombarDidEndTouch(for bottombar: ARTVideoPlayerBottombar, slider: ARTVideoPlayerSlider) { // 滑块结束触摸
        if isLandscape { resetAutoHideTimer() } // 横屏模式
        delegate?.controlsViewDidEndTouch?(for: self, slider: slider)
    }
    
    public func bottombarDidTap(for bottombar: ARTVideoPlayerBottombar, slider: ARTVideoPlayerSlider) { // 点击滑块
        if isLandscape { resetAutoHideTimer() } // 横屏模式
        delegate?.controlsViewDidTap?(for: self, slider: slider)
    }
    
    public func bottombarDidTapPause(for bottombar: ARTVideoPlayerBottombar) { // 点击暂停按钮
        delegate?.controlsViewDidTapPause?(for: self)
    }
    
    public func bottombarDidTapDanmakuToggle(for bottombar: ARTVideoPlayerBottombar) { // 点击弹幕开关按钮
        delegate?.controlsViewDidTapDanmakuToggle?(for: self)
    }
    
    public func bottombarDidTapDanmakuSettings(for bottombar: ARTVideoPlayerBottombar) { // 点击弹幕设置按钮
        delegate?.controlsViewDidTapDanmakuSettings?(for: self)
    }
    
    public func bottombarDidTapDanmakuSend(for bottombar: ARTVideoPlayerBottombar, text: String) { // 点击发送弹幕按钮
        delegate?.controlsViewDidTapDanmakuSend?(for: self, text: text)
    }
}

/// 窗口模式 - 底部工具栏代理
extension ARTVideoPlayerControlsView: ARTVideoPlayerWindowBottombarDelegate {
    
    public func bottombarDidTapFullscreen(for bottombar: ARTVideoPlayerWindowBottombar) { // 点击全屏按钮
        removeToolBars()
        delegate?.controlsViewDidTransitionToFullscreen?(for: self, orientation: autoVideoScreenOrientation())
    }
}

/// 横屏模式 - 底部工具栏代理
extension ARTVideoPlayerControlsView: ARTVideoPlayerLandscapeFullscreenBottombarDelegate {
    
    public func bottombarDidTapFavorite(for bottombar: ARTVideoPlayerPortraitFullscreenBottombar, isFavorited: Bool) { // 点击收藏按钮
        delegate?.controlsViewDidTapFavorite?(for: self, isFavorited: isFavorited)
    }
    
    public func bottombarDidTapComment(for bottombar: ARTVideoPlayerPortraitFullscreenBottombar) { // 点击评论按钮
        delegate?.controlsViewDidTapComment?(for: self)
    }
    
    public func bottombarDidTapShare(for bottombar: ARTVideoPlayerPortraitFullscreenBottombar) { // 点击分享按钮
        delegate?.controlsViewDidTapShare?(for: self)
    }
    
    public func bottombarDidTapMore(for bottombar: ARTVideoPlayerPortraitFullscreenBottombar) { // 点击更多按钮
        delegate?.controlsViewDidTapMore?(for: self)
    }
}

/// 竖屏模式 - 底部工具栏代理
extension ARTVideoPlayerControlsView: ARTVideoPlayerPortraitFullscreenBottombarDelegate {
    
    public func bottombarDidTapNext(for bottombar: ARTVideoPlayerLandscapeFullscreenBottombar) { // 点击下一个按钮
        delegate?.controlsViewDidTapNext?(for: self)
    }
    
    public func bottombarDidTapSpeed(for bottombar: ARTVideoPlayerLandscapeFullscreenBottombar) { // 点击倍速按钮
        delegate?.controlsViewDidTapSpeed?(for: self)
    }
    
    public func bottombarDidTapCollection(for bottombar: ARTVideoPlayerLandscapeFullscreenBottombar) { // 点击目录按钮
        delegate?.controlsViewDidTapCollection?(for: self)
    }
}
