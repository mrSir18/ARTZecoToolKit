//
//  ARTVideoPlayerLandscapeFullscreenTopbar.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/10/15.
//

class ARTVideoPlayerLandscapeFullscreenTopbar: ARTVideoPlayerTopbar {
    
    /// 容器视图
    private var containerView: UIView!
    
    /// 返回按钮
    private var backButton: ARTAlignmentButton!
    
    /// 收藏按钮
    private var favoriteButton: ARTAlignmentButton!
    
    /// 分享按钮
    private var shareButton: ARTAlignmentButton!
    
    
    // MARK: - Override Super Methods
    
    override func setupViews() {
        super.setupViews()
        setupContainerView()
        setupBackButton()
        setupShareButton()
        setupFavoriteButton()
        setupAnimation()
    }
    
    // MARK: - Setup Methods
    
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
        backButton.imageAlignment       = .left
        backButton.titleAlignment       = .right
        backButton.contentInset         = ARTAdaptedValue(12.0)
        backButton.imageTitleSpacing    = ARTAdaptedValue(4.0)
        backButton.imageSize            = ARTAdaptedSize(width: 18.0, height: 18.0)
        backButton.setTitle("轻松陪伴宝宝成长", for: .normal)
        backButton.setImage(UIImage(named: "video_back"), for: .normal)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        containerView.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.left.equalTo(leftInset)
            make.top.equalToSuperview()
            make.right.equalTo(snp.centerX)
            make.height.equalToSuperview()
        }
    }
    
    private func setupShareButton() { // 创建分享按钮
        let rightInset = UIScreen.art_currentScreenIsIphoneX ? ARTAdaptedValue(42.0) : 0.0
        shareButton = ARTAlignmentButton(type: .custom)
        shareButton.imageAlignment      = .right
        shareButton.titleAlignment      = .left
        shareButton.contentInset        = ARTAdaptedValue(12.0)
        shareButton.imageSize           = ARTAdaptedSize(width: 19.0, height: 19.0)
        shareButton.setImage(UIImage(named: "video_share"), for: .normal)
        shareButton.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
        containerView.addSubview(shareButton)
        shareButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.right.equalTo(-rightInset)
            make.width.equalTo(ARTAdaptedValue(51.0))
            make.height.equalTo(backButton)
        }
    }
    
    private func setupFavoriteButton() { // 创建收藏按钮
        favoriteButton = ARTAlignmentButton(type: .custom)
        favoriteButton.imageAlignment   = .right
        favoriteButton.titleAlignment   = .left
        favoriteButton.imageSize        = ARTAdaptedSize(width: 19.0, height: 19.0)
        favoriteButton.setImage(UIImage(named: "video_favorite"), for: .normal)
        favoriteButton.addTarget(self, action: #selector(didTapFavoriteButton), for: .touchUpInside)
        containerView.addSubview(favoriteButton)
        favoriteButton.snp.makeConstraints { make in
            make.top.bottom.equalTo(shareButton)
            make.right.equalTo(shareButton.snp.left)
            make.width.equalTo(shareButton)
        }
    }
    
    private func setupAnimation() { // 过度动画流畅
        UIView.animate(withDuration: 0.3) {
            self.containerView.alpha = 1.0
        }
    }
}
