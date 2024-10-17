//
//  ARTVideoPlayerFullscreenTopbar.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/10/15.
//

class ARTVideoPlayerFullscreenTopbar: ARTVideoPlayerTopbar {
    
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
    }
    
    // MARK: - Setup Methods
    
    private func setupContainerView() { // 创建容器视图
        containerView = UIView()
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupBackButton() { // 创建返回按钮
        backButton = ARTAlignmentButton(type: .custom)
        backButton.imageAlignment       = .left
        backButton.titleAlignment       = .right
        backButton.contentInset         = ARTAdaptedValue(12.0)
        backButton.imageSize            = ARTAdaptedSize(width: 20.0, height: 20.0)
        backButton.setTitle("轻松陪伴宝宝成长", for: .normal)
        backButton.setImage(UIImage(named: "video_back"), for: .normal)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        containerView.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.left.equalTo(art_statusBarHeight())
            make.top.equalToSuperview()
            make.right.equalTo(snp.centerX)
            make.height.equalTo(ARTAdaptedValue(64.0))
        }
    }
    
    private func setupShareButton() { // 创建分享按钮
        shareButton = ARTAlignmentButton(type: .custom)
        shareButton.imageAlignment      = .right
        shareButton.titleAlignment      = .left
        shareButton.contentInset        = ARTAdaptedValue(24.0)
        shareButton.imageSize           = ARTAdaptedSize(width: 24.0, height: 24.0)
        shareButton.setImage(UIImage(named: "video_share"), for: .normal)
        shareButton.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
        containerView.addSubview(shareButton)
        shareButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.right.equalTo(-ARTAdaptedValue(52.0))
            make.width.equalTo(ARTAdaptedValue(72.0))
            make.height.equalTo(backButton)
        }
    }
    
    private func setupFavoriteButton() { // 创建收藏按钮
        favoriteButton = ARTAlignmentButton(type: .custom)
        favoriteButton.imageAlignment   = .right
        favoriteButton.titleAlignment   = .left
        favoriteButton.imageSize        = ARTAdaptedSize(width: 24.0, height: 24.0)
        favoriteButton.setImage(UIImage(named: "video_favorite"), for: .normal)
        favoriteButton.addTarget(self, action: #selector(didTapFavoriteButton), for: .touchUpInside)
        containerView.addSubview(favoriteButton)
        favoriteButton.snp.makeConstraints { make in
            make.top.bottom.equalTo(shareButton)
            make.right.equalTo(shareButton.snp.left)
            make.width.equalTo(shareButton)
        }
    }
}
