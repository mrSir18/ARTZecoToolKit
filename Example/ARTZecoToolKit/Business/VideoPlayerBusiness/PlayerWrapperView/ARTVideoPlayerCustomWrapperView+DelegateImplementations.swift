//
//  ARTVideoPlayerCustomWrapperView+DelegateImplementations.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/10/29.
//

import ARTZecoToolKit

// MARK: - ARTVideoPlayerSystemControlsDelegate

extension ARTVideoPlayerCustomWrapperView: ARTVideoPlayerSystemControlsDelegate {
    
}


// MARK: - ARTVideoPlayerOverlayViewDelegate

extension ARTVideoPlayerCustomWrapperView: ARTVideoPlayerOverlayViewDelegate {
    
    func overlayViewDidCustomDanmakuView(for overlayView: ARTVideoPlayerOverlayView) -> ARTDanmakuView? { // 自定义弹幕视图
        /*
         1.自定义需要继承 ARTDanmakuView 类 实现 ARTDanmakuViewDelegate 协议
     
         let danmakuView = ARTDanmakuView(self)
         danmakuView.danmakuTrackHeight = ARTAdaptedValue(42.0) // 弹幕轨道高度
         danmakuView.danmakuAlpha = 0.8
         */
        
        return nil
    }
    
    func overlayViewDidCreateDanmakuCell(for overlayView: ARTVideoPlayerOverlayView) -> ARTDanmakuCell? { // 创建弹幕
        return ARTCustomDanmakuCell()
    }
    
    func overlayViewDidTapDanmakuCell(for overlayView: ARTVideoPlayerOverlayView, danmakuCell: ARTDanmakuCell) { // 点击弹幕
        guard let danmakuCell = danmakuCell as? ARTCustomDanmakuCell else { return }
        print("点击了弹幕：\(danmakuCell.danmakuLabel.text ?? "")")
    }
    
    func overlayViewWillDisplayDanmakuCell(for overlayView: ARTVideoPlayerOverlayView, danmakuCell: ARTDanmakuCell) { // 弹幕开始显示
//        print("弹幕开始显示")
    }
    
    func overlayViewDidEndDisplayDanmakuCell(for overlayView: ARTVideoPlayerOverlayView, danmakuCell: ARTDanmakuCell) { // 弹幕结束显示
//        print("弹幕结束显示")
    }
    
    func overlayViewDidEndDisplayAllDanmaku(for overlayView: ARTVideoPlayerOverlayView) { // 所有弹幕显示完
        print("所有弹幕显示完毕")
    }
}


// MARK: - ARTVideoPlayerControlsViewDelegate

extension ARTVideoPlayerCustomWrapperView: ARTVideoPlayerControlsViewDelegate {
    
    func customScreenOrientation(for controlsView: ARTVideoPlayerControlsView) -> ScreenOrientation { // 自定义播放模式
        return delegate?.customScreenOrientation?(for: self) ?? .window
    }
    
    func customTopBar(for controlsView: ARTVideoPlayerControlsView, screenOrientation: ScreenOrientation) -> ARTVideoPlayerTopbar? { // 自定义顶部工具栏视图
        return delegate?.customTopBar?(for: self, screenOrientation: screenOrientation)
    }
    
    func customBottomBar(for controlsView: ARTVideoPlayerControlsView, screenOrientation: ScreenOrientation) -> ARTVideoPlayerBottombar? { // 自定义底部工具
        return delegate?.customBottomBar?(for: self, screenOrientation: screenOrientation)
    }
    
    
// MARK: - 顶部工具栏 - 公共方法
    
    func controlsViewDidTapBack(for controlsView: ARTVideoPlayerControlsView) { // 点击返回按钮
        overlayView.stopDanmaku() // 停止弹幕
        fullscreenManager.dismiss { [weak self] in // 切换窗口模式顶底栏
            self?.updateScreenOrientation(for: .window)
        }
    }
    
    func controlsViewDidTapFavorite(for controlsView: ARTVideoPlayerControlsView, isFavorited: Bool) { // 点击收藏按钮
        delegate?.wrapperViewDidTapFavorite?(for: self, isFavorited: isFavorited)
    }
    
    func controlsViewDidTapShare(for controlsView: ARTVideoPlayerControlsView) { // 点击分享按钮
        if isLandscape { // 横屏模式
            let alertView = ARTAlertView()
            alertView.title("成长智库")
            alertView.desc("\n点击了横屏分享按钮\n")
            alertView.buttonTappedCallback = { buttonIndex in
                switch buttonIndex {
                case .first:
                    print("First mode selected")
                case .second:
                    print("Second mode selected")
                default:
                    break
                }
            }
            alertView.show()
        } else { // 竖屏模式
            portraitDanmakuView.showExtensionsView()
        }
    }
    
    
// MARK: - 底部工具栏 - 公共方法
    
    func controlsViewDidBeginTouch(for controlsView: ARTVideoPlayerControlsView, slider: ARTVideoPlayerSlider) { // 暂停播放 (开始拖动滑块)
        controlsView.didUpdatePlayPauseButtonStateInControls(isPlaying: true)
        controlsView.didUpdatePlayPauseStateInControls(playerState: .playing)
        isDraggingSlider = true
    }
    
    func controlsViewDidChangeValue(for controlsView: ARTVideoPlayerControlsView, slider: ARTVideoPlayerSlider) { // 快进/快退 (拖动滑块)
        updatePreviewImage(at: slider.value)
    }
    
    func controlsViewDidEndTouch(for controlsView: ARTVideoPlayerControlsView, slider: ARTVideoPlayerSlider) { // 恢复播放 (结束拖动滑块)
        systemControls.hideVideoPlayerDisplay()
        seekToTime(from: slider.value) { [weak self] in
            self?.isDraggingSlider = false
            self?.overlayView.resumeDanmaku() // 恢复弹幕
            self?.resumePlayer()
        }
    }
    
    func controlsViewDidTap(for controlsView: ARTVideoPlayerControlsView, slider: ARTVideoPlayerSlider) { // 指定播放时间 (点击滑块)
        controlsViewDidBeginTouch(for: controlsView, slider: slider)
        seekToTime(from: slider.value) { [weak self] in // 指定播放时间
            self?.controlsViewDidEndTouch(for: controlsView, slider: slider)
        }
    }
    
    func controlsViewDidTapPause(for controlsView: ARTVideoPlayerControlsView, isPlaying: Bool) { // 暂停播放 (点击暂停按钮)
        togglePlayerState()
    }
    
    func controlsViewDidTapDanmakuToggle(for controlsView: ARTVideoPlayerControlsView, isDanmakuEnabled: Bool) { // 弹幕开关 (点击弹幕开关按钮)
        if playerState != .ended { // 播放结束时不允许切换弹幕
            overlayView.shouldSendDanmaku(isDanmakuEnabled: isDanmakuEnabled) // 是否开始发送弹幕
            if isDanmakuEnabled && playerState == .paused { overlayView.pauseDanmaku() } // 暂停弹幕
        }
    }
    
    func controlsViewDidTapDanmakuSettings(for controlsView: ARTVideoPlayerControlsView) { // 弹幕设置 (点击弹幕设置按钮)
        controlsView.didAutoHideControls()
        danmakuView.showExtensionsView()
    }
    
    func controlsViewDidTapDanmakuSend(for controlsView: ARTVideoPlayerControlsView, text: String) { // 发送弹幕 (点击发送弹幕按钮)
        delegate?.wrapperViewDidTapDanmakuSend?(for: self, text: text)
        print("发送弹幕：\(text)")
    }
    
    
// MARK: - 窗口模式 - 底部工具栏
    
    func controlsViewDidTransitionToFullscreen(for controlsView: ARTVideoPlayerControlsView, orientation: ScreenOrientation) { // 点击全屏按钮
        fullscreenManager.presentFullscreenWithRotation { [weak self] in // 切换全屏模式顶底栏
            guard let self = self else { return }
            self.updateScreenOrientation(for: orientation)
            startDanmaku() // 开启弹幕
        }
    }
    
    
// MARK: - 横屏模式 - 底部工具栏
    
    func controlsViewDidTapNext(for controlsView: ARTVideoPlayerControlsView) { // 点击下一个按钮
        playNextVideo(with: URL(fileURLWithPath: Bundle.main.path(forResource: "video", ofType: "MP4")!))
    }
    
    func controlsViewDidTapSpeed(for controlsView: ARTVideoPlayerControlsView) { // 点击倍速按钮
        controlsView.didAutoHideControls()
        rateView.showExtensionsView()
    }
    
    func controlsViewDidTapCatalogue(for controlsView: ARTVideoPlayerControlsView) { // 点击目录按钮
        chaptersView.showExtensionsView()
        controlsView.didAutoHideControls()
    }
    
    
// MARK: - 竖屏模式 - 底部工具栏
    
    func controlsViewDidTapComment(for controlsView: ARTVideoPlayerControlsView) { // 点击评论按钮
        delegate?.wrapperViewDidTapComment?(for: self)
    }
    
    func controlsViewDidTapMore(for controlsView: ARTVideoPlayerControlsView) { // 点击更多按钮
        portraitDanmakuView.showExtensionsView()
    }
}


// MARK: - ARTVideoPlayerSlidingViewDelegate

extension ARTVideoPlayerCustomWrapperView: ARTVideoPlayerSlidingViewDelegate {
    
    func slidingViewDidTapRestoreButton(for danmakuEntity: ARTVideoPlayerGeneralDanmakuEntity) { // 恢复弹幕初始化
        danmakuEntity.sliderOptions.forEach { [weak self] option in
            self?.overlayView.updateDanmakuSliderValueChanged(for: option)
        }
    }
    
    func slidingViewDidSliderValueChanged(for sliderOption: ARTVideoPlayerGeneralDanmakuEntity.SliderOption) { // 滑块值改变事件回调
        overlayView.updateDanmakuSliderValueChanged(for: sliderOption)
    }
}

// MARK: - ARTVideoPlayerLoadingViewDelegate

extension ARTVideoPlayerCustomWrapperView: ARTVideoPlayerLoadingViewDelegate {
    
}
