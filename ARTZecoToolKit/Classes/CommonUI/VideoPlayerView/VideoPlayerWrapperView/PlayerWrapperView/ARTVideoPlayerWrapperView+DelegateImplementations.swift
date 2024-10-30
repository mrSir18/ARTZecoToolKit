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
    
}


// MARK: - ARTVideoPlayerControlsViewDelegate

extension ARTVideoPlayerWrapperView: ARTVideoPlayerControlsViewDelegate {
    
    /*
    public func customScreenOrientation(for playerControlsView: ARTVideoPlayerControlsView) -> ScreenOrientation { // 自定义播放模式
        
    }
    
    public func customTopBar(for playerControlsView: ARTVideoPlayerControlsView, screenOrientation: ScreenOrientation) -> ARTVideoPlayerTopbar? { // 自定义顶部工具栏视图
        
    }
    
    public func customBottomBar(for playerControlsView: ARTVideoPlayerControlsView, screenOrientation: ScreenOrientation) -> ARTVideoPlayerBottombar? { // 自定义底部工具
        
    }
    */
    
    
// MARK: - 顶部工具栏 - 公共方法
    
    public func controlsViewDidTapBack(for playerControlsView: ARTVideoPlayerControlsView) { // 点击返回按钮
        fullscreenManager.dismiss { [weak self] in // 切换窗口模式顶底栏
            self?.updateScreenMode(for: .window)
        }
    }
    
    public func controlsViewDidTapFavorite(for playerControlsView: ARTVideoPlayerControlsView, isFavorited: Bool) { // 点击收藏按钮
        
    }
    
    public func controlsViewDidTapShare(for playerControlsView: ARTVideoPlayerControlsView) { // 点击分享按钮
        
    }
    
    
// MARK: - 底部工具栏 - 公共方法
    
    public func controlsViewDidBeginTouch(for controlsView: ARTVideoPlayerControlsView, slider: ARTVideoPlayerSlider) { // 暂停播放 (开始拖动滑块)
        playControlsView.updatePlayPauseButtonInControls(isPlaying: true)
        playControlsView.updatePlayerStateInControls(playerState: .playing)
        isDraggingSlider = true
    }
    
    public func controlsViewDidChangeValue(for controlsView: ARTVideoPlayerControlsView, slider: ARTVideoPlayerSlider) { // 快进/快退 (拖动滑块)
        
        updatePreviewImageForSliderValueChange(slider)
    }
    
    public func controlsViewDidEndTouch(for controlsView: ARTVideoPlayerControlsView, slider: ARTVideoPlayerSlider) { // 恢复播放 (结束拖动滑块)
        systemControlsView.hideVideoPlayerDisplay()
        seekToSliderValue(slider) { [weak self] in
            self?.isDraggingSlider = false
            self?.player.play()
        }
    }
    
    public func controlsViewDidTap(for controlsView: ARTVideoPlayerControlsView, slider: ARTVideoPlayerSlider) { // 指定播放时间 (点击滑块)
        controlsViewDidBeginTouch(for: controlsView, slider: slider)
        seekToSliderValue(slider) { [weak self] in // 指定播放时间
            self?.controlsViewDidEndTouch(for: controlsView, slider: slider)
        }
    }
    
    public func controlsViewDidTapPause(for controlsView: ARTVideoPlayerControlsView) { // 暂停播放 (点击暂停按钮)

    }
    
    public func controlsViewDidTapDanmakuToggle(for controlsView: ARTVideoPlayerControlsView) { // 弹幕开关 (点击弹幕开关按钮)
        
    }
    
    public func controlsViewDidTapDanmakuSettings(for controlsView: ARTVideoPlayerControlsView) { // 弹幕设置 (点击弹幕设置按钮)
        
    }
    
    public func controlsViewDidTapDanmakuSend(for controlsView: ARTVideoPlayerControlsView, text: String) { // 发送弹幕 (点击发送弹幕按钮)
        
    }
    
    
// MARK: - 窗口模式 - 底部工具栏
    
    public func controlsViewDidTransitionToFullscreen(for playerControlsView: ARTVideoPlayerControlsView, orientation: ScreenOrientation) { // 点击全屏按钮
        fullscreenManager.presentFullscreenWithRotation { [weak self] in // 切换全屏模式顶底栏
            self?.updateScreenMode(for: orientation)
        }
    }
    
    
// MARK: - 横屏模式 - 底部工具栏
    
    public func controlsViewDidTapNext(for playerControlsView: ARTVideoPlayerControlsView) { // 点击下一个按钮
        
    }
    
    public func controlsViewDidTapSpeed(for playerControlsView: ARTVideoPlayerControlsView) { // 点击倍速按钮
        
    }
    
    public func controlsViewDidTapCollection(for playerControlsView: ARTVideoPlayerControlsView) { // 点击收藏按钮
        
    }
    
    
// MARK: - 竖屏模式 - 底部工具栏
    
    public func controlsViewDidTapComment(for playerControlsView: ARTVideoPlayerControlsView) { // 点击评论按钮
        
    }
    
    public func controlsViewDidTapMore(for playerControlsView: ARTVideoPlayerControlsView) { // 点击更多按钮
        
    }
}
