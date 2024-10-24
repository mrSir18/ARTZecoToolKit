//
//  ARTVideoPlayerPortraitFullscreenBottombar.swift
//  Pods
//
//  Created by mrSir18 on 2024/10/17.
//

import AVFoundation

/// 协议方法
///
/// - NOTE: 可继承该协议方法
public protocol ARTVideoPlayerPortraitFullscreenBottombarDelegate: ARTVideoPlayerBottombarDelegate {
    
    
}

open class ARTVideoPlayerPortraitFullscreenBottombar: ARTVideoPlayerBottombar {
    
    /// 代理对象
    private weak var subclassDelegate: ARTVideoPlayerPortraitFullscreenBottombarDelegate?
    
    /// 容器视图
    private var containerView: UIView!
    
    /// 工具栏视图
    private var toolBarView: UIView!
    
    /// 标题标签
    private var titleLabel: UILabel!
    
    /// 描述标签
    private var descLabel: UILabel!
    
    /// 收藏按钮
    private var favoriteButton: ARTAlignmentButton!
    
    /// 评价按钮
    private var commentButton: ARTAlignmentButton!
    
    /// 弹幕按钮
    private var shareButton: ARTAlignmentButton!
    
    /// 更多按钮
    private var moreButton: ARTAlignmentButton!
    
    /// 弹幕设置按钮
    private var danmakuSettingsButton: ARTAlignmentButton!
    
    /// 弹幕输入框
    private var danmakuInputLabel: YYLabel!
    
    /// 清屏按钮
    private var clearButton: UIButton!
    
    /// 退出清屏按钮
    private var exitClearButton: ARTAlignmentButton!
    
    
    // MARK: - Initializatio
    
    public init(_ subclassDelegate: ARTVideoPlayerPortraitFullscreenBottombarDelegate? = nil) {
        self.subclassDelegate = subclassDelegate
        super.init(subclassDelegate)
        self.backgroundColor = .clear
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Super Methods
    
    open override func setupViews() {
        super.setupViews()
        setupContainerView()
        setupToolBarView()
        setupGradient()
        setupTitleLabel()
        setupDescLabel()
        setupProgressView()
        setupSliderView()
        setupFavoriteButton()
        setupCommentButton()
        setupShareButton()
        setupMoreButton()
        setupDanmakuSettingsButton()
        setupDanmakuInputField()
        setupClearButton()
        setupExitClearButton()
    }
    
    // MARK: - Button Actions
    
    /// 点击收藏按钮
    ///
    /// - Note: 子类实现该方法处理全屏操作
    @objc open func didTapFavoriteButton() {
        print("收藏")
    }
    
    /// 点击评论按钮
    ///
    /// - Note: 子类实现该方法处理全屏操作
    @objc open func didTapCommentButton() {
        print("评论")
    }
    
    /// 点击分享按钮
    ///
    /// - Note: 子类实现该方法处理全屏操作
    @objc open func didTapShareButton() {
        print("分享")
    }
    
    /// 点击更多按钮
    ///
    /// - Note: 子类实现该方法处理全屏操作
    @objc open func didTapMoreButton() {
        print("更多")
    }
    
    /// 点击弹幕设置按钮
    ///
    /// - Note: 子类实现该方法处理全屏操作
    @objc open func didTapDanmakuSettingsButton() {
        print("弹幕设置")
    }
    
    /// 点击发送弹幕按钮
    ///
    /// - Note: 子类实现该方法处理全屏操作
    @objc open func didTapDanmakuSendButton() {
        print("发送弹幕")
    }
    
    /// 点击清屏按钮
    ///
    /// - Note: 子类实现该方法处理全屏操作
    @objc open func didTapClearButton() {
        UIView.animate(withDuration: 0.25) {
            self.containerView.alpha = 0.0
            self.exitClearButton.alpha = 1.0
        }
        print("清屏")
    }
    
    /// 点击退出清屏按钮
    ///
    /// - Note: 子类实现该方法处理全屏操作
    @objc open func didTapExitClearButton() {
        UIView.animate(withDuration: 0.25) {
            self.exitClearButton.alpha = 0.0
            self.containerView.alpha = 1.0
        }
        print("退出清屏")
    }
    
    // MARK: - Override Super Methods
    
    open override func customizeSliderAppearance(trackHeight: CGFloat, cornerRadius: CGFloat, thumbSize: CGSize, duration: TimeInterval) { // 自定义滑块外观
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
}

// MARK: - Setup Initializer

extension ARTVideoPlayerPortraitFullscreenBottombar {
    
    private func setupContainerView() { // 创建容器视图
        containerView = UIView()
        containerView.backgroundColor = .clear
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupToolBarView() { // 创建工具栏视图
        toolBarView = UIView()
        toolBarView.backgroundColor = .black
        containerView.addSubview(toolBarView)
        toolBarView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(ARTAdaptedValue(40.0)+art_safeAreaBottom())
        }
    }
    
    private func setupGradient() { // 创建渐变色
        let gradientView = UIView()
        gradientView.backgroundColor            = .clear
        gradientView.isUserInteractionEnabled   = false
        containerView.addSubview(gradientView)
        gradientView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(ARTAdaptedValue(200.0))
        }
        let gradient = CAGradientLayer()
        gradient.frame      = CGRect(x: 0.0,
                                     y: 0.0,
                                     width: UIScreen.art_currentScreenWidth,
                                     height: ARTAdaptedValue(200.0))
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint   = CGPoint(x: 0.5, y: 1.0)
        gradient.colors     = [
            UIColor.art_color(withHEXValue: 0x000000, alpha: 0.0).cgColor,
            UIColor.art_color(withHEXValue: 0x000000, alpha: 1.0).cgColor
        ]
        gradient.locations = [0.0, 1.0]
        gradientView.layer.addSublayer(gradient)
        containerView.sendSubviewToBack(gradientView)
    }
    
    private func setupTitleLabel() { // 创建标题标签
        titleLabel = UILabel()
        titleLabel.text                 = "《新生儿科学喂养记录》套件"
        titleLabel.textAlignment        = .left
        titleLabel.font                 = .art_semibold(ARTAdaptedValue(16.0))
        titleLabel.textColor            = .art_color(withHEXValue: 0xFFFFFF)
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(ARTAdaptedValue(12.0))
            make.top.equalTo(ARTAdaptedValue(96.0))
            make.right.equalTo(-ARTAdaptedValue(97.0))
            make.height.equalTo(ARTAdaptedValue(22.0))
        }
    }
    
    private func setupDescLabel() { // 创建描述
        descLabel = UILabel()
        descLabel.text                  = "纸质记录表格可以放在家中显眼的地方，方便所有家庭成员查看和填写…"
        descLabel.textAlignment         = .left
        descLabel.font                  = .art_regular(ARTAdaptedValue(14.0))
        descLabel.textColor             = .art_color(withHEXValue: 0xFFFFFF)
        descLabel.numberOfLines         = 2
        containerView.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(ARTAdaptedValue(8.0))
            make.height.lessThanOrEqualTo(ARTAdaptedValue(40.0))
        }
    }
    
    private func setupFavoriteButton() { // 创建收藏按钮
        favoriteButton = ARTAlignmentButton(type: .custom)
        favoriteButton.isSelected           = true
        favoriteButton.titleLabel?.font     = .art_regular(ARTAdaptedValue(10.0))
        favoriteButton.imageAlignment       = .top
        favoriteButton.titleAlignment       = .bottom
        favoriteButton.imageTitleSpacing    = ARTAdaptedValue(4.0)
        favoriteButton.imageSize            = ARTAdaptedSize(width: 30.0, height: 30.0)
        favoriteButton.setTitle("收藏", for: .normal)
        favoriteButton.setTitleColor(.white, for: .normal)
        favoriteButton.setImage(UIImage(named: "video_favorite"), for: .normal)
        favoriteButton.setImage(UIImage(named: "video_favorited"), for: .selected)
        favoriteButton.addTarget(self, action: #selector(didTapFavoriteButton), for: .touchUpInside)
        containerView.addSubview(favoriteButton)
        favoriteButton.snp.makeConstraints { make in
            make.size.equalTo(ARTAdaptedSize(width: 50.0, height: 50.0))
            make.top.equalTo(ARTAdaptedValue(4.0))
            make.right.equalToSuperview()
        }
    }
    
    private func setupCommentButton() { // 创建评论按钮
        commentButton = ARTAlignmentButton(type: .custom)
        commentButton.titleLabel?.font      = .art_regular(ARTAdaptedValue(10.0))
        commentButton.imageAlignment        = .top
        commentButton.titleAlignment        = .bottom
        commentButton.imageTitleSpacing     = ARTAdaptedValue(4.0)
        commentButton.imageSize             = ARTAdaptedSize(width: 30.0, height: 30.0)
        commentButton.setTitle("3999", for: .normal)
        commentButton.setTitleColor(.white, for: .normal)
        commentButton.setImage(UIImage(named: "video_comment"), for: .normal)
        commentButton.addTarget(self, action: #selector(didTapCommentButton), for: .touchUpInside)
        containerView.addSubview(commentButton)
        commentButton.snp.makeConstraints { make in
            make.size.equalTo(favoriteButton)
            make.top.equalTo(favoriteButton.snp.bottom).offset(ARTAdaptedValue(8.0))
            make.right.equalToSuperview()
        }
    }
    
    private func setupShareButton() { // 创建分享按钮
        shareButton = ARTAlignmentButton(type: .custom)
        shareButton.titleLabel?.font        = .art_regular(ARTAdaptedValue(10.0))
        shareButton.imageAlignment          = .top
        shareButton.titleAlignment          = .bottom
        shareButton.imageTitleSpacing       = ARTAdaptedValue(4.0)
        shareButton.imageSize               = ARTAdaptedSize(width: 30.0, height: 30.0)
        shareButton.setTitle("399", for: .normal)
        shareButton.setTitleColor(.white, for: .normal)
        shareButton.setImage(UIImage(named: "video_share"), for: .normal)
        shareButton.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
        containerView.addSubview(shareButton)
        shareButton.snp.makeConstraints { make in
            make.size.equalTo(favoriteButton)
            make.top.equalTo(commentButton.snp.bottom).offset(ARTAdaptedValue(8.0))
            make.right.equalToSuperview()
        }
    }
    
    private func setupProgressView() { // 创建进度条
        containerView.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.bottom.equalTo(-ARTAdaptedValue(82.0))
            make.right.equalTo(-ARTAdaptedValue(12.0))
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
    
    private func setupMoreButton() { // 创建更多按钮
        moreButton = ARTAlignmentButton(type: .custom)
        moreButton.imageAlignment = .left
        moreButton.imageSize = ARTAdaptedSize(width: 30.0, height: 30.0)
        moreButton.setImage(UIImage(named: "video_more"), for: .normal)
        moreButton.addTarget(self, action: #selector(didTapMoreButton), for: .touchUpInside)
        toolBarView.addSubview(moreButton)
        moreButton.snp.makeConstraints { make in
            make.size.equalTo(ARTAdaptedSize(width: 42.0, height: 50.0))
            make.right.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
    
    private func setupDanmakuSettingsButton() { // 创建弹幕设置按钮
        danmakuSettingsButton = ARTAlignmentButton(type: .custom)
        danmakuSettingsButton.imageAlignment = .left
        danmakuSettingsButton.imageSize = ARTAdaptedSize(width: 30.0, height: 30.0)
        danmakuSettingsButton.setImage(UIImage(named: "video_danmaku_on_black"), for: .normal)
        danmakuSettingsButton.setImage(UIImage(named: "video_danmaku_off_black"), for: .selected)
        danmakuSettingsButton.addTarget(self, action: #selector(didTapDanmakuSettingsButton), for: .touchUpInside)
        toolBarView.addSubview(danmakuSettingsButton)
        danmakuSettingsButton.snp.makeConstraints { make in
            make.size.equalTo(moreButton)
            make.right.equalTo(moreButton.snp.left)
            make.centerY.equalTo(moreButton)
        }
    }
    
    private func setupDanmakuInputField() { // 创建弹幕输入框
        let inputView = UIView()
        inputView.backgroundColor           = .art_color(withHEXValue: 0x141414)
        inputView.layer.cornerRadius        = ARTAdaptedValue(6.0)
        inputView.layer.masksToBounds       = true
        toolBarView.addSubview(inputView)
        inputView.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.centerY.equalTo(moreButton)
            make.right.equalTo(danmakuSettingsButton.snp.left).offset(-ARTAdaptedValue(12.0))
            make.height.equalTo(ARTAdaptedValue(30.0))
        }
        
        danmakuInputLabel = YYLabel()
        danmakuInputLabel.font              = .art_regular(ARTAdaptedValue(12.0))
        danmakuInputLabel.textColor         = .art_color(withHEXValue: 0x646464)
        danmakuInputLabel.text              = "发一条友好的弹幕吧"
        danmakuInputLabel.textAlignment     = .left
        toolBarView.addSubview(danmakuInputLabel)
        danmakuInputLabel.snp.makeConstraints { make in
            make.top.bottom.equalTo(inputView)
            make.left.equalTo(inputView.snp.left).offset(ARTAdaptedValue(12.0))
            make.right.equalTo(inputView.snp.right).offset(-ARTAdaptedValue(12.0))
        }
        
        let danmakuSendButton = UIButton(type: .custom)
        danmakuSendButton.addTarget(self, action: #selector(didTapDanmakuSendButton), for: .touchUpInside)
        toolBarView.addSubview(danmakuSendButton)
        danmakuSendButton.snp.makeConstraints { make in
            make.edges.equalTo(inputView)
        }
    }
    
    private func setupClearButton() { // 创建清屏按钮
        clearButton = UIButton(type: .custom)
        clearButton.backgroundColor     = .art_color(withHEXValue: 0x000000, alpha: 0.5)
        clearButton.titleLabel?.font    = .art_regular(ARTAdaptedValue(10.0))
        clearButton.layer.cornerRadius  = ARTAdaptedValue(20.0)
        clearButton.layer.masksToBounds = true
        clearButton.setTitle("清屏", for: .normal)
        clearButton.setTitleColor(.white, for: .normal)
//        clearButton.setImage(UIImage(named: "video_clear"), for: .normal)
        clearButton.addTarget(self, action: #selector(didTapClearButton), for: .touchUpInside)
        containerView.addSubview(clearButton)
        clearButton.snp.makeConstraints { make in
            make.size.equalTo(ARTAdaptedSize(width: 40.0, height: 40.0))
            make.left.equalTo(titleLabel)
            make.bottom.equalTo(titleLabel.snp.top).offset(-ARTAdaptedValue(8.0))
        }
    }
    
    private func setupExitClearButton() { // 创建退出清屏按钮
        exitClearButton = ARTAlignmentButton(type: .custom)
        exitClearButton.alpha               = 0.0
        exitClearButton.backgroundColor     = .art_color(withHEXValue: 0x000000, alpha: 0.5)
        exitClearButton.titleLabel?.font    = .art_regular(ARTAdaptedValue(10.0))
        exitClearButton.layer.cornerRadius  = ARTAdaptedValue(20.0)
        exitClearButton.layer.masksToBounds = true
        exitClearButton.imageSize           = ARTAdaptedSize(width: 22.0, height: 22.0)
        exitClearButton.setImage(UIImage(named: "video_exit_clear"), for: .normal)
        exitClearButton.addTarget(self, action: #selector(didTapExitClearButton), for: .touchUpInside)
        addSubview(exitClearButton)
        exitClearButton.snp.makeConstraints { make in
            make.size.equalTo(ARTAdaptedSize(width: 40.0, height: 40.0))
            make.right.equalTo(-ARTAdaptedValue(12.0))
            make.bottom.equalTo(-art_safeAreaBottom())
        }
    }
}
