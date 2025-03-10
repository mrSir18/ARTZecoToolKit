//
//  ARTVideoPlayerPortraitFullscreenBottombar.swift
//  ARTZeco
//
//  Created by mrSir18 on 2024/10/17.
//

import AVFoundation
import ARTZecoToolKit

class ARTVideoPlayerPortraitFullscreenBottombar: ARTVideoPlayerBottombar {
    
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
    private var danmakuButton: ARTAlignmentButton!
    
    /// 弹幕输入框
    private var danmakuInputLabel: YYLabel!
    
    /// 退出清屏按钮视图
    private var exitClearView: UIView!
    
    /// 当前收藏状态
    private var isFavorited: Bool = false
    
    
    // MARK: - Override Super Methods
    
    override func setupViews() {
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
        setupDanmakuButton()
        setupDanmakuInputField()
        setupClearButton()
        setupExitClearButton()
        setupAnimation()
    }
    
    // MARK: - Override Super Methods
    
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
}

// MARK: - Public Methods

extension ARTVideoPlayerPortraitFullscreenBottombar {
    
    /// 更新收藏按钮状态
    /// - Parameter isFavorited: 是否已收藏
    public func updateFavoriteButtonImage(isFavorited: Bool) {
        self.isFavorited = isFavorited
        // 根据 isFavorited 更新按钮图片的代码
    }
}

// MARK: - Setup Initializer

extension ARTVideoPlayerPortraitFullscreenBottombar {
    
    private func setupContainerView() { // 创建容器视图
        containerView = UIView()
        containerView.backgroundColor = .clear
        containerView.alpha = 0.0
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
        favoriteButton.tag                  = ARTVideoPlayerControls.ButtonType.favorite.rawValue
        favoriteButton.titleLabel?.font     = .art_regular(ARTAdaptedValue(10.0))
        favoriteButton.imageAlignment       = .top
        favoriteButton.titleAlignment       = .bottom
        favoriteButton.imageTitleSpacing    = ARTAdaptedValue(4.0)
        favoriteButton.imageSize            = ARTAdaptedSize(width: 30.0, height: 30.0)
        favoriteButton.setTitle("收藏", for: .normal)
        favoriteButton.setTitleColor(.white, for: .normal)
        favoriteButton.setImage(UIImage(named: "icon_video_favorite_fullscreen"), for: .normal)
        favoriteButton.setImage(UIImage(named: "icon_video_favorited_fullscreen"), for: .selected)
        containerView.addSubview(favoriteButton)
        favoriteButton.snp.makeConstraints { make in
            make.size.equalTo(ARTAdaptedSize(width: 50.0, height: 50.0))
            make.top.equalTo(ARTAdaptedValue(4.0))
            make.right.equalToSuperview()
        }
        favoriteButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.favoriteButton.isSelected.toggle()
            self.handleButtonTap(self.favoriteButton)
        })
        .disposed(by: disposeBag)
    }
    
    private func setupCommentButton() { // 创建评论按钮
        commentButton = ARTAlignmentButton(type: .custom)
        commentButton.titleLabel?.font      = .art_regular(ARTAdaptedValue(10.0))
        commentButton.tag                   = ARTVideoPlayerControls.ButtonType.comment.rawValue
        commentButton.imageAlignment        = .top
        commentButton.titleAlignment        = .bottom
        commentButton.imageTitleSpacing     = ARTAdaptedValue(4.0)
        commentButton.imageSize             = ARTAdaptedSize(width: 30.0, height: 30.0)
        commentButton.setTitle("3999", for: .normal)
        commentButton.setTitleColor(.white, for: .normal)
        commentButton.setImage(UIImage(named: "icon_video_comment"), for: .normal)
        containerView.addSubview(commentButton)
        commentButton.snp.makeConstraints { make in
            make.size.equalTo(favoriteButton)
            make.top.equalTo(favoriteButton.snp.bottom).offset(ARTAdaptedValue(8.0))
            make.right.equalToSuperview()
        }
        commentButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.handleButtonTap(self.commentButton)
        })
        .disposed(by: disposeBag)
    }
    
    private func setupShareButton() { // 创建分享按钮
        shareButton = ARTAlignmentButton(type: .custom)
        shareButton.titleLabel?.font        = .art_regular(ARTAdaptedValue(10.0))
        shareButton.tag                     = ARTVideoPlayerControls.ButtonType.share.rawValue
        shareButton.imageAlignment          = .top
        shareButton.titleAlignment          = .bottom
        shareButton.imageTitleSpacing       = ARTAdaptedValue(4.0)
        shareButton.imageSize               = ARTAdaptedSize(width: 30.0, height: 30.0)
        shareButton.setTitle("399", for: .normal)
        shareButton.setTitleColor(.white, for: .normal)
        shareButton.setImage(UIImage(named: "icon_video_share_fullscreen"), for: .normal)
        containerView.addSubview(shareButton)
        shareButton.snp.makeConstraints { make in
            make.size.equalTo(favoriteButton)
            make.top.equalTo(commentButton.snp.bottom).offset(ARTAdaptedValue(8.0))
            make.right.equalToSuperview()
        }
        shareButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.handleButtonTap(self.shareButton)
        })
        .disposed(by: disposeBag)
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
        moreButton.tag                      = ARTVideoPlayerControls.ButtonType.more.rawValue
        moreButton.layoutType               = .freeform
        moreButton.imageAlignment           = .bottomLeft
        moreButton.imageSize                = ARTAdaptedSize(width: 30.0, height: 30.0)
        moreButton.setImage(UIImage(named: "icon_video_more"), for: .normal)
        toolBarView.addSubview(moreButton)
        moreButton.snp.makeConstraints { make in
            make.size.equalTo(ARTAdaptedSize(width: 42.0, height: 40.0))
            make.right.equalToSuperview()
            make.top.equalToSuperview()
        }
        moreButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.handleButtonTap(self.moreButton)
        })
        .disposed(by: disposeBag)
    }
    
    private func setupDanmakuButton() { // 创建弹幕开关按钮
        danmakuButton = ARTAlignmentButton(type: .custom)
        danmakuButton.tag                   = ARTVideoPlayerControls.ButtonType.danmakuToggle.rawValue
        danmakuButton.isSelected            = isDanmakuEnabled()
        danmakuButton.layoutType            = .freeform
        danmakuButton.imageAlignment        = .bottomLeft
        danmakuButton.imageSize             = ARTAdaptedSize(width: 30.0, height: 30.0)
        danmakuButton.setImage(UIImage(named: "icon_video_danmaku_off_black"), for: .normal)
        danmakuButton.setImage(UIImage(named: "icon_video_danmaku_on_black"), for: .selected)
        toolBarView.addSubview(danmakuButton)
        danmakuButton.snp.makeConstraints { make in
            make.size.equalTo(moreButton)
            make.right.equalTo(moreButton.snp.left)
            make.centerY.equalTo(moreButton)
        }
        danmakuButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.danmakuButton.isSelected = !self.danmakuButton.isSelected
            self.handleButtonTap(self.danmakuButton)
        })
        .disposed(by: disposeBag)
    }
    
    private func setupDanmakuInputField() { // 创建弹幕输入框
        let inputView = UIView()
        inputView.backgroundColor           = .art_color(withHEXValue: 0x141414)
        inputView.layer.cornerRadius        = ARTAdaptedValue(6.0)
        inputView.layer.masksToBounds       = true
        toolBarView.addSubview(inputView)
        inputView.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.bottom.equalTo(moreButton)
            make.right.equalTo(danmakuButton.snp.left).offset(-ARTAdaptedValue(12.0))
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
        danmakuSendButton.tag               = ARTVideoPlayerControls.ButtonType.danmakuSend.rawValue
        toolBarView.addSubview(danmakuSendButton)
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
    
    private func setupClearButton() { // 创建清屏按钮
        let clearContainerView = UIView()
        clearContainerView.backgroundColor      = .art_color(withHEXValue: 0x000000, alpha: 0.5)
        clearContainerView.layer.cornerRadius   = ARTAdaptedValue(17.0)
        clearContainerView.layer.masksToBounds  = true
        containerView.addSubview(clearContainerView)
        clearContainerView.snp.makeConstraints { make in
            make.size.equalTo(ARTAdaptedSize(width: 34.0, height: 34.0))
            make.bottom.equalTo(titleLabel.snp.top).offset(-ARTAdaptedValue(8.0))
            make.left.equalTo(ARTAdaptedValue(12.0))
        }
        
        let clearButton = ARTAlignmentButton(type: .custom)
        clearButton.imageSize = ARTAdaptedSize(width: 19.0, height: 19.0)
        clearButton.setImage(UIImage(named: "icon_video_clear"), for: .normal)
        clearContainerView.addSubview(clearButton)
        clearButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        clearButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.animateViewAlpha(containerAlpha: 0.0, exitClearViewAlpha: 1.0)
        })
        .disposed(by: disposeBag)
    }
    
    private func setupExitClearButton() { // 创建退出清屏按钮
        exitClearView = UIView()
        exitClearView.alpha                 = 0.0
        exitClearView.backgroundColor       = .art_color(withHEXValue: 0x000000, alpha: 0.5)
        exitClearView.layer.cornerRadius    = ARTAdaptedValue(17.0)
        exitClearView.layer.masksToBounds   = true
        addSubview(exitClearView)
        exitClearView.snp.makeConstraints { make in
            make.size.equalTo(ARTAdaptedSize(width: 34.0, height: 34.0))
            make.right.equalTo(-ARTAdaptedValue(12.0))
            make.bottom.equalTo(moreButton)
        }
        
        let exitClearButton = ARTAlignmentButton(type: .custom)
        exitClearButton.imageSize = ARTAdaptedSize(width: 19.0, height: 19.0)
        exitClearButton.setImage(UIImage(named: "icon_video_exit_clear"), for: .normal)
        exitClearView.addSubview(exitClearButton)
        exitClearButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        exitClearButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.animateViewAlpha(containerAlpha: 1.0, exitClearViewAlpha: 0.0)
        })
        .disposed(by: disposeBag)
    }
    
    private func setupAnimation() { // 过度动画流畅
        UIView.animate(withDuration: 0.3) {
            self.containerView.alpha = 1.0
        }
    }
    
    /// 通用的动画方法
    private func animateViewAlpha(containerAlpha: CGFloat, exitClearViewAlpha: CGFloat) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25) {
                self.containerView.alpha = containerAlpha
                self.exitClearView.alpha = exitClearViewAlpha
            }
        }
    }
}
