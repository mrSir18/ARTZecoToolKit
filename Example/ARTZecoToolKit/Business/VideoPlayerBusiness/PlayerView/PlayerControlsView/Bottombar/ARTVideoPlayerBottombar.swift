//
//  ARTVideoPlayerBottombar.swift
//  ARTZeco
//
//  Created by mrSir18 on 2024/10/15.
//

import AVFoundation
import ARTZecoToolKit
import RxSwift
import RxCocoa

protocol ARTVideoPlayerBottombarDelegate: AnyObject {
    
    /// 请求播放器的播放状态
    /// - Returns: 播放器当前状态
    func bottombarDidRequestPlayerState(for bottombar: ARTVideoPlayerBottombar) -> PlayerState
    
    /// 滑块操作
    /// - Parameters:
    ///   - slider: 被操作的滑块
    ///   - action: 操作类型
    func bottombar(_ bottombar: ARTVideoPlayerBottombar, didPerformSliderAction slider: ARTVideoPlayerSlider, action: SliderAction)
    
    /// 用户点击底部工具栏按钮
    /// - Parameter sender: 按钮对象
    func bottombar(_ bottombar: ARTVideoPlayerBottombar, didTapButton sender: UIButton)
}

class ARTVideoPlayerBottombar: UIView {
    
    /// 代理对象
    public weak var delegate: ARTVideoPlayerBottombarDelegate?
    
    /// 播放器状态
    public var playerState: PlayerState {
        delegate_requestPlayerState()
    }
    
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
        if let thumbImage = UIImage(named: "icon_video_slider_thumb")?.art_scaled(to: ARTAdaptedSize(width: 14.0, height: 14.0)) {
            view.setThumbImage(thumbImage, for: .normal)
        }
        view.addTarget(self, action: #selector(handleSliderTouchBegan(_:)), for: .touchDown)
        view.addTarget(self, action: #selector(handleSliderValueChanged(_:)), for: .valueChanged)
        view.addTarget(self, action: #selector(handleSliderTouchEnded(_:)), for: [.touchUpInside, .touchCancel, .touchUpOutside])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(sliderTapped(_:)))
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    /// 订阅管理对象
    public let disposeBag = DisposeBag()
    
    /// 进度条上次点击时间
    private var lastSliderTapTime: TimeInterval = 0.0
    
    /// 弹幕Key
    public let kDanmakuEnabledKey = "DanmakuEnabledKey"
    
    
    // MARK: - Initialization
    
    public init(_ delegate: ARTVideoPlayerBottombarDelegate? = nil) {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        self.delegate = delegate
        setupViews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Super Methods
    
    /// 重写父类方法，设置子视图
    public func setupViews() {
        
    }
    
    // MARK: - Button Actions
    
    /// 处理按钮点击事件
    /// - Parameter button: 按钮对象
    public func handleButtonTap(_ sender: UIButton) {
        delegate?.bottombar(self, didTapButton: sender)
    }
}

// MARK: - Slider Events

extension ARTVideoPlayerBottombar {
    
    /// 触摸开始时调用的函数
    @objc func handleSliderTouchBegan(_ slider: ARTVideoPlayerSlider) {
        guard playerState != .buffering else { return }
        configureSliderAppearance(for: slider, isTouching: true)
        delegate?.bottombar(self, didPerformSliderAction: slider, action: .beginTouch)
    }
    
    /// 滑块值改变时调用的函数
    @objc func handleSliderValueChanged(_ slider: ARTVideoPlayerSlider) {
        guard playerState != .buffering else { return }
        delegate?.bottombar(self, didPerformSliderAction: slider, action: .changeValue)
    }
    
    /// 触摸结束时调用的函数
    @objc func handleSliderTouchEnded(_ slider: ARTVideoPlayerSlider) {
        guard playerState != .buffering else { return }
        configureSliderAppearance(for: slider, isTouching: false)
        delegate?.bottombar(self, didPerformSliderAction: slider, action: .endTouch)
    }
    
    /// 处理滑块被点击的手势
    @objc func sliderTapped(_ gesture: UITapGestureRecognizer) {
        guard playerState != .buffering else { return }
        let currentTime = Date().timeIntervalSince1970
        guard currentTime - lastSliderTapTime >= 0.5 else { return } // 限制点击间隔，至少 0.5 秒, 防止进度条动画未完成时重复点击
        
        guard let slider = gesture.view as? ARTVideoPlayerSlider else { return }
        let location = gesture.location(in: slider)
        guard slider.bounds.contains(location) else { return } // 点击位置不在滑块范围内，直接返回
        
        // 计算点击位置相对于滑块的百分比
        let percentage = location.x / slider.bounds.width
        let newValue = Float(percentage) * (slider.maximumValue - slider.minimumValue) + slider.minimumValue
        slider.value = min(max(newValue, slider.minimumValue), slider.maximumValue) // 设置滑块的新值，并确保其在有效范围内
        
        // 指定播放时间
        delegate?.bottombar(self, didPerformSliderAction: slider, action: .tap)
        
        // 更新上次点击的时间
        lastSliderTapTime = currentTime
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
    @objc public func updateBufferingProgress(totalBuffer: Double, bufferProgress: Float, shouldUpdateSlider: Bool = false) {
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
    @objc public func updateSliderPosition(value: Float) {
        adjustSliderValue(value: value)
        delegate?.bottombar(self, didPerformSliderAction: sliderView, action: .changeValue)
    }
    
    /// 触摸结束时调用
    @objc public func updateSliderTouchEnded(value: Float) {
        handleSliderTouchEnded(sliderView)
    }
    
    /// 初始化滑块值
    ///
    /// - Parameter value: 滑块值
    @objc public func resetSliderPosition(value: Float = 0.0) {
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
    @objc public func updatePlayPauseButtonState(isPlaying: Bool) {
        
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
    /// - Parameter value: 滑块值变化
    private func adjustSliderValue(value: Float) {
        sliderView.setValue(min(max(sliderView.value + value, 0), 1), animated: true)
    }
}

// MARK: - Private Delegate Methods

extension ARTVideoPlayerBottombar {
    
    /// 控制层视图已经显示
    /// - Parameters: alpha 控制层视图透明度
    private func delegate_requestPlayerState() -> PlayerState {
        return delegate?.bottombarDidRequestPlayerState(for: self) ?? .buffering
    }
}
