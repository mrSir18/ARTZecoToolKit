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
    
    private func setupTitleLabel() { // 创建标题标签
        titleLabel = UILabel()
        titleLabel.text                 = "《新生儿科学喂养记录》套件"
        titleLabel.textAlignment        = .left
        titleLabel.font                 = .art_semibold(ARTAdaptedValue(16.0))
        titleLabel.textColor            = .art_color(withHEXValue: 0xFFFFFF)
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(ARTAdaptedValue(12.0))
            make.top.equalTo(ARTAdaptedValue(76.0))
            make.right.equalTo(-ARTAdaptedValue(97.0))
            make.height.equalTo(ARTAdaptedValue(22.0))
        }
    }
    
    private func setupDescLabel() { // 创建描述
        descLabel = UILabel()
        descLabel.text                  = "纸质记录表格可以放在家中显眼的地方，方便纸质记录表格可以放在家中显眼的地方，方便所有家庭成员查看和填写…"
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
        favoriteButton.isSelected = false
        favoriteButton.layoutType = .freeform
        favoriteButton.imageAlignment = .topRight
        favoriteButton.imageEdgeInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: ARTAdaptedValue(12.0))
        favoriteButton.imageSize = ARTAdaptedSize(width: 30.0, height: 30.0)
        favoriteButton.setImage(UIImage(named: "video_favorite"), for: .normal)
        favoriteButton.setImage(UIImage(named: "video_favorited"), for: .selected)
        favoriteButton.addTarget(self, action: #selector(didTapFavoriteButton), for: .touchUpInside)
        containerView.addSubview(favoriteButton)
        favoriteButton.snp.makeConstraints { make in
            make.size.equalTo(ARTAdaptedSize(width: 54.0, height: 40.0))
            make.top.right.equalToSuperview()
        }
    }
    
    private func setupCommentButton() { // 创建评论按钮
        commentButton = ARTAlignmentButton(type: .custom)
        commentButton.imageAlignment = .right
        commentButton.contentInset = ARTAdaptedValue(12.0)
        commentButton.imageSize = ARTAdaptedSize(width: 30.0, height: 30.0)
        commentButton.setImage(UIImage(named: "video_comment"), for: .normal)
        commentButton.addTarget(self, action: #selector(didTapCommentButton), for: .touchUpInside)
        containerView.addSubview(commentButton)
        commentButton.snp.makeConstraints { make in
            make.top.equalTo(favoriteButton.snp.bottom).offset(ARTAdaptedValue(8.0))
            make.right.equalToSuperview()
            make.width.equalTo(favoriteButton)
            make.height.equalTo(ARTAdaptedValue(50.0))
        }
    }
    
    private func setupShareButton() { // 创建分享按钮
        shareButton = ARTAlignmentButton(type: .custom)
        shareButton.imageAlignment = .right
        shareButton.contentInset = ARTAdaptedValue(12.0)
        shareButton.imageSize = ARTAdaptedSize(width: 30.0, height: 30.0)
        shareButton.setImage(UIImage(named: "video_share"), for: .normal)
        shareButton.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
        containerView.addSubview(shareButton)
        shareButton.snp.makeConstraints { make in
            make.size.equalTo(commentButton)
            make.right.equalToSuperview()
            make.top.equalTo(commentButton.snp.bottom).offset(ARTAdaptedValue(8.0))
        }
    }
    
    private func setupProgressView() { // 创建进度条
        containerView.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.bottom.equalTo(-ARTAdaptedValue(76.0))
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
        containerView.addSubview(moreButton)
        moreButton.snp.makeConstraints { make in
            make.size.equalTo(ARTAdaptedSize(width: 42.0, height: 50.0))
            make.right.equalToSuperview()
            make.bottom.equalTo(-art_safeAreaBottom())
        }
    }
    
    private func setupDanmakuSettingsButton() { // 创建弹幕设置按钮
        danmakuSettingsButton = ARTAlignmentButton(type: .custom)
        danmakuSettingsButton.imageAlignment = .left
        danmakuSettingsButton.imageSize = ARTAdaptedSize(width: 30.0, height: 30.0)
        danmakuSettingsButton.setImage(UIImage(named: "video_danmaku_on_black"), for: .normal)
        danmakuSettingsButton.setImage(UIImage(named: "video_danmaku_off_black"), for: .selected)
        danmakuSettingsButton.addTarget(self, action: #selector(didTapDanmakuSettingsButton), for: .touchUpInside)
        containerView.addSubview(danmakuSettingsButton)
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
        containerView.addSubview(inputView)
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
