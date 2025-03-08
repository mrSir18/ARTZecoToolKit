//
//  ARTVideoPlayerLandscapeFullscreenBottombar.swift
//  ARTZeco
//
//  Created by mrSir18 on 2024/10/15.
//

import AVFoundation
import ARTZecoToolKit

class ARTVideoPlayerLandscapeFullscreenBottombar: ARTVideoPlayerBottombar {
    
    /// 容器视图
    private var containerView: UIView!
    
    /// 当前播放时间标签
    private var currentTimeLabel: UILabel!
    
    /// 总时长标签
    private var durationLabel: UILabel!
    
    /// 暂停按钮
    private var pauseButton: ARTAlignmentButton!
    
    /// 下一集按钮
    private var nextButton: ARTAlignmentButton!
    
    /// 弹幕按钮
    private var danmakuButton: ARTAlignmentButton!
    
    /// 弹幕设置按钮
    private var danmakuSettingsButton: ARTAlignmentButton!
    
    /// 弹幕输入框
    private var danmakuInputLabel: YYLabel!
    
    /// 倍数按钮
    private var speedButton: UIButton!
    
    /// 合集按钮
    private var collectionButton: UIButton!

    
    // MARK: - Override Super Methods
    
    override func setupViews() {
        super.setupViews()
        setupContainerView()
        setupCurrentTimeLabel()
        setupDurationLabel()
        setupProgressView()
        setupSliderView()
        setupPauseButton()
        setupNextButton()
        setupDanmakuButton()
        setupDanmakuSettingsButton()
        setupDanmakuInputField()
        setupCatalogueButton()
        setupSpeedButton()
    }
    
    // MARK: - Override Super Methods
    
    override func updatePlaybackTime(currentTime: CMTime, duration: CMTime, shouldUpdateSlider: Bool = true) { // 更新当前播放时间和总时长
        super.updatePlaybackTime(currentTime: currentTime, duration: duration, shouldUpdateSlider: shouldUpdateSlider)
        currentTimeLabel.text = currentTime.art_formattedTime()
        durationLabel.text = "/\(duration.art_formattedTime())"
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
    override func updatePlayPauseButtonState(isPlaying: Bool) { // 更新播放暂停按钮
        pauseButton.isSelected = !isPlaying
    }
}

// MARK: - Public Methods

extension ARTVideoPlayerLandscapeFullscreenBottombar {
    
    /// 更新倍速按钮标题
    public func updateRateButtonTitle(rate: Float) {
        speedButton.setTitle(rate == 1.0 ? "倍数" : String(format: "%.1fX", rate), for: .normal)
    }
}

// MARK: - Setup Initializer

extension ARTVideoPlayerLandscapeFullscreenBottombar {
    
    private func setupContainerView() { // 创建容器视图
        containerView = UIView()
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupCurrentTimeLabel() { // 创建当前播放时间标签
        let leftInset = UIScreen.art_currentScreenIsIphoneX ? ARTAdaptedValue(66.0) : ARTAdaptedValue(12.0)
        currentTimeLabel = UILabel()
        currentTimeLabel.text               = "00:00"
        currentTimeLabel.textAlignment      = .left
        currentTimeLabel.font               = .art_medium(ARTAdaptedValue(10.0))
        currentTimeLabel.textColor          = .art_color(withHEXValue: 0xFFFFFF)
        containerView.addSubview(currentTimeLabel)
        currentTimeLabel.snp.makeConstraints { make in
            make.left.equalTo(leftInset)
            make.top.equalTo(ARTAdaptedValue(6.0))
            make.width.greaterThanOrEqualTo(ARTAdaptedValue(26.0))
            make.height.equalTo(ARTAdaptedValue(14.0))
        }
    }
    
    private func setupDurationLabel() { // 创建总时长标签
        durationLabel = UILabel()
        durationLabel.text                  = "/00:00"
        durationLabel.textAlignment         = .left
        durationLabel.font                  = .art_medium(ARTAdaptedValue(10.0))
        durationLabel.textColor             = .art_color(withHEXValue: 0xFFFFFF)
        containerView.addSubview(durationLabel)
        durationLabel.snp.makeConstraints { make in
            make.left.equalTo(currentTimeLabel.snp.right)
            make.centerY.equalTo(currentTimeLabel)
            make.height.equalTo(currentTimeLabel)
        }
    }
    
    private func setupProgressView() { // 创建进度条
        let rightInset = UIScreen.art_currentScreenIsIphoneX ? ARTAdaptedValue(54.0) : ARTAdaptedValue(12.0)
        containerView.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.left.equalTo(currentTimeLabel)
            make.bottom.equalTo(-ARTAdaptedValue(57.0))
            make.right.equalTo(-rightInset)
            make.height.equalTo(ARTAdaptedValue(3.0))
        }
    }
    
    private func setupSliderView() { // 创建滑块视图
        containerView.addSubview(sliderView)
        sliderView.snp.makeConstraints { make in
            make.left.equalTo(progressView.snp.left).offset(ARTAdaptedValue(2.0))
            make.centerY.equalTo(progressView.snp.centerY).offset(-0.6)
            make.right.equalTo(progressView.snp.right).offset(-ARTAdaptedValue(2.0))
            make.height.equalTo(ARTAdaptedValue(20.0))
        }
    }
    
    private func setupPauseButton() { // 创建暂停按钮
        pauseButton = ARTAlignmentButton(type: .custom)
        pauseButton.tag                     = ARTVideoPlayerControls.ButtonType.pause.rawValue
        pauseButton.imageAlignment          = .left
        pauseButton.imageSize               = ARTAdaptedSize(width: 20.0, height: 20.0)
        pauseButton.setImage(UIImage(named: "icon_video_pause"), for: .normal)
        pauseButton.setImage(UIImage(named: "icon_video_play"), for: .selected)
        containerView.addSubview(pauseButton)
        pauseButton.snp.makeConstraints { make in
            make.size.equalTo(ARTAdaptedSize(width: 36.0, height: 36.0))
            make.bottom.equalTo(-ARTAdaptedValue(12.0))
            make.left.equalTo(currentTimeLabel.snp.left).offset(-ARTAdaptedValue(4.0))
        }
        pauseButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.pauseButton.isSelected.toggle()
            self.handleButtonTap(self.pauseButton)
        })
        .disposed(by: disposeBag)
    }
    
    private func setupNextButton() { // 创建下一集按钮
        nextButton = ARTAlignmentButton(type: .custom)
        nextButton.tag                      = ARTVideoPlayerControls.ButtonType.next.rawValue
        nextButton.imageAlignment           = .left
        nextButton.imageSize                = ARTAdaptedSize(width: 18.0, height: 17.0)
        nextButton.setImage(UIImage(named: "icon_video_next_episode"), for: .normal)
        containerView.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.size.equalTo(pauseButton)
            make.left.equalTo(pauseButton.snp.right)
            make.centerY.equalTo(pauseButton)
        }
        nextButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.handleButtonTap(self.nextButton)
        })
        .disposed(by: disposeBag)
    }
    
    private func setupDanmakuButton() { // 创建弹幕开关按钮
        danmakuButton = ARTAlignmentButton(type: .custom)
        danmakuButton.tag                   = ARTVideoPlayerControls.ButtonType.danmakuToggle.rawValue
        danmakuButton.isSelected            = isDanmakuEnabled()
        danmakuButton.imageAlignment        = .left
        danmakuButton.imageSize             = ARTAdaptedSize(width: 23.0, height: 23.0)
        danmakuButton.setImage(UIImage(named: "icon_video_danmaku_off"), for: .normal)
        danmakuButton.setImage(UIImage(named: "icon_video_danmaku_on"), for: .selected)
        containerView.addSubview(danmakuButton)
        danmakuButton.snp.makeConstraints { make in
            make.size.equalTo(pauseButton)
            make.left.equalTo(nextButton.snp.right)
            make.centerY.equalTo(pauseButton)
        }
        danmakuButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.danmakuButton.isSelected = !self.danmakuButton.isSelected
            self.handleButtonTap(self.danmakuButton)
        })
        .disposed(by: disposeBag)
    }
    
    private func setupDanmakuSettingsButton() { // 创建弹幕设置按钮
        danmakuSettingsButton = ARTAlignmentButton(type: .custom)
        danmakuSettingsButton.tag            = ARTVideoPlayerControls.ButtonType.danmakuSettings.rawValue
        danmakuSettingsButton.imageAlignment = .left
        danmakuSettingsButton.imageSize = ARTAdaptedSize(width: 23.0, height: 23.0)
        danmakuSettingsButton.setImage(UIImage(named: "icon_video_danmaku_settings"), for: .normal)
        containerView.addSubview(danmakuSettingsButton)
        danmakuSettingsButton.snp.makeConstraints { make in
            make.size.equalTo(pauseButton)
            make.left.equalTo(danmakuButton.snp.right)
            make.centerY.equalTo(pauseButton)
        }
        danmakuSettingsButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.handleButtonTap(self.danmakuSettingsButton)
        })
        .disposed(by: disposeBag)
    }
    
    private func setupDanmakuInputField() { // 创建弹幕输入框
        let inputView = UIView()
        inputView.backgroundColor           = .art_color(withHEXValue: 0xD8D8D8, alpha: 0.3)
        inputView.layer.cornerRadius        = ARTAdaptedValue(14.0)
        inputView.layer.masksToBounds       = true
        containerView.addSubview(inputView)
        inputView.snp.makeConstraints { make in
            make.size.equalTo(ARTAdaptedSize(width: 163.0, height: 28.0))
            make.left.equalTo(danmakuSettingsButton.snp.right).offset(ARTAdaptedValue(24.0))
            make.centerY.equalTo(pauseButton)
        }
        
        danmakuInputLabel = YYLabel()
        danmakuInputLabel.font              = .art_regular(ARTAdaptedValue(12.0))
        danmakuInputLabel.textColor         = .art_color(withHEXValue: 0xFFFFFF)
        danmakuInputLabel.text              = "发一条友好的弹幕吧"
        danmakuInputLabel.textAlignment     = .center
        containerView.addSubview(danmakuInputLabel)
        danmakuInputLabel.snp.makeConstraints { make in
            make.top.bottom.equalTo(inputView)
            make.left.equalTo(inputView.snp.left).offset(ARTAdaptedValue(12.0))
            make.right.equalTo(inputView.snp.right).offset(-ARTAdaptedValue(12.0))
        }
        
        let danmakuSendButton = UIButton(type: .custom)
        danmakuSendButton.tag               = ARTVideoPlayerControls.ButtonType.danmakuSend.rawValue
        containerView.addSubview(danmakuSendButton)
        danmakuSendButton.snp.makeConstraints { make in
            make.edges.equalTo(inputView)
        }
        danmakuSendButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            danmakuSendButton.art_customValue = self.danmakuInputLabel.text
            self.handleButtonTap(danmakuSendButton)
        })
        .disposed(by: disposeBag)
    }
    
    private func setupCatalogueButton() { // 创建合集按钮
        collectionButton = UIButton(type: .custom)
        collectionButton.tag                = ARTVideoPlayerControls.ButtonType.catalogue.rawValue
        collectionButton.titleLabel?.font   = .art_medium(ARTAdaptedValue(12.0))
        collectionButton.contentHorizontalAlignment = .right
        collectionButton.setTitle("目录", for: .normal)
        collectionButton.setTitleColor(.art_color(withHEXValue: 0xFFFFFF), for: .normal)
        containerView.addSubview(collectionButton)
        collectionButton.snp.makeConstraints { make in
            make.size.equalTo(ARTAdaptedSize(width: 44.0, height: 37.0))
            make.right.equalTo(progressView)
            make.bottom.equalTo(-ARTAdaptedValue(10.0))
        }
        collectionButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.handleButtonTap(self.collectionButton)
        })
        .disposed(by: disposeBag)
    }
    
    private func setupSpeedButton() { // 创建倍数按钮
        speedButton = UIButton(type: .custom)
        speedButton.tag                     = ARTVideoPlayerControls.ButtonType.speed.rawValue
        speedButton.titleLabel?.font        = .art_medium(ARTAdaptedValue(12.0))
        speedButton.contentHorizontalAlignment = .right
        speedButton.setTitle("倍数", for: .normal)
        speedButton.setTitleColor(.art_color(withHEXValue: 0xFFFFFF), for: .normal)
        containerView.addSubview(speedButton)
        speedButton.snp.makeConstraints { make in
            make.size.equalTo(collectionButton)
            make.right.equalTo(collectionButton.snp.left)
            make.bottom.equalTo(collectionButton)
        }
        speedButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.handleButtonTap(self.speedButton)
        })
        .disposed(by: disposeBag)
    }
}
