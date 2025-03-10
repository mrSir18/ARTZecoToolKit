//
//  ARTVideoPlayerWindowTopbar.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/10/15.
//

import ARTZecoToolKit

class ARTVideoPlayerWindowTopbar: ARTVideoPlayerTopbar {
    
    // MARK: - Override Super Methods
    
    override func setupViews() {
        super.setupViews()
        setupContainerView()
        setupBackButton()
        setupShareButton()
        setupFavoriteButton()
    }
}

// MARK: - Setup Initializer

extension ARTVideoPlayerWindowTopbar {
    
    private func setupContainerView() { // 创建容器视图
        containerView = UIView()
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupBackButton() { // 创建返回按钮
        backButton = ARTAlignmentButton(type: .custom)
        backButton.tag                  = ARTVideoPlayerControls.ButtonType.back.rawValue
        backButton.imageAlignment       = .left
        backButton.titleAlignment       = .right
        backButton.contentInset         = ARTAdaptedValue(12.0)
        backButton.imageSize            = ARTAdaptedSize(width: 18.0, height: 18.0)
        backButton.setImage(UIImage(named: "icon_video_back_fullscreen"), for: .normal)
        addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.left.top.bottom.equalTo(containerView)
            make.width.equalTo(ARTAdaptedValue(60.0))
        }
        backButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.handleButtonTap(self.backButton)
        })
        .disposed(by: disposeBag)
    }
    
    private func setupShareButton() { // 创建分享按钮
        shareButton = ARTAlignmentButton(type: .custom)
        shareButton.tag                 = ARTVideoPlayerControls.ButtonType.share.rawValue
        shareButton.imageAlignment      = .right
        shareButton.titleAlignment      = .left
        shareButton.contentInset        = ARTAdaptedValue(12.0)
        shareButton.imageSize           = ARTAdaptedSize(width: 19.0, height: 19.0)
        shareButton.setImage(UIImage(named: "icon_video_share_fullscreen"), for: .normal)
        containerView.addSubview(shareButton)
        shareButton.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(ARTAdaptedValue(51.0))
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
            make.top.bottom.equalToSuperview()
            make.right.equalTo(shareButton.snp.left)
            make.width.equalTo(shareButton)
        }
        favoriteButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.handleButtonTap(self.favoriteButton)
        })
        .disposed(by: disposeBag)
    }
}
