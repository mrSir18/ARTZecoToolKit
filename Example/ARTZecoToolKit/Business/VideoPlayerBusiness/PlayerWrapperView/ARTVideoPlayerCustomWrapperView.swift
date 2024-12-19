//
//  ARTVideoPlayerCustomWrapperView.swift
//  Pods
//
//  Created by mrSir18 on 2024/10/15.
//

import AVFoundation
import ARTZecoToolKit

class ARTVideoPlayerCustomWrapperView: ARTVideoPlayerWrapperView {
    
    /// 是否正在拖动进度条
    public var isDraggingSlider = false
    
    
    // MARK: - 播放器组件 AVPlayer（最底层：播放器视图）
    
    /// 播放器图层（最底层：用于显示弹幕、广告等）
    public var overlayView: ARTVideoPlayerOverlayView!
    
    /// 播放器系统控制层（中间层：系统控制，位于弹幕、广告等之上）
    public var systemControls: ARTVideoPlayerSystemControls!
    
    /// 播放器控制层（最顶层：顶部栏、侧边栏等）
    public var controlsView: ARTVideoPlayerControlsView!
    
    /// 播放器加载动画视图
    public var loadingView: ARTVideoPlayerLoadingView!
    
    
    // MARK: - Initialization
    
    override func setupViews() {
        super.setupViews()
        
    }
    
    /// 创建播放器图层（最底层：用于显示弹幕、广告等）
    override func setupOverlayView() {

    }
    
    /// 创建系统控制层（中间层：系统控制）
    override func setupSystemControls() {

    }
    
    /// 创建加载动画视图
    override func setupLoadingView() {

    }
    
    /// 创建播放器控制层（最顶层：顶部栏、侧边栏等）
    override func setupControlsView() {
        controlsView = ARTVideoPlayerControlsView(self)
        addSubview(controlsView)
        controlsView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: Override Methods
    
    override func onReceivePlayerItemDidPlayToEnd(_ notification: Notification) { // 播放结束
        super.onReceivePlayerItemDidPlayToEnd(notification)
    }
    
    override func onReceivePlayerProgressDidChange(time: CMTime) { // 播放进度改变
        super.onReceivePlayerProgressDidChange(time: time)
    }
    
    override func onReceivePlayerReadyToPlay() { // 播放器准备好播
        super.onReceivePlayerReadyToPlay()
    }
    
    override func onReceiveLoadedTimeRangesChanged(totalBuffer: Double, bufferProgress: Float) { // 缓冲进度改变
        super.onReceiveLoadedTimeRangesChanged(totalBuffer: totalBuffer, bufferProgress: bufferProgress)
    }
    
    override func onReceivePresentationSizeChanged(size: CGSize) { // 视频尺寸改变
        super.onReceivePresentationSizeChanged(size: size)
    }
}

// MARK: - 发送消息给外部

extension ARTVideoPlayerCustomWrapperView {
    
    override func didPrepareForNextVideo() { // 准备好播放下一集
        
    }
  
    override func didCompleteSetupForNextVideo() { // 播放下一集
        
    }

    override func didUpdatePreviewImage(previewImage: UIImage) { // 更新预览图像
        
    }

    override func didUpdatePreviewTime(currentTime: CMTime, totalTime: CMTime) { // 更新当前预览视频的时间与视频总时长
        
    }
 
    override func didStartLoadingAnimation() { // 开始加载动画
         
    }

    override func didStopLoadingAnimation() { // 停止加载动画
 
    }
    
    // MARK: - Gesture Recognizer

    override func didReceiveSliderTouchBegan(sliderValue: Float) { // 触摸开始时调用
        controlsView.updateSliderTouchBeganInControls(sliderValue: sliderValue)
    }
   
    override func didReceiveSliderValue(sliderValue: Float) { // 滑动过程中调用
        controlsView.updateSliderValueInControls(sliderValue: sliderValue)
    }
    
    override func didReceiveSliderTouchEnded(sliderValue: Float) { // 触摸结束时调用
        controlsView.updateSliderTouchEndedInControls(sliderValue: sliderValue)
    }

    override func didReceiveTapGesture(at location: CGPoint) { // 点击手势
//        if overlayView.handleTapOnOverlay(at: location) { return } // 如果弹幕视图处理了点击事件，直接返回
        if isLandscape { // 如果是横屏模式，切换控制
            controlsView.toggleControlsVisibility()
        } else { // 如果是竖屏模 
            togglePlayerState()
        }
    }

    override func didReceivewDoubleTapGesture() { // 双击手势
        togglePlayerState()
    }
}


// MARK: - Public Methods

extension ARTVideoPlayerCustomWrapperView {
    
    /// 切换播放器状态
    public func togglePlayerState() {
        switch playerState {
        case .paused: // 恢复播放
//            overlayView.resumeDanmaku() // 恢复弹幕
//            resumePlayer()
            print("恢复播放")
        case .playing: // 暂停播放
            pausePlayer()
        case .ended: // 重新播放
//            overlayView.startDanmaku() // 开始弹幕
            controlsView.resetSliderValueInControls()
            controlsView.updatePlayPauseButtonInControls(isPlaying: true)
            seek(to: CMTime.zero) { [weak self] _ in
//                self?.resumePlayer()
                print("重新播放")
            }
        default:
            break
        }
    }
}
