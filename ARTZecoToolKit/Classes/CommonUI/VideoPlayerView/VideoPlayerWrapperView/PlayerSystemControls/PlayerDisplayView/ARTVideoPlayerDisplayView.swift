//
//  ARTVideoPlayerDisplayView.swift
//  Pods
//
//  Created by mrSir18 on 2024/10/21.
//

import AVFoundation

open class ARTVideoPlayerDisplayView: UIView {

    /// 容器视图
    private var containerView: ARTCustomView!
    
    /// 视频资源
    private var displayImageView: UIImageView!
    
    /// 当前播放时间标签
    private var currentTimeLabel: UILabel!
    
    /// 视频总时长标签
    private var durationLabel: UILabel!
    
    
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
    ///
    /// - Note: 由于子类需要自定义视图，所以需要重写该方法
    open func setupViews() {
        setupContainerView()
        setupDisplayImageView()
        setupCurrentTimeLabel()
        setupDurationLabel()
    }
    
    // MARK: - Public Methods
    
    /// 更新预览图片
    ///
    /// - Parameters:
    ///  - previewImage: 视频预览图片
    ///  - Note: 子类重写该方法更新预览图片
    open func updatePreviewImage(previewImage: UIImage?) {
        displayImageView.image = previewImage
    }
    
    /// 更新当前播放时间和总时长
    ///
    /// - Parameters:
    ///  - currentTime: 当前播放时间
    ///  - duration: 视频总时长
    ///  - Note: 重写此方法以更新底部工具栏的当前播放时间和总时长
    open func updatePlaybackTime(currentTime: CMTime, duration: CMTime) {
        self.isHidden = false
        currentTimeLabel.text  = currentTime.art_formattedTime()
        durationLabel.text     = "/\(duration.art_formattedTime())"
    }
}

// MARK: - Setup Initializer

extension ARTVideoPlayerDisplayView {
    
    private func setupContainerView() { // 创建容器视图
        containerView = ARTCustomView()
        containerView.customBackgroundColor = .art_color(withHEXValue: 0xD8D8D8)
        containerView.borderColor           = .art_color(withHEXValue: 0xFFFFFF)
        containerView.borderWidth           = 1.0
        containerView.cornerRadius          = ARTAdaptedValue(6.0)
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.size.equalTo(ARTAdaptedSize(width: 150.0, height: 84.0))
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-ARTAdaptedValue(12.0))
        }
    }
    
    private func setupDisplayImageView() { // 创建显示图片视图
        displayImageView = UIImageView()
        displayImageView.contentMode         = .scaleAspectFill
        displayImageView.layer.cornerRadius  = ARTAdaptedValue(6.0)
        displayImageView.layer.masksToBounds = true
        containerView.addSubview(displayImageView)
        displayImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(ARTAdaptedValue(1.0))
         }
    }
    
    private func setupCurrentTimeLabel() { // 创建当前播放时间标签
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
    
    private func setupDurationLabel() { // 创建视频总时长标签
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
