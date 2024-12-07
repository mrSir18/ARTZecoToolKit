//
//  ARTVideoPlayerWrapperView+DelegateImplementations.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/10/29.
//

// MARK: - ARTVideoPlayerSystemControlsDelegate

extension ARTVideoPlayerWrapperView: ARTVideoPlayerSystemControlsDelegate {
    
}


// MARK: - ARTVideoPlayerOverlayViewDelegate

extension ARTVideoPlayerWrapperView: ARTVideoPlayerOverlayViewDelegate {
    
    public func overlayViewDidCreateDanmakuCell(for overlayView: ARTVideoPlayerOverlayView) -> ARTDanmakuCell { // 创建弹幕
        return delegate?.wrapperViewDidCreateDanmakuCell?(for: self) ?? ARTDanmakuCell()
    }
    
    public func overlayViewDidTapDanmakuCell(for overlayView: ARTVideoPlayerOverlayView, danmakuCell: ARTDanmakuCell) { // 点击弹幕
        delegate?.wrapperViewDidTapDanmakuCell?(for: self, danmakuCell: danmakuCell)
    }
    
    public func overlayViewWillDisplayDanmakuCell(for overlayView: ARTVideoPlayerOverlayView, danmakuCell: ARTDanmakuCell) { // 弹幕开始显示
        delegate?.wrapperViewWillDisplayDanmakuCell?(for: self, danmakuCell: danmakuCell)
    }
    
    public func overlayViewDidEndDisplayDanmakuCell(for overlayView: ARTVideoPlayerOverlayView, danmakuCell: ARTDanmakuCell) { // 弹幕结束显示
        delegate?.wrapperViewDidEndDisplayDanmakuCell?(for: self, danmakuCell: danmakuCell)
    }
    
    public func overlayViewDidEndDisplayAllDanmaku(for overlayView: ARTVideoPlayerOverlayView) { // 所有弹幕显示完
        delegate?.wrapperViewDidEndDisplayAllDanmaku?(for: self)
    }
}


// MARK: - ARTVideoPlayerControlsViewDelegate

extension ARTVideoPlayerWrapperView: ARTVideoPlayerControlsViewDelegate {
    
    public func customScreenOrientation(for controlsView: ARTVideoPlayerControlsView) -> ScreenOrientation { // 自定义播放模式
        return delegate?.customScreenOrientation?(for: self) ?? .window
    }
    
    public func customTopBar(for controlsView: ARTVideoPlayerControlsView, screenOrientation: ScreenOrientation) -> ARTVideoPlayerTopbar? { // 自定义顶部工具栏视图
        return delegate?.customTopBar?(for: self, screenOrientation: screenOrientation)
    }
    
    public func customBottomBar(for controlsView: ARTVideoPlayerControlsView, screenOrientation: ScreenOrientation) -> ARTVideoPlayerBottombar? { // 自定义底部工具
        return delegate?.customBottomBar?(for: self, screenOrientation: screenOrientation)
    }
    
    
// MARK: - 顶部工具栏 - 公共方法
    
    public func controlsViewDidTapBack(for controlsView: ARTVideoPlayerControlsView) { // 点击返回按钮
        playerOverlayView.stopDanmaku() // 停止弹幕
        delegate?.wrapperViewDidTapBack?(for: self)
        fullscreenManager.dismiss { [weak self] in // 切换窗口模式顶底栏
            self?.updateScreenMode(for: .window)
        }
    }
    
    public func controlsViewDidTapFavorite(for controlsView: ARTVideoPlayerControlsView, isFavorited: Bool) { // 点击收藏按钮
        delegate?.wrapperViewDidTapFavorite?(for: self, isFavorited: isFavorited)
    }
    
    public func controlsViewDidTapShare(for controlsView: ARTVideoPlayerControlsView) { // 点击分享按钮
//        delegate?.wrapperViewDidTapShare?(for: self)
        portraitDanmakuView.showExtensionsView()
    }
    
    
// MARK: - 底部工具栏 - 公共方法
    
    public func controlsViewDidBeginTouch(for controlsView: ARTVideoPlayerControlsView, slider: ARTVideoPlayerSlider) { // 暂停播放 (开始拖动滑块)
        playControlsView.updatePlayPauseButtonInControls(isPlaying: true)
        playControlsView.updatePlayerStateInControls(playerState: .playing)
        isDraggingSlider = true
        delegate?.wrapperViewDidBeginTouch?(for: self, slider: slider)
    }
    
    public func controlsViewDidChangeValue(for controlsView: ARTVideoPlayerControlsView, slider: ARTVideoPlayerSlider) { // 快进/快退 (拖动滑块)
        updatePreviewImageForSliderValueChange(slider)
        delegate?.wrapperViewDidChangeValue?(for: self, slider: slider)
    }
    
    public func controlsViewDidEndTouch(for controlsView: ARTVideoPlayerControlsView, slider: ARTVideoPlayerSlider) { // 恢复播放 (结束拖动滑块)
        delegate?.wrapperViewDidEndTouch?(for: self, slider: slider)
        systemControlsView.hideVideoPlayerDisplay()
        seekToSliderValue(slider) { [weak self] in
            self?.isDraggingSlider = false
            self?.player.play()
        }
    }
    
    public func controlsViewDidTap(for controlsView: ARTVideoPlayerControlsView, slider: ARTVideoPlayerSlider) { // 指定播放时间 (点击滑块)
        delegate?.wrapperViewDidTap?(for: self, slider: slider)
        controlsViewDidBeginTouch(for: controlsView, slider: slider)
        seekToSliderValue(slider) { [weak self] in // 指定播放时间
            self?.controlsViewDidEndTouch(for: controlsView, slider: slider)
        }
    }
    
    public func controlsViewDidTapPause(for controlsView: ARTVideoPlayerControlsView, isPlaying: Bool) { // 暂停播放 (点击暂停按钮)
        handlePlayerState()
        delegate?.wrapperViewDidTapPause?(for: self, isPlaying: isPlaying)
    }
    
    public func controlsViewDidTapDanmakuToggle(for controlsView: ARTVideoPlayerControlsView) { // 弹幕开关 (点击弹幕开关按钮)
        delegate?.wrapperViewDidTapDanmakuToggle?(for: self)
    }
    
    public func controlsViewDidTapDanmakuSettings(for controlsView: ARTVideoPlayerControlsView) { // 弹幕设置 (点击弹幕设置按钮)
//        delegate?.wrapperViewDidTapDanmakuSettings?(for: self)
        playControlsView.autoHideControls()
        danmakuView.showExtensionsView()
    }
    
    public func controlsViewDidTapDanmakuSend(for controlsView: ARTVideoPlayerControlsView, text: String) { // 发送弹幕 (点击发送弹幕按钮)
        delegate?.wrapperViewDidTapDanmakuSend?(for: self, text: text)
    }
    
    
// MARK: - 窗口模式 - 底部工具栏
    
    public func controlsViewDidTransitionToFullscreen(for controlsView: ARTVideoPlayerControlsView, orientation: ScreenOrientation) { // 点击全屏按钮
        delegate?.wrapperViewDidTransitionToFullscreen?(for: self, orientation: orientation)
        fullscreenManager.presentFullscreenWithRotation { [weak self] in // 切换全屏模式顶底栏
            self?.updateScreenMode(for: orientation)
        }
    }
    
    
// MARK: - 横屏模式 - 底部工具栏
    
    public func controlsViewDidTapNext(for controlsView: ARTVideoPlayerControlsView) { // 点击下一个按钮
        delegate?.wrapperViewDidTapNext?(for: self)
    }
    
    public func controlsViewDidTapSpeed(for controlsView: ARTVideoPlayerControlsView) { // 点击倍速按钮
//        delegate?.wrapperViewDidTapSpeed?(for: self)
        playControlsView.autoHideControls()
        rateView.showExtensionsView()
    }
    
    public func controlsViewDidTapCollection(for controlsView: ARTVideoPlayerControlsView) { // 点击目录按钮
//        delegate?.wrapperViewDidTapCollection?(for: self)
        playControlsView.autoHideControls()
        chaptersView.showExtensionsView()
    }
    
    
// MARK: - 竖屏模式 - 底部工具栏
    
    public func controlsViewDidTapComment(for controlsView: ARTVideoPlayerControlsView) { // 点击评论按钮
        delegate?.wrapperViewDidTapComment?(for: self)
    }
    
    public func controlsViewDidTapMore(for controlsView: ARTVideoPlayerControlsView) { // 点击更多按钮
        portraitDanmakuView.showExtensionsView()
    }
}

// MARK: - ARTVideoPlayerSlidingViewDelegate

extension ARTVideoPlayerWrapperView: ARTVideoPlayerSlidingViewDelegate {

}
