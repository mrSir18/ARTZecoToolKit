//
//  ARTVideoPlayerPortraitFullscreenTopbar.swift
//  Pods
//
//  Created by mrSir18 on 2024/10/17.
//

class ARTVideoPlayerPortraitFullscreenTopbar: ARTVideoPlayerTopbar {
    
    /// 容器视图
    private var containerView: UIView!
    
    /// 返回按钮
    private var backButton: ARTAlignmentButton!
    
    
    // MARK: - Override Super Methods
    
    override func setupViews() {
        super.setupViews()
        setupContainerView()
        setupBackButton()
    }
    
    // MARK: - Setup Methods
    
    private func setupContainerView() { // 创建容器视图
        containerView = UIView()
        containerView.alpha = 0.0
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalTo(art_statusBarHeight())
            make.left.bottom.right.equalToSuperview()
        }
    }
    
    private func setupBackButton() { // 创建返回按钮
        backButton = ARTAlignmentButton(type: .custom)
        backButton.imageAlignment       = .left
        backButton.titleAlignment       = .right
        backButton.contentInset         = ARTAdaptedValue(12.0)
        backButton.imageSize            = ARTAdaptedSize(width: 18.0, height: 18.0)
        backButton.setImage(UIImage(named: "video_back"), for: .normal)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.left.top.bottom.equalTo(containerView)
            make.width.equalTo(ARTAdaptedValue(60.0))
        }
    }
    
    private func setupAnimation() { // 过度动画流畅
        UIView.animate(withDuration: 0.25) {
            self.containerView.alpha = 1.0
        }
    }
}
