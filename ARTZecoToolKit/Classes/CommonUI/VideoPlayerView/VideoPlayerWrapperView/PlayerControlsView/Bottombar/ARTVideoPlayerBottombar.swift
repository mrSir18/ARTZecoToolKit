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
@objc public protocol ARTVideoPlayerBottombarDelegate: AnyObject {
    
    /// 当滑块触摸开始时调用
    ///
    /// - Parameters:
    ///   - bottombar: 当前的底部工具栏
    ///   - slider: 被触摸的滑块
    @objc optional func bottombarDidBeginTouch(for bottombar: ARTVideoPlayerBottombar, slider: ARTVideoPlayerSlider)
    
    /// 当滑块值改变时调用
    ///
    /// - Parameters:
    ///   - bottombar: 当前的底部工具栏
    ///   - slider: 值已改变的滑块
    @objc optional func bottombarDidChangeValue(for bottombar: ARTVideoPlayerBottombar, slider: ARTVideoPlayerSlider)
    
    /// 当滑块触摸结束时调用
    ///
    /// - Parameters:
    ///   - bottombar: 当前的底部工具栏
    ///   - slider: 被释放的滑块
    @objc optional func bottombarDidEndTouch(for bottombar: ARTVideoPlayerBottombar, slider: ARTVideoPlayerSlider)
    
    /// 当滑块被点击时调用
    ///
    /// - Parameters:
    ///   - bottombar: 当前的底部工具栏
    ///   - slider: 被点击的滑块
    @objc optional func bottombarDidTap(for bottombar: ARTVideoPlayerBottombar, slider: ARTVideoPlayerSlider)
}

open class ARTVideoPlayerBottombar: UIView {
    
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

// MARK: - Slider Events

extension ARTVideoPlayerBottombar {
    
    /// 触摸开始时调用的函数
    ///
    /// - Parameter slider: 被触摸的滑块
    /// - Note: 重写此方法以处理滑块触摸
    @objc open func handleSliderTouchBegan(_ slider: ARTVideoPlayerSlider) {
        configureSliderAppearance(for: slider, isTouching: true)
        delegate?.bottombarDidBeginTouch?(for: self, slider: slider)
    }
    
    /// 滑块值改变时调用的函数
    ///
    /// - Parameter slider: 值已改变的滑块
    /// - Note: 重写此方法以处理滑块值改变事件
    @objc open func handleSliderValueChanged(_ slider: ARTVideoPlayerSlider) {
        delegate?.bottombarDidChangeValue?(for: self, slider: slider)
    }
    
    /// 触摸结束时调用的函数
    ///
    /// - Parameter slider: 被释放的滑块
    /// - Note: 重写此方法以处理滑块触摸结束事件
    @objc open func handleSliderTouchEnded(_ slider: ARTVideoPlayerSlider) {
        configureSliderAppearance(for: slider, isTouching: false)
        delegate?.bottombarDidEndTouch?(for: self, slider: slider)
    }
    
    /// 处理滑块被点击的手势
    ///
    /// - Parameter gesture: 点击手势识别器
    /// - Note: 重写此方法以处理滑块点击事件
    @objc open func sliderTapped(_ gesture: UITapGestureRecognizer) {
        guard let sliderView = gesture.view as? ARTVideoPlayerSlider else { return }
        let location = gesture.location(in: sliderView)
        guard sliderView.bounds.contains(location) else { return } // 点击位置不在滑块范围内，直接返回
        
        // 计算点击位置相对于滑块的百分比
        let percentage = location.x / sliderView.bounds.width
        let newValue = Float(percentage) * (sliderView.maximumValue - sliderView.minimumValue) + sliderView.minimumValue
        sliderView.value = min(max(newValue, sliderView.minimumValue), sliderView.maximumValue) // 设置滑块的新值，并确保其在有效范围内
        
        // 指定播放时间
        delegate?.bottombarDidTap?(for: self, slider: sliderView)
    }
}

// MARK: - Public Methods

extension ARTVideoPlayerBottombar {
    
    /// 更新当前播放时间和总时长
    ///
    /// - Parameters:
    ///   - currentTime: 当前播放时间字符串
    ///   - duration: 视频总时长字符串
    ///   - shouldUpdateSlider: 是否正在拖动滑动块
    /// - Note: 重写此方法以更新底部工具栏的当前播放时间和总时长
    @objc open func updatePlaybackTime(currentTime: CMTime, duration: CMTime, shouldUpdateSlider: Bool = false) {
        let currentSeconds = CMTimeGetSeconds(currentTime)
        let totalSeconds = CMTimeGetSeconds(duration)
        
        guard totalSeconds > 0 else { // 确保总时长有效，避免除以零
            sliderView.setValue(0.0, animated: false)
            return
        }
        let progress = min(max(currentSeconds / totalSeconds, 0.0), 1.0)
        if !shouldUpdateSlider { updateProgressBar(progress: Float(progress)) }
    }
    
    /// 更新缓冲总时间和缓冲进度
    ///
    /// - Parameters:
    ///  - totalBuffer: 缓冲总时间
    ///  - bufferProgress: 缓冲进度
    ///  - shouldUpdateSlider: 是否正在拖动滑动块
    /// - Note: 重写父类方法，更新播放器缓冲总时间和缓冲进度
    @objc open func updateBufferProgress(totalBuffer: Double, bufferProgress: Float, shouldUpdateSlider: Bool = false) {
        if !shouldUpdateSlider {
            UIView.animate(withDuration: 1.0, delay: 0, options: [.curveEaseInOut], animations: {
                self.progressView.setProgress(bufferProgress, animated: true)
            })
        }
    }
    
    /// 更新滑块和进度条样式
    ///
    /// - Parameters:
    ///   - trackHeight: 滑块的高度
    ///   - cornerRadius: 进度条的圆角半径
    ///   - thumbSize: 滑块的大小
    ///   - duration: 动画持续时间
    @objc open func customizeSliderAppearance(trackHeight: CGFloat, cornerRadius: CGFloat, thumbSize: CGSize, duration: TimeInterval) {
        
    }
    
    /// 触摸开始时调用的函数
    ///
    /// - Note: 重写此方法以处理滑块触摸
    @objc open func updateSliderTouchBegan(value: Float) {
        handleSliderTouchBegan(sliderView)
    }
    
    /// 更新滑块值
    ///
    /// - Parameter value: 滑块值
    /// - Note: 重写此方法以更新底部工具栏的滑块值
    @objc open func updateSliderValue(value: Float) {
        adjustSliderValue(value: value)
        delegate?.bottombarDidChangeValue?(for: self, slider: sliderView)
    }
    
    /// 触摸结束时调用的函数
    ///
    /// - Note: 重写此方法以处理滑块触摸结束事件
    @objc open func updateSliderTouchEnded(value: Float) {
        handleSliderTouchEnded(sliderView)
    }
    
    /// 初始化滑块的值
    ///
    /// - Note: 重写此方法以初始化底部工具栏的滑块值
    @objc open func resetSliderValue() {
        sliderView.setValue(0.0, animated: false)
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
    
    /// 更新滑块的外观
    ///
    /// - Parameters:
    ///   - slider: 被更新的滑块
    ///   - isTouching: 指示滑块是否正在被触摸
    private func configureSliderAppearance(for slider: ARTVideoPlayerSlider, isTouching: Bool) {
        let trackHeight: CGFloat    = isTouching ? ARTAdaptedValue(5.0) : ARTAdaptedValue(3.0)
        let cornerRadius: CGFloat   = isTouching ? ARTAdaptedValue(2.5) : ARTAdaptedValue(1.5)
        let thumbSize: CGSize       = isTouching ? ARTAdaptedSize(width: 18.0, height: 18.0) : ARTAdaptedSize(width: 14.0, height: 14.0)
        let duration: TimeInterval  = isTouching ? 0.35 : 0.25
        
        // 自定义滑块外观
        customizeSliderAppearance(trackHeight: trackHeight, cornerRadius: cornerRadius, thumbSize: thumbSize, duration: duration)
    }
    
    /// 更新滑块值并控制是否通知代理
    ///
    /// - Parameters:
    ///   - value: 滑块值变化
    private func adjustSliderValue(value: Float) {
        sliderView.setValue(min(max(sliderView.value + value, 0), 1), animated: true)
    }
}
