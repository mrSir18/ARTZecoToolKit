//
//  ARTVideoPlayerWindowBottombar.swift
//  ARTZeco
//
//  Created by mrSir18 on 2024/10/15.
//

import AVFoundation
import ARTZecoToolKit

class ARTVideoPlayerWindowBottombar: ARTVideoPlayerBottombar {
    
    /// 容器视图
    private var containerView: UIView!
    
    /// 当前播放时间标签
    private var currentTimeLabel: UILabel!
    
    /// 总时长标签
    private var durationLabel: UILabel!
    
    /// 全屏按钮
    private var fullscreenButton: ARTAlignmentButton!
    
    
    // MARK: - Override Super Methods
    
    override func setupViews() {
        super.setupViews()
        setupContainerView()
        setupCurrentTimeLabel()
        setupDurationLabel()
        setupFullscreenButton()
        setupProgressView()
        setupSliderView()
    }
    
    // MARK: - Override Super Methods
    
    override func updatePlaybackTime(currentTime: CMTime, duration: CMTime, shouldUpdateSlider: Bool = true) { // 更新当前播放时间和总时长
        super.updatePlaybackTime(currentTime: currentTime, duration: duration, shouldUpdateSlider: shouldUpdateSlider)
        currentTimeLabel.text = currentTime.art_formattedTime()
        durationLabel.text = duration.art_formattedTime()
    }
    
    override func customizeSliderAppearance(trackHeight: CGFloat, cornerRadius: CGFloat, thumbSize: CGSize, duration: TimeInterval) { // 自定义滑块外观
        DispatchQueue.main.async {
            UIView.animate(withDuration: duration) {
                self.sliderView.trackHeight = trackHeight
                self.progressView.layer.cornerRadius = cornerRadius
                if let thumbImage = UIImage(named: "icon_video_slider_thumb")?.art_scaled(to: thumbSize) {
                    self.sliderView.setThumbImage(thumbImage, for: .normal)
                }
                self.progressView.snp.updateConstraints { make in
                    make.height.equalTo(trackHeight)
                }
                self.layoutIfNeeded()
            }
        }
    }
    
    override func resetPlaybackTimeLabels() { // 重置播放时间标签
        currentTimeLabel.text = "00:00"
        durationLabel.text = "/00:00"
    }
}

// MARK: - Setup Initializer

extension ARTVideoPlayerWindowBottombar {
    
    private func setupContainerView() { // 创建容器视图
        containerView = UIView()
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
            make.bottom.equalTo(-ARTAdaptedValue(30.0))
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
        fullscreenButton.tag                = ARTVideoPlayerControls.ButtonType.fullscreen.rawValue
        fullscreenButton.layoutType         = .freeform
        fullscreenButton.imageAlignment     = .topLeft
        fullscreenButton.imageEdgeInset     = UIEdgeInsets(top: ARTAdaptedValue(10.0), left: ARTAdaptedValue(12.0), bottom: 0, right: 0) // 图片内边距
        fullscreenButton.imageSize          = ARTAdaptedSize(width: 20.0, height: 20.0)
        fullscreenButton.setImage(UIImage(named: "icon_video_fullscreen"), for: .normal)
        containerView.addSubview(fullscreenButton)
        fullscreenButton.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(ARTAdaptedValue(48.0))
        }
        fullscreenButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.handleButtonTap(self.fullscreenButton)
        })
        .disposed(by: disposeBag)
    }
    
    private func setupProgressView() { // 创建进度条
        containerView.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.left.equalTo(currentTimeLabel)
            make.bottom.equalTo(-ARTAdaptedValue(16.0))
            make.right.equalTo(durationLabel)
            make.height.equalTo(ARTAdaptedValue(3.0))
        }
    }
    
    private func setupSliderView() { // 创建滑块视图
        containerView.addSubview(sliderView)
        sliderView.snp.makeConstraints { make in
            make.left.equalTo(progressView.snp.left).offset(ARTAdaptedValue(2.0))
            make.centerY.equalTo(progressView.snp.centerY).offset(-0.4)
            make.right.equalTo(progressView.snp.right).offset(-ARTAdaptedValue(2.0))
            make.height.equalTo(ARTAdaptedValue(32.0))
        }
        // 将 progressView 移动到最顶层
        containerView.bringSubviewToFront(fullscreenButton)
    }
}
