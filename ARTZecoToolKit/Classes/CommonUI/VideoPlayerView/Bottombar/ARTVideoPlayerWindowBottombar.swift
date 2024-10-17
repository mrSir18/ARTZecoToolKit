//
//  ARTVideoPlayerWindowBottombar.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/10/15.
//

class ARTVideoPlayerWindowBottombar: ARTVideoPlayerBottombar {
    
    /// 容器视图
    private var containerView: UIView!
    
    /// 当前播放时间标签
    private var currentTimeLabel: UILabel!
    
    /// 全屏按钮
    private var fullscreenButton: ARTAlignmentButton!
    
    /// 进度条
    private var progressView: UIProgressView!
    
    
    // MARK: - Override Super Methods
    
    override func setupViews() {
        super.setupViews()
        setupContainerView()
        setupCurrentTimeLabel()
        setupFullscreenButton()
        setupProgressView()
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
        currentTimeLabel.text               = "01:14/19:08"
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
        progressView.progressTintColor      = .art_color(withHEXValue: 0x00FF00)
        progressView.trackTintColor         = .art_color(withHEXValue: 0x666666)
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
    
    // MARK: - Button Actions
    
    /// 点击全屏按钮
    ///
    /// - Note: 子类实现该方法处理全屏操作
    @objc private func didTapFullscreenButton() {
        print("点击全屏按钮")
    }
}
