//
//  ARTVideoPlayerBottombar.swift
//  Pods
//
//  Created by mrSir18 on 2024/10/15.
//

import AVFoundation
import ARTZecoToolKit

/// 协议方法
///
/// - NOTE: 可继承该协议方法
protocol ARTVideoPlayerBottombarDelegate: AnyObject {
    
    /// 当滑块触摸开始时调用
    func bottombarDidBeginTouch(for bottombar: ARTVideoPlayerBottombar, slider: ARTVideoPlayerSlider)
    
    /// 当滑块值改变时调用
    func bottombarDidChangeValue(for bottombar: ARTVideoPlayerBottombar, slider: ARTVideoPlayerSlider)
    
    /// 当滑块触摸结束时调用
    func bottombarDidEndTouch(for bottombar: ARTVideoPlayerBottombar, slider: ARTVideoPlayerSlider)
    
    /// 当滑块被点击时调用
    func bottombarDidTap(for bottombar: ARTVideoPlayerBottombar, slider: ARTVideoPlayerSlider)
    
    /// 当暂停按钮被点击时调用
    func bottombarDidTapPause(for bottombar: ARTVideoPlayerBottombar, isPlaying: Bool)
    
    /// 当弹幕开关按钮被点击时调用
    /// - Parameter isDanmakuEnabled: 是否开启弹幕
    func bottombarDidTapDanmakuToggle(for bottombar: ARTVideoPlayerBottombar, isDanmakuEnabled: Bool)
    
    /// 当弹幕设置按钮被点击时调用
    func bottombarDidTapDanmakuSettings(for bottombar: ARTVideoPlayerBottombar)
    
    /// 当弹幕发送按钮被点击时调用
    func bottombarDidTapDanmakuSend(for bottombar: ARTVideoPlayerBottombar, text: String)
}

class ARTVideoPlayerBottombar: UIView {
    
    /// 代理对象
    public weak var delegate: ARTVideoPlayerBottombarDelegate?
    
    /// 缓冲进度视图
    public lazy var progressView: UIProgressView = {
        let view = UIProgressView()
        view.trackTintColor     = .art_color(withHEXValue: 0xFFFFFF, alpha: 0.2)
        view.progressTintColor  = .art_color(withHEXValue: 0xFFFFFF, alpha: 0.25)
        view.layer.cornerRadius = ARTAdaptedValue(1.5)
        view.clipsToBounds      = true
        return view
    }()
    
    /// 滑块视图
    public lazy var sliderView: ARTVideoPlayerSlider = {
        let view = ARTVideoPlayerSlider()
        view.minimumValue = 0.0
        view.maximumValue = 1.0
        view.minimumTrackTintColor = .art_color(withHEXValue: 0xFE5C01, alpha: 0.66)
        view.trackHeight = ARTAdaptedValue(3.0)
        view.thumbOffset = ARTAdaptedValue(-1.5)
        if let thumbImage = UIImage(named: "video_slider_thumb")?.art_scaled(to: ARTAdaptedSize(width: 14.0, height: 14.0)) {
            view.setThumbImage(thumbImage, for: .normal)
        }
        view.addTarget(self, action: #selector(handleSliderTouchBegan(_:)), for: .touchDown)
        view.addTarget(self, action: #selector(handleSliderValueChanged(_:)), for: .valueChanged)
        view.addTarget(self, action: #selector(handleSliderTouchEnded(_:)), for: [.touchUpInside, .touchCancel, .touchUpOutside])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(sliderTapped(_:)))
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    /// 弹幕Key
    public let kDanmakuEnabledKey = "DanmakuEnabledKey"
    
    
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
    public func setupViews() {
        
    }
}

// MARK: - Slider Events

extension ARTVideoPlayerBottombar {
    
    /// 触摸开始时调用的函数
    @objc func handleSliderTouchBegan(_ slider: ARTVideoPlayerSlider) {
        configureSliderAppearance(for: slider, isTouching: true)
        delegate?.bottombarDidBeginTouch(for: self, slider: slider)
    }
    
    /// 滑块值改变时调用的函数
    @objc func handleSliderValueChanged(_ slider: ARTVideoPlayerSlider) {
        delegate?.bottombarDidChangeValue(for: self, slider: slider)
    }
    
    /// 触摸结束时调用的函数
    @objc func handleSliderTouchEnded(_ slider: ARTVideoPlayerSlider) {
        configureSliderAppearance(for: slider, isTouching: false)
        delegate?.bottombarDidEndTouch(for: self, slider: slider)
    }
    
    /// 处理滑块被点击的手势
    @objc func sliderTapped(_ gesture: UITapGestureRecognizer) {
        guard let sliderView = gesture.view as? ARTVideoPlayerSlider else { return }
        let location = gesture.location(in: sliderView)
        guard sliderView.bounds.contains(location) else { return } // 点击位置不在滑块范围内，直接返回
        
        // 计算点击位置相对于滑块的百分比
        let percentage = location.x / sliderView.bounds.width
        let newValue = Float(percentage) * (sliderView.maximumValue - sliderView.minimumValue) + sliderView.minimumValue
        sliderView.value = min(max(newValue, sliderView.minimumValue), sliderView.maximumValue) // 设置滑块的新值，并确保其在有效范围内
        
        // 指定播放时间
        delegate?.bottombarDidTap(for: self, slider: sliderView)
    }
}

// MARK: - Public Methods

extension ARTVideoPlayerBottombar {
    
    /// 更新当前播放时间和总时长
    ///
    /// - Parameters:
    ///   - currentTime: 当前播放时间
    ///   - duration: 视频总时长
    ///   - shouldUpdateSlider: 是否拖动滑块
    @objc public func updatePlaybackTime(currentTime: CMTime, duration: CMTime, shouldUpdateSlider: Bool = false) {
        let currentSeconds = CMTimeGetSeconds(currentTime)
        let totalSeconds = CMTimeGetSeconds(duration)
        
        guard totalSeconds > 0 else {
            sliderView.setValue(0.0, animated: false)
            return
        }
        let progress = min(max(currentSeconds / totalSeconds, 0.0), 1.0)
        if !shouldUpdateSlider { updateProgressBar(progress: Float(progress)) }
    }
    
    /// 更新缓冲进度
    ///
    /// - Parameters:
    ///   - totalBuffer: 缓冲总时间
    ///   - bufferProgress: 缓冲进度
    ///   - shouldUpdateSlider: 是否拖动滑块
    @objc public func updateBufferProgress(totalBuffer: Double, bufferProgress: Float, shouldUpdateSlider: Bool = false) {
        if !shouldUpdateSlider {
            UIView.animate(withDuration: 1.0) {
                self.progressView.setProgress(bufferProgress, animated: true)
            }
        }
    }
    
    /// 自定义滑块外观
    ///
    /// - Parameters:
    ///   - trackHeight: 滑块高度
    ///   - cornerRadius: 进度条圆角半径
    ///   - thumbSize: 滑块大小
    ///   - duration: 动画时间
    @objc public func customizeSliderAppearance(trackHeight: CGFloat, cornerRadius: CGFloat, thumbSize: CGSize, duration: TimeInterval) {
        
    }
    
    /// 触摸开始时调用
    @objc public func updateSliderTouchBegan(value: Float) {
        handleSliderTouchBegan(sliderView)
    }
    
    /// 更新滑块值
    ///
    /// - Parameter value: 滑块值
    @objc public func updateSliderValue(value: Float) {
        adjustSliderValue(value: value)
        delegate?.bottombarDidChangeValue(for: self, slider: sliderView)
    }
    
    /// 触摸结束时调用
    @objc public func updateSliderTouchEnded(value: Float) {
        handleSliderTouchEnded(sliderView)
    }
    
    /// 初始化滑块值
    ///
    /// - Parameter value: 滑块值
    @objc public func resetSliderValue(value: Float = 0.0) {
        progressView.setProgress(value, animated: false)
        sliderView.setValue(value, animated: false)
        resetPlaybackTimeLabels()
    }
    
    /// 重置播放时间标签
    @objc public func resetPlaybackTimeLabels() {
        
    }
    
    /// 更新播放按钮状态
    ///
    /// - Parameter isPlaying: 是否播放中
    @objc public func updatePlayPauseButton(isPlaying: Bool) {
        
    }
    
    /// 检查弹幕功能是否启用
    @objc public func isDanmakuEnabled() -> Bool {
        if UserDefaults.standard.object(forKey: kDanmakuEnabledKey) == nil { // 检查是否已设置
            saveDanmakuEnabled(isDanmakuEnabled: true)
        }
        return UserDefaults.standard.bool(forKey: kDanmakuEnabledKey)
    }
    
    /// 本地存储弹幕状态
    @objc public func saveDanmakuEnabled(isDanmakuEnabled: Bool) {
        UserDefaults.standard.set(isDanmakuEnabled, forKey: kDanmakuEnabledKey)
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
    
    /// 更新滑块外观
    ///
    /// - Parameters:
    ///   - slider: 被更新的滑块
    ///   - isTouching: 指示滑块是否被触摸
    private func configureSliderAppearance(for slider: ARTVideoPlayerSlider, isTouching: Bool) {
        let trackHeight: CGFloat    = isTouching ? ARTAdaptedValue(5.0) : ARTAdaptedValue(3.0)
        let cornerRadius: CGFloat   = isTouching ? ARTAdaptedValue(2.5) : ARTAdaptedValue(1.5)
        let thumbSize: CGSize       = isTouching ? ARTAdaptedSize(width: 18.0, height: 18.0) : ARTAdaptedSize(width: 14.0, height: 14.0)
        let duration: TimeInterval  = isTouching ? 0.35 : 0.25
        
        // 自定义滑块外观
        customizeSliderAppearance(trackHeight: trackHeight, cornerRadius: cornerRadius, thumbSize: thumbSize, duration: duration)
    }
    
    /// 更新滑块值
    ///
    /// - Parameter value: 滑块值变化
    private func adjustSliderValue(value: Float) {
        sliderView.setValue(min(max(sliderView.value + value, 0), 1), animated: true)
    }
}
