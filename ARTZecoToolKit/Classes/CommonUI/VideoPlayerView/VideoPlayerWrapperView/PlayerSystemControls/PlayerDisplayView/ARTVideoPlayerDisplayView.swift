//
//  ARTVideoPlayerDisplayView.swift
//  Pods
//
//  Created by mrSir18 on 2024/10/21.
//

import AVFoundation

open class ARTVideoPlayerDisplayView: UIView {
    
    /// 容器视图
    public var containerView: ARTCustomView!
    
    /// 视频资源
    public var displayImageView: UIImageView!
    
    /// 当前播放时间标签
    public var currentTimeLabel: UILabel!
    
    /// 视频总时长标签
    public var durationLabel: UILabel!
    
    
    // MARK: - Initialization
    
    public init() {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        self.isHidden = true
        setupViews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Super Methods
    
    /// 重写父类方法，设置子视图
    open func setupViews() {
        setupContainerView()
        setupDisplayImageView()
        setupCurrentTimeLabel()
        setupDurationLabel()
    }
    
    // MARK: - Public Methods
    
    /// 更新预览图片
    /// - Parameter previewImage: 视频预览图片
    open func updatePreviewImage(previewImage: UIImage?) {
        displayImageView.image = previewImage
    }

    /// 更新当前播放时间和总时长
    /// - Parameters:
    ///   - currentTime: 当前播放时间
    ///   - duration: 视频总时长
    open func updatePlaybackTime(currentTime: CMTime, duration: CMTime) {
        self.isHidden = false
        currentTimeLabel.text  = currentTime.art_formattedTime()
        durationLabel.text     = "/\(duration.art_formattedTime())"
    }

    /// 更新屏幕方向
    /// - Parameter screenOrientation: 屏幕方向
    open func updateScreenOrientation(screenOrientation: ScreenOrientation) {
        containerView.borderWidth = 1.0
        switch screenOrientation {
        case .window:
            containerView.snp.updateConstraints { make in
                make.size.equalTo(ARTAdaptedSize(width: 150.0, height: 84.0))
                make.bottom.equalTo(-ARTAdaptedValue(74.0))
            }
        case .landscapeFullScreen:
            containerView.snp.updateConstraints { make in
                make.size.equalTo(ARTAdaptedSize(width: 180.0, height: 102.0))
                make.bottom.equalTo(-ARTAdaptedValue(120.0))
            }
        case .portraitFullScreen:
            let bottomMargin = ARTAdaptedValue(240.0) + art_safeAreaBottom()
            containerView.snp.updateConstraints { make in
                make.size.equalTo(ARTAdaptedSize(width: 108.0, height: 190.0))
                make.bottom.equalTo(-bottomMargin)
            }
        }
    }

    /// 更新内容模式
    /// - Parameter isLandscape: 是否横屏
    open func updateContentMode(isLandscape: Bool) {
        displayImageView.contentMode = isLandscape ? .scaleAspectFill : .scaleAspectFit
    }
}

// MARK: - Setup Initializer

extension ARTVideoPlayerDisplayView {
    
    @objc open func setupContainerView() { // 创建容器视图
        containerView = ARTCustomView()
        containerView.customBackgroundColor = .black
        containerView.borderColor           = .art_color(withHEXValue: 0xFFFFFF)
        containerView.borderWidth           = 1.0
        containerView.cornerRadius          = ARTAdaptedValue(6.0)
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.size.equalTo(ARTAdaptedSize(width: 150.0, height: 84.0))
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-ARTAdaptedValue(74.0))
        }
    }
    
    @objc open func setupDisplayImageView() { // 创建显示图片视图
        displayImageView = UIImageView()
        displayImageView.contentMode         = .scaleAspectFill
        displayImageView.layer.cornerRadius  = ARTAdaptedValue(6.0)
        displayImageView.layer.masksToBounds = true
        containerView.addSubview(displayImageView)
        displayImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(ARTAdaptedValue(1.0))
        }
    }
    
    @objc open func setupCurrentTimeLabel() { // 创建当前播放时间标签
        currentTimeLabel = UILabel()
        currentTimeLabel.text               = "00:00"
        currentTimeLabel.textColor          = .art_color(withHEXValue: 0xFFFFFF)
        currentTimeLabel.font               = .art_medium(ARTAdaptedValue(14.0))
        currentTimeLabel.textAlignment      = .right
        addSubview(currentTimeLabel)
        currentTimeLabel.snp.makeConstraints { make in
            make.right.equalTo(snp.centerX).offset(-ARTAdaptedValue(2.0))
            make.top.equalTo(displayImageView.snp.bottom).offset(ARTAdaptedValue(10.0))
            make.height.equalTo(ARTAdaptedValue(20.0))
        }
    }
    
    @objc open func setupDurationLabel() { // 创建视频总时长标签
        durationLabel = UILabel()
        durationLabel.text                  = "/00:00"
        durationLabel.textColor             = .art_color(withHEXValue: 0xFFFFFF, alpha: 0.6)
        durationLabel.font                  = .art_medium(ARTAdaptedValue(14.0))
        durationLabel.textAlignment         = .left
        addSubview(durationLabel)
        durationLabel.snp.makeConstraints { make in
            make.left.equalTo(snp.centerX).offset(ARTAdaptedValue(2.0))
            make.top.equalTo(currentTimeLabel)
            make.height.equalTo(currentTimeLabel)
        }
    }
}
