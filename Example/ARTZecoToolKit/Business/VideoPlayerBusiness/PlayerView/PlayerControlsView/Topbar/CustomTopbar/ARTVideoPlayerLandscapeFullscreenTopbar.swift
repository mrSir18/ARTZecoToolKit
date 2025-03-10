//
//  ARTVideoPlayerLandscapeFullscreenTopbar.swift
//  ARTZeco
//
//  Created by mrSir18 on 2024/10/15.
//

import ARTZecoToolKit

class ARTVideoPlayerLandscapeFullscreenTopbar: ARTVideoPlayerTopbar {
    
    /// 标题标签
    private var titleLabel: UILabel!
    
    
    // MARK: - Override Super Methods
    
    override func setupViews() {
        super.setupViews()
        setupContainerView()
        setupBackButton()
        setupTitleLabel()
        setupShareButton()
        setupFavoriteButton()
        setupAnimation()
    }
}

// MARK: - Setup Initializer

extension ARTVideoPlayerLandscapeFullscreenTopbar {
    
    private func setupContainerView() { // 创建容器视图
        containerView = UIView()
        containerView.alpha = 0.0
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupBackButton() { // 创建返回按钮
        let leftInset = UIScreen.art_currentScreenIsIphoneX ? ARTAdaptedValue(54.0) : 0.0
        backButton = ARTAlignmentButton(type: .custom)
        backButton.tag                  = ARTVideoPlayerControls.ButtonType.back.rawValue
        backButton.imageAlignment       = .left
        backButton.titleAlignment       = .right
        backButton.contentInset         = ARTAdaptedValue(12.0)
        backButton.imageSize            = ARTAdaptedSize(width: 18.0, height: 18.0)
        backButton.setImage(UIImage(named: "icon_video_back_fullscreen"), for: .normal)
        containerView.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.left.equalTo(leftInset)
            make.top.equalToSuperview()
            make.width.equalTo(ARTAdaptedValue(52.0))
            make.height.equalToSuperview()
        }
        backButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.handleButtonTap(self.backButton)
        })
        .disposed(by: disposeBag)
    }
    
    private func setupTitleLabel() { // 创建标题标签
        titleLabel = UILabel()
        titleLabel.font                 = .art_medium(ARTAdaptedValue(15.0))
        titleLabel.textColor            = .white
        titleLabel.text                 = "轻松陪伴宝宝成长"
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(backButton.snp.left).offset(ARTAdaptedValue(34.0))
            make.centerY.equalTo(backButton)
            make.right.equalTo(snp.centerX)
        }
    }
    
    private func setupShareButton() { // 创建分享按钮
        let rightInset = UIScreen.art_currentScreenIsIphoneX ? ARTAdaptedValue(42.0) : 0.0
        shareButton = ARTAlignmentButton(type: .custom)
        shareButton.tag                 = ARTVideoPlayerControls.ButtonType.share.rawValue
        shareButton.imageAlignment      = .right
        shareButton.titleAlignment      = .left
        shareButton.contentInset        = ARTAdaptedValue(12.0)
        shareButton.imageSize           = ARTAdaptedSize(width: 19.0, height: 19.0)
        shareButton.setImage(UIImage(named: "icon_video_share_fullscreen"), for: .normal)
        containerView.addSubview(shareButton)
        shareButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.right.equalTo(-rightInset)
            make.width.equalTo(backButton)
            make.height.equalTo(backButton)
        }
        shareButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.handleButtonTap(self.shareButton)
        })
        .disposed(by: disposeBag)
    }
    
    private func setupFavoriteButton() { // 创建收藏按钮
        favoriteButton = ARTAlignmentButton(type: .custom)
        favoriteButton.tag              = ARTVideoPlayerControls.ButtonType.favorite.rawValue
        favoriteButton.isSelected       = true
        favoriteButton.imageAlignment   = .right
        favoriteButton.titleAlignment   = .left
        favoriteButton.imageSize        = ARTAdaptedSize(width: 19.0, height: 19.0)
        favoriteButton.setImage(UIImage(named: "icon_video_favorite_fullscreen"), for: .normal)
        favoriteButton.setImage(UIImage(named: "icon_video_favorited_fullscreen"), for: .selected)
        containerView.addSubview(favoriteButton)
        favoriteButton.snp.makeConstraints { make in
            make.top.bottom.equalTo(shareButton)
            make.right.equalTo(shareButton.snp.left)
            make.width.equalTo(shareButton)
        }
        favoriteButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.handleButtonTap(self.favoriteButton)
        })
        .disposed(by: disposeBag)
    }
    
    private func setupAnimation() { // 过度动画流畅
        UIView.animate(withDuration: 0.3) {
            self.containerView.alpha = 1.0
        }
    }
}
