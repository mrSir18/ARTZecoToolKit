//
//  ARTVideoPlayerBottombar.swift
//  Pods
//
//  Created by mrSir18 on 2024/10/15.
//

import AVFoundation

/// 协议方法
///
/// - NOTE: 可继承该协议方法
public protocol ARTVideoPlayerBottombarDelegate: AnyObject {
    
}

open class ARTVideoPlayerBottombar: UIView {
    
    /// 代理对象
    public weak var delegate: ARTVideoPlayerBottombarDelegate?
    
    /// 缓冲进度视图
    public var progressView: UIProgressView!
    
    /// 滑块视图
    public var sliderView: ARTVideoPlayerSlider!
    
    
    // MARK: - Initialization
    
    public init(_ delegate: ARTVideoPlayerBottombarDelegate? = nil) {
        super.init(frame: .zero)
        self.delegate = delegate
        self.backgroundColor = .clear
        setupViews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Super Methods
    
    /// 重写父类方法，设置子视图
    ///
    /// - Note: 由于子类需要自定义视图，所以需要重写该方法
    open func setupViews() {
        
    }
}

extension ARTVideoPlayerBottombar {
    
    /// 更新当前播放时间和总时长
    ///
    /// - Parameters:
    ///   - currentTime: 当前播放时间字符串
    ///   - duration: 视频总时长字符串
    /// - Note: 重写此方法以更新底部工具栏的当前播放时间和总时长
    @objc open func updatePlaybackTime(currentTime: CMTime, duration: CMTime) {
        guard let sliderView = self.sliderView else { return }
        let currentSeconds = CMTimeGetSeconds(currentTime)
        let totalSeconds = CMTimeGetSeconds(duration)
        
        guard totalSeconds > 0 else { // 确保总时长有效，避免除以零
            sliderView.setValue(0.0, animated: false)
            return
        }
        let progress = min(max(currentSeconds / totalSeconds, 0.0), 1.0)
        updateProgressBar(progress: Float(progress))
    }
    
    /// 更新缓冲总时间和缓冲进度
    ///
    /// - Parameters:
    ///  - totalBuffer: 缓冲总时间
    ///  - bufferProgress: 缓冲进度
    /// - Note: 重写父类方法，更新播放器缓冲总时间和缓冲进度
    @objc open func updateBufferProgress(totalBuffer: Double, bufferProgress: Float) {
        guard let progressView = progressView else { return }
        UIView.animate(withDuration: 1.0, delay: 0, options: [.curveEaseInOut], animations: {
            progressView.setProgress(bufferProgress, animated: true)
        })
    }
}

// MARK: - Private Methods

extension ARTVideoPlayerBottombar {
    
    /// 更新进度条
    ///
    /// - Parameter progress: 进度值
    private func updateProgressBar(progress: Float) {
        UIView.animate(withDuration: 1.0, delay: 0, options: [.curveEaseInOut], animations: {
            self.sliderView.setValue(progress, animated: true)
        })
    }
}
