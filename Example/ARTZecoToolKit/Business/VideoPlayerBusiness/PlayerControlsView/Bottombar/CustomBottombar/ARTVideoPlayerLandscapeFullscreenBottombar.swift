//
//  ARTVideoPlayerLandscapeFullscreenBottombar.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/10/15.
//

import AVFoundation
import ARTZecoToolKit

/// 协议方法
///
/// - NOTE: 可继承该协议方法
protocol ARTVideoPlayerLandscapeFullscreenBottombarDelegate: ARTVideoPlayerBottombarDelegate {
    
    /// 当下一集按钮被点击时调用
    func bottombarDidTapNext(for bottombar: ARTVideoPlayerLandscapeFullscreenBottombar)
    
    /// 当倍数按钮被点击时调用
    func bottombarDidTapSpeed(for bottombar: ARTVideoPlayerLandscapeFullscreenBottombar)
    
    /// 当合集按钮被点击时调用
    func bottombarDidTapCatalogue(for bottombar: ARTVideoPlayerLandscapeFullscreenBottombar)
}

class ARTVideoPlayerLandscapeFullscreenBottombar: ARTVideoPlayerBottombar {
    
    /// 代理对象
    weak var subclassDelegate: ARTVideoPlayerLandscapeFullscreenBottombarDelegate?
    
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
    
    
    // MARK: - Initializatio
    
    init(_ subclassDelegate: ARTVideoPlayerLandscapeFullscreenBottombarDelegate? = nil) {
        self.subclassDelegate = subclassDelegate
        super.init(subclassDelegate)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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

// MARK: - Button Actions

extension ARTVideoPlayerLandscapeFullscreenBottombar {
    
    /// 点击暂停按钮
    @objc func didTapPauseButton() {
        pauseButton.isSelected.toggle()
        delegate?.bottombarDidTapPause(for: self, isPlaying: pauseButton.isSelected)
    }
    
    /// 点击下一集按钮
    @objc func didTapNextButton() {
        subclassDelegate?.bottombarDidTapNext(for: self)
    }
    
    /// 点击弹幕按钮
    @objc func didTapDanmakuButton() {
        danmakuButton.isSelected = !danmakuButton.isSelected
        delegate?.bottombarDidTapDanmakuToggle(for: self, isDanmakuEnabled: danmakuButton.isSelected)
    }
    
    /// 点击弹幕设置按钮
    @objc func didTapDanmakuSettingsButton() {
        delegate?.bottombarDidTapDanmakuSettings(for: self)
    }
    
    /// 点击发送弹幕按钮
    @objc func didTapDanmakuSendButton() {
        guard let text = danmakuInputLabel.text else { return }
        delegate?.bottombarDidTapDanmakuSend(for: self, text: text)
    }
    
    /// 点击倍数按钮
    @objc func didTapSpeedButton() {
        subclassDelegate?.bottombarDidTapSpeed(for: self)
    }
    
    /// 点击目录按钮
    @objc func didTapCatalogueButton() {
        subclassDelegate?.bottombarDidTapCatalogue(for: self)
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
        pauseButton.imageAlignment = .left
        pauseButton.imageSize = ARTAdaptedSize(width: 20.0, height: 20.0)
        pauseButton.setImage(UIImage(named: "video_pause"), for: .normal)
        pauseButton.setImage(UIImage(named: "video_play"), for: .selected)
        pauseButton.addTarget(self, action: #selector(didTapPauseButton), for: .touchUpInside)
        containerView.addSubview(pauseButton)
        pauseButton.snp.makeConstraints { make in
            make.size.equalTo(ARTAdaptedSize(width: 36.0, height: 36.0))
            make.bottom.equalTo(-ARTAdaptedValue(12.0))
            make.left.equalTo(currentTimeLabel.snp.left).offset(-ARTAdaptedValue(4.0))
        }
    }
    
    private func setupNextButton() { // 创建下一集按钮
        nextButton = ARTAlignmentButton(type: .custom)
        nextButton.imageAlignment = .left
        nextButton.imageSize = ARTAdaptedSize(width: 18.0, height: 17.0)
        nextButton.setImage(UIImage(named: "video_next_episode"), for: .normal)
        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        containerView.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.size.equalTo(pauseButton)
            make.left.equalTo(pauseButton.snp.right)
            make.centerY.equalTo(pauseButton)
        }
    }
    
    private func setupDanmakuButton() { // 创建弹幕按钮
        danmakuButton = ARTAlignmentButton(type: .custom)
        danmakuButton.isSelected = isDanmakuEnabled()
        danmakuButton.imageAlignment = .left
        danmakuButton.imageSize = ARTAdaptedSize(width: 23.0, height: 23.0)
        danmakuButton.setImage(UIImage(named: "video_danmaku_off"), for: .normal)
        danmakuButton.setImage(UIImage(named: "video_danmaku_on"), for: .selected)
        danmakuButton.addTarget(self, action: #selector(didTapDanmakuButton), for: .touchUpInside)
        containerView.addSubview(danmakuButton)
        danmakuButton.snp.makeConstraints { make in
            make.size.equalTo(pauseButton)
            make.left.equalTo(nextButton.snp.right)
            make.centerY.equalTo(pauseButton)
        }
    }
    
    private func setupDanmakuSettingsButton() { // 创建弹幕设置按钮
        danmakuSettingsButton = ARTAlignmentButton(type: .custom)
        danmakuSettingsButton.imageAlignment = .left
        danmakuSettingsButton.imageSize = ARTAdaptedSize(width: 23.0, height: 23.0)
        danmakuSettingsButton.setImage(UIImage(named: "video_danmaku_settings"), for: .normal)
        danmakuSettingsButton.addTarget(self, action: #selector(didTapDanmakuSettingsButton), for: .touchUpInside)
        containerView.addSubview(danmakuSettingsButton)
        danmakuSettingsButton.snp.makeConstraints { make in
            make.size.equalTo(pauseButton)
            make.left.equalTo(danmakuButton.snp.right)
            make.centerY.equalTo(pauseButton)
        }
    }
    
    private func setupDanmakuInputField() { // 创建弹幕输入框
        let inputView = UIView()
        inputView.backgroundColor       = .art_color(withHEXValue: 0xD8D8D8, alpha: 0.3)
        inputView.layer.cornerRadius    = ARTAdaptedValue(14.0)
        inputView.layer.masksToBounds   = true
        containerView.addSubview(inputView)
        inputView.snp.makeConstraints { make in
            make.size.equalTo(ARTAdaptedSize(width: 163.0, height: 28.0))
            make.left.equalTo(danmakuSettingsButton.snp.right).offset(ARTAdaptedValue(24.0))
            make.centerY.equalTo(pauseButton)
        }
        
        danmakuInputLabel = YYLabel()
        danmakuInputLabel.font            = .art_regular(ARTAdaptedValue(12.0))
        danmakuInputLabel.textColor       = .art_color(withHEXValue: 0xFFFFFF)
        danmakuInputLabel.text            = "发一条友好的弹幕吧"
        danmakuInputLabel.textAlignment   = .center
        containerView.addSubview(danmakuInputLabel)
        danmakuInputLabel.snp.makeConstraints { make in
            make.top.bottom.equalTo(inputView)
            make.left.equalTo(inputView.snp.left).offset(ARTAdaptedValue(12.0))
            make.right.equalTo(inputView.snp.right).offset(-ARTAdaptedValue(12.0))
        }
        
        let danmakuSendButton = UIButton(type: .custom)
        danmakuSendButton.addTarget(self, action: #selector(didTapDanmakuSendButton), for: .touchUpInside)
        containerView.addSubview(danmakuSendButton)
        danmakuSendButton.snp.makeConstraints { make in
            make.edges.equalTo(inputView)
        }
    }
    
    private func setupCatalogueButton() { // 创建合集按钮
        collectionButton = UIButton(type: .custom)
        collectionButton.titleLabel?.font = .art_medium(ARTAdaptedValue(12.0))
        collectionButton.contentHorizontalAlignment = .right
        collectionButton.setTitle("目录", for: .normal)
        collectionButton.setTitleColor(.art_color(withHEXValue: 0xFFFFFF), for: .normal)
        collectionButton.addTarget(self, action: #selector(didTapCatalogueButton), for: .touchUpInside)
        containerView.addSubview(collectionButton)
        collectionButton.snp.makeConstraints { make in
            make.size.equalTo(ARTAdaptedSize(width: 44.0, height: 37.0))
            make.right.equalTo(progressView)
            make.bottom.equalTo(-ARTAdaptedValue(10.0))
        }
    }
    
    private func setupSpeedButton() { // 创建全屏按钮
        speedButton = UIButton(type: .custom)
        speedButton.titleLabel?.font = .art_medium(ARTAdaptedValue(12.0))
        speedButton.contentHorizontalAlignment = .right
        speedButton.setTitle("倍数", for: .normal)
        speedButton.setTitleColor(.art_color(withHEXValue: 0xFFFFFF), for: .normal)
        speedButton.addTarget(self, action: #selector(didTapSpeedButton), for: .touchUpInside)
        containerView.addSubview(speedButton)
        speedButton.snp.makeConstraints { make in
            make.size.equalTo(collectionButton)
            make.right.equalTo(collectionButton.snp.left)
            make.bottom.equalTo(collectionButton)
        }
    }
}
