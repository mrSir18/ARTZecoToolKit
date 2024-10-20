//
//  ARTVideoPlayerWindowBottombar.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/10/15.
//

/// 协议方法
///
/// - NOTE: 可继承该协议方法
public protocol ARTVideoPlayerWindowBottombarDelegate: ARTVideoPlayerBottombarDelegate {
    
    /// 点击全屏按钮
    ///
    /// - Note: 子类实现该方法处理全屏操作
    func videoPlayerBottombarDidTapFullscreen(_ bottombar: ARTVideoPlayerWindowBottombar)
}

open class ARTVideoPlayerWindowBottombar: ARTVideoPlayerBottombar {
    
    /// 代理对象
    private weak var subclassDelegate: ARTVideoPlayerWindowBottombarDelegate?
    
    /// 容器视图
    private var containerView: UIView!
    
    /// 当前播放时间标签
    private var currentTimeLabel: UILabel!
    
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
        currentTimeLabel.text               = "00:00/00:00"
        currentTimeLabel.textAlignment      = .left
        currentTimeLabel.font               = .art_medium(ARTAdaptedValue(10.0))
        currentTimeLabel.textColor          = .art_color(withHEXValue: 0xFFFFFF)
        containerView.addSubview(currentTimeLabel)
        currentTimeLabel.snp.makeConstraints { make in
            make.left.equalTo(ARTAdaptedValue(12.0))
            make.top.equalTo(ARTAdaptedValue(6.0))
            make.height.equalTo(ARTAdaptedValue(12.0))
        }
    }
    
    private func setupFullscreenButton() { // 创建全屏按钮
        fullscreenButton = ARTAlignmentButton(type: .custom)
        fullscreenButton.imageAlignment     = .right
        fullscreenButton.titleAlignment     = .left
        fullscreenButton.imageSize          = ARTAdaptedSize(width: 20.0, height: 20.0)
        fullscreenButton.setImage(UIImage(named: "video_fullscreen"), for: .normal)
        fullscreenButton.addTarget(self, action: #selector(didTapFullscreenButton), for: .touchUpInside)
        containerView.addSubview(fullscreenButton)
        fullscreenButton.snp.makeConstraints { make in
            make.size.equalTo(ARTAdaptedSize(width: 60.0, height: 24.0))
            make.right.equalTo(-ARTAdaptedValue(12.0))
            make.centerY.equalTo(currentTimeLabel)
        }
    }
    
    private func setupProgressView() { // 创建进度条
        progressView = UIProgressView()
        progressView.trackTintColor         = .art_color(withHEXValue: 0xFFFFFF, alpha: 0.2)
        progressView.progressTintColor      = .art_color(withHEXValue: 0xFFFFFF, alpha: 0.2)
        progressView.progress               = 0.5
        progressView.layer.cornerRadius     = ARTAdaptedValue(1.0)
        progressView.layer.masksToBounds    = true
        containerView.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.left.equalTo(currentTimeLabel)
            make.bottom.equalTo(-ARTAdaptedValue(17.0))
            make.right.equalTo(fullscreenButton)
            make.height.equalTo(ARTAdaptedValue(3.0))
        }
    }
    
    private func setupSliderView() { // 创建滑块视图
        sliderView = ARTVideoPlayerSlider()
        sliderView.minimumValue = 0.0
        sliderView.maximumValue = 1.0
        sliderView.minimumTrackTintColor = .art_color(withHEXValue: 0xFFFFFF, alpha: 0.5)
        sliderView.trackHeight = ARTAdaptedValue(3.0)
        if let thumbImage = UIImage(named: "video_slider_thumb")?.art_scaled(to: ARTAdaptedSize(width: 7.0, height: 7.0)) {
            sliderView.setThumbImage(thumbImage, for: .normal)
        }
        containerView.addSubview(sliderView)
        sliderView.snp.makeConstraints { make in
            make.left.right.equalTo(progressView)
            make.centerY.equalTo(progressView)
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
        subclassDelegate?.videoPlayerBottombarDidTapFullscreen(self)
    }
    
    // MARK: - Override Super Methods
    
    open override func updatePlaybackTime(currentTime: String, duration: String) { // 更新底部工具栏的当前播放时间和总时长
        currentTimeLabel.text = "\(currentTime)/\(duration)"
    }
}
