//
//  ARTVideoPlayerEnhancedWrapperView+DelegateImplementations.swift
//  ARTZeco
//
//  Created by mrSir18 on 2024/10/29.
//

import ARTZecoToolKit

// MARK: - ARTVideoPlayerOverlayViewDelegate

extension ARTVideoPlayerEnhancedWrapperView: ARTVideoPlayerOverlayViewDelegate {

    func overlayViewDidTapDanmakuCell(for overlayView: ARTVideoPlayerOverlayView, danmakuCell: ARTDanmakuCell) { // 点击弹幕
        guard let danmakuCell = danmakuCell as? ARTEnhancedDanmakuCell else { return }
        print("点击了弹幕：\(danmakuCell.danmakuLabel.text ?? "")")
    }
}


// MARK: - ARTVideoPlayerControlsViewDelegate

extension ARTVideoPlayerEnhancedWrapperView: ARTVideoPlayerControlsViewDelegate {
    
    // MARK: - 顶部工具栏

    func controlsView(_ controlsView: ARTVideoPlayerControlsView, didChangeAlpha alpha: CGFloat) { // 顶部导航栏透明度发生变化
        delegate?.wrapperView(self, didChangeAlpha: alpha)
    }
    
    func controlsView(_ controlsView: ARTVideoPlayerControlsView, didTapTopbarButton sender: UIButton) { // 顶部导航栏按钮点击事件
        guard let buttonType = ARTVideoPlayerControls.ButtonType(rawValue: sender.tag) else { return }

        switch buttonType {
        case .back: // 返回按钮
            handleBackButtonTap()
            
        case .share: // 分享按钮
            handleTopbarShareButtonTap()
            
        case .favorite: // 收藏按钮
            handleTopbarFavoriteButtonTap(sender)
            
        default:
            break
        }
    }
    
    // MARK: Topbar Buttons Actions
    
    private func handleBackButtonTap() {
        controlsView.didRemoveToolBarsInControls()
        overlayView.stopDanmaku() // 停止弹幕
        fullscreenManager.dismiss { [weak self] in // 退出全屏模式
            guard let self = self else { return }
            self.delegate?.wrapperView(self, didToggleFullscreen: false)
            self.updateScreenOrientation(for: .window)
        }
    }

    private func handleTopbarShareButtonTap() {
        if isLandscape { // 横屏模式
            print("分享")
        } else { // 竖屏模式
            portraitDanmakuView.showExtensionsView()
        }
    }

    private func handleTopbarFavoriteButtonTap(_ sender: UIButton) {
        delegate?.wrapperView(self, didTapButton: sender)
    }

    
// MARK: - 底部工具栏
    
    func controlsViewDidRequestPlayerState(for controlsView: ARTVideoPlayerControlsView) -> PlayerState { // 请求播放器的播放状态
        return playerState
    }
    
    func controlsView(_ controlsView: ARTVideoPlayerControlsView, didPerformSliderAction slider: ARTVideoPlayerSlider, action: SliderAction) { // 滑块操作
    
        func handleLandscapeMode(isBeginTouch: Bool) { // 横屏模式的处理
            if isLandscape {
                if isBeginTouch {
                    controlsView.didStopAutoHideTimer()
                    controlsView.didToggleControlsInControls(visible: true)
                } else {
                    controlsView.didResetAutoHideTimerInControls()
                }
            }
        }
        
        switch action {
        case .beginTouch: // 暂停播放（开始拖动滑块）
            handleLandscapeMode(isBeginTouch: true)
            controlsView.didUpdatePlayPauseButtonStateInControls(isPlaying: true)
            controlsView.didUpdatePlayPauseStateInControls(playerState: .playing)
            isDraggingSlider = true
            
        case .changeValue:  // 快进/快退 (拖动滑块)
            updatePreviewImage(at: slider.value)
            
        case .endTouch: // 恢复播放 (结束拖动滑块)
            handleLandscapeMode(isBeginTouch: false)
            systemControls.hideVideoPlayerDisplay()
            seekToTime(from: slider.value) { [weak self] in
                self?.isDraggingSlider = false
                self?.overlayView.resumeDanmaku() // 恢复弹幕
                self?.resumePlayer()
            }
            
        case .tap: // 暂停/播放 (点击滑块)
            handleLandscapeMode(isBeginTouch: false)
            self.controlsView(controlsView, didPerformSliderAction: slider, action: .beginTouch)
            seekToTime(from: slider.value) { [weak self] in // 指定播放时间
                self?.controlsView(controlsView, didPerformSliderAction: slider, action: .endTouch)
            }
        }
    }

    func controlsView(_ controlsView: ARTVideoPlayerControlsView, didTapBottombarButton sender: UIButton) { // 底部工具栏按钮点击事件
        guard let buttonType = ARTVideoPlayerControls.ButtonType(rawValue: sender.tag) else { return }
        
        switch buttonType {
        case .fullscreen: // 全屏按钮
            handleFullscreenButtonTap()
            
        case .pause: // 暂停/播放按钮
            handlePauseButtonTap()
            
        case .next: // 下一集按钮
            handleNextButtonTap()
            
        case .danmakuToggle: // 弹幕开关按钮
            handleDanmakuToggleButtonTap(sender)
            
        case .danmakuSettings: // 弹幕设置按钮
            handleDanmakuSettingsButtonTap()
            
        case .danmakuSend: // 发送弹幕按钮
            handleDanmakuSendButtonTap(sender)
            
        case .speed: // 倍速按钮
            handleSpeedButtonTap()
            
        case .catalogue: // 目录按钮
            handleCatalogueButtonTap()
            
        case .favorite: // 收藏按钮
            handleFavoriteButtonTap(sender)
            
        case .comment: // 评论按钮
            handleCommentButtonTap(sender)
            
        case .share: // 分享按钮
            handleBottombarShareButtonTap()
            
        case .more: // 更多按钮
            handleMoreButtonTap()
            
        default:
            break
        }
    }
    
    // MARK: Bottombar Buttons Actions
    
    func handleFullscreenButtonTap() {
        controlsView.didRemoveToolBarsInControls()
        delegate?.wrapperView(self, didToggleFullscreen: true)
        let orientation = controlsView.didAutoVideoScreenOrientation()
        fullscreenManager.presentFullscreenWithRotation { [weak self] in // 切换全屏模式
            guard let self = self else { return }
            self.updateScreenOrientation(for: orientation)
            self.startDanmaku() // 开启弹幕
        }
    }

    func handlePauseButtonTap() {
        togglePlayerState()
    }

    func handleNextButtonTap() {
        playNextVideo(with: URL(fileURLWithPath: Bundle.main.path(forResource: "video", ofType: "MP4")!))
    }

    func handleDanmakuToggleButtonTap(_ sender: UIButton) {
        let isDanmakuEnabled = sender.isSelected
        controlsView.didSaveDanmakuStateInControls(isDanmakuEnabled) // 本地存储弹幕状态
        if playerState != .ended { // 播放结束时不允许切换弹幕
            overlayView.shouldSendDanmaku(isDanmakuEnabled) // 是否开始发送弹幕
            if isDanmakuEnabled && playerState == .paused { overlayView.pauseDanmaku() } // 暂停弹幕
        }
    }

    func handleDanmakuSettingsButtonTap() {
        controlsView.didAutoHideControls()
        danmakuView.showExtensionsView()
    }

    func handleDanmakuSendButtonTap(_ sender: UIButton) {
        delegate?.wrapperView(self, didTapButton: sender)
    }

    func handleSpeedButtonTap() {
        controlsView.didAutoHideControls()
        rateView.showExtensionsView()
    }

    func handleCatalogueButtonTap() {
        chaptersView.showExtensionsView()
        controlsView.didAutoHideControls()
    }

    func handleFavoriteButtonTap(_ sender: UIButton) {
        delegate?.wrapperView(self, didTapButton: sender)
    }

    func handleCommentButtonTap(_ sender: UIButton) {
        delegate?.wrapperView(self, didTapButton: sender)
    }

    func handleBottombarShareButtonTap() {
        print("分享按钮被点击")
    }
    
    func handleMoreButtonTap() {
        portraitDanmakuView.showExtensionsView()
    }
}


// MARK: - ARTVideoPlayerSlidingViewDelegate

extension ARTVideoPlayerEnhancedWrapperView: ARTVideoPlayerSlidingViewDelegate {
    
    func slidingViewDidTapRestoreButton(for danmakuEntity: ARTVideoPlayerGeneralDanmakuEntity) { // 恢复弹幕初始化
        danmakuEntity.sliderOptions.forEach { [weak self] option in
            self?.overlayView.updateDanmakuSliderValueChanged(for: option)
        }
    }
    
    func slidingViewDidSliderValueChanged(for sliderOption: ARTVideoPlayerGeneralDanmakuEntity.SliderOption) { // 滑块值改变事件回调
        overlayView.updateDanmakuSliderValueChanged(for: sliderOption)
    }
}
