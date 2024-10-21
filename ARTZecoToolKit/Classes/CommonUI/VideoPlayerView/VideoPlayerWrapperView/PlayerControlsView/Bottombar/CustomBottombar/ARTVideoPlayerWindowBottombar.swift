//
//  ARTVideoPlayerWindowBottombar.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/10/15.
//

import AVFoundation

/// 协议方法
///
/// - NOTE: 可继承该协议方法
public protocol ARTVideoPlayerWindowBottombarDelegate: ARTVideoPlayerBottombarDelegate {
    
    /// 点击全屏按钮
    ///
    /// - Note: 子类实现该方法处理全屏操作
    func videoPlayerBottombarDidTapFullscreen(for bottombar: ARTVideoPlayerWindowBottombar)
}

open class ARTVideoPlayerWindowBottombar: ARTVideoPlayerBottombar {
    
    /// 代理对象
    private weak var subclassDelegate: ARTVideoPlayerWindowBottombarDelegate?
    
    /// 容器视图
    private var containerView: UIView!
    
    /// 当前播放时间标签
    private var currentTimeLabel: UILabel!
    
    /// 总时长标签
    private var durationLabel: UILabel!
    
    /// 全屏按钮
    private var fullscreenButton: ARTAlignmentButton!

    
    // MARK: - Initializatio
    
    public init(_ subclassDelegate: ARTVideoPlayerWindowBottombarDelegate? = nil) {
        self.subclassDelegate = subclassDelegate
        super.init(subclassDelegate)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Super Methods
    
    open override func setupViews() {
        super.setupViews()
        setupContainerView()
        setupCurrentTimeLabel()
        setupDurationLabel()
        setupFullscreenButton()
        setupProgressView()
        setupSliderView()
    }
    
    // MARK: - Setup Methods
    
    private func setupContainerView() { // 创建容器视图
        containerView = UIView()
        containerView.backgroundColor = .clear
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupCurrentTimeLabel() { // 创建当前播放时间标签
        currentTimeLabel = UILabel()
        currentTimeLabel.text               = "00:00"
        currentTimeLabel.textAlignment      = .left
        currentTimeLabel.font               = .art_medium(ARTAdaptedValue(10.0))
        currentTimeLabel.textColor          = .art_color(withHEXValue: 0xFFFFFF)
        containerView.addSubview(currentTimeLabel)
        currentTimeLabel.snp.makeConstraints { make in
            make.left.equalTo(ARTAdaptedValue(12.0))
            make.bottom.equalTo(-ARTAdaptedValue(24.0))
            make.height.equalTo(ARTAdaptedValue(14.0))
        }
    }
    
    private func setupDurationLabel() { // 创建总时长标签
        durationLabel = UILabel()
        durationLabel.text                  = "00:00"
        durationLabel.textAlignment         = .right
        durationLabel.font                  = .art_medium(ARTAdaptedValue(10.0))
        durationLabel.textColor             = .art_color(withHEXValue: 0xFFFFFF)
        containerView.addSubview(durationLabel)
        durationLabel.snp.makeConstraints { make in
            make.right.equalTo(-ARTAdaptedValue(48.0))
            make.bottom.equalTo(currentTimeLabel)
            make.height.equalTo(currentTimeLabel)
        }
    }
    
    private func setupFullscreenButton() { // 创建全屏按钮
        fullscreenButton = ARTAlignmentButton(type: .custom)
        fullscreenButton.layoutType         = .freeform
        fullscreenButton.imageAlignment     = .topLeft
        fullscreenButton.imageEdgeInset     = UIEdgeInsets(top: ARTAdaptedValue(14.0), left: 0, bottom: 0, right: 0) // 图片内边距
        fullscreenButton.imageSize          = ARTAdaptedSize(width: 20.0, height: 20.0)
        fullscreenButton.setImage(UIImage(named: "video_fullscreen"), for: .normal)
        fullscreenButton.addTarget(self, action: #selector(didTapFullscreenButton), for: .touchUpInside)
        containerView.addSubview(fullscreenButton)
        fullscreenButton.snp.makeConstraints { make in
            make.size.equalTo(ARTAdaptedSize(width: 36.0, height: 49.0))
            make.right.bottom.equalToSuperview()
        }
    }
    
    private func setupProgressView() { // 创建进度条
        containerView.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.left.equalTo(currentTimeLabel)
            make.bottom.equalTo(-ARTAdaptedValue(12.0))
            make.right.equalTo(durationLabel)
            make.height.equalTo(ARTAdaptedValue(3.0))
        }
    }
    
    private func setupSliderView() { // 创建滑块视图
        containerView.addSubview(sliderView)
        sliderView.snp.makeConstraints { make in
            make.left.equalTo(progressView.snp.left).offset(ARTAdaptedValue(2.0))
            make.centerY.equalTo(progressView)
            make.right.equalTo(progressView.snp.right).offset(-ARTAdaptedValue(2.0))
            make.height.equalTo(ARTAdaptedValue(32.0))
        }
        // 将 progressView 移动到最顶层
        containerView.bringSubviewToFront(fullscreenButton)
    }
    
    // MARK: - Button Actions
    
    /// 点击全屏按钮
    ///
    /// - Note: 子类实现该方法处理全屏操作
    @objc private func didTapFullscreenButton() {
        subclassDelegate?.videoPlayerBottombarDidTapFullscreen(for: self)
    }
    
    // MARK: - Override Super Methods

    open override func updatePlaybackTime(currentTime: CMTime, duration: CMTime, shouldUpdateSlider: Bool = true) { // 更新当前播放时间和总时长
        super.updatePlaybackTime(currentTime: currentTime, duration: duration, shouldUpdateSlider: shouldUpdateSlider)
        currentTimeLabel.text = currentTime.art_formattedTime()
        durationLabel.text = duration.art_formattedTime()
    }
    
    open override func customizeSliderAppearance(trackHeight: CGFloat, cornerRadius: CGFloat, thumbSize: CGSize, duration: TimeInterval) { // 自定义滑块外观
        DispatchQueue.main.async {
            self.sliderView.trackHeight = trackHeight
            self.progressView.layer.cornerRadius = cornerRadius

            UIView.animate(withDuration: duration) {
                if let thumbImage = UIImage(named: "video_slider_thumb")?.art_scaled(to: thumbSize) {
                    self.sliderView.setThumbImage(thumbImage, for: .normal)
                }
                self.progressView.snp.updateConstraints { make in
                    make.height.equalTo(trackHeight)
                }
                self.layoutIfNeeded()
            }
        }
    }
}
