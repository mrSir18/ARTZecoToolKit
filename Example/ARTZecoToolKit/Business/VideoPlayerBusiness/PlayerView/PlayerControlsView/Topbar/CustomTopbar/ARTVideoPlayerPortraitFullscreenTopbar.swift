//
//  ARTVideoPlayerPortraitFullscreenTopbar.swift
//  ARTZeco
//
//  Created by mrSir18 on 2024/10/17.
//

import ARTZecoToolKit

class ARTVideoPlayerPortraitFullscreenTopbar: ARTVideoPlayerTopbar {
    
    // MARK: - Override Super Methods
    
    override func setupViews() {
        super.setupViews()
        setupContainerView()
        setupBackButton()
    }
}

// MARK: - Setup Initializer

extension ARTVideoPlayerPortraitFullscreenTopbar {
    
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
        backButton.tag                  = ARTVideoPlayerControls.ButtonType.back.rawValue
        backButton.imageAlignment       = .left
        backButton.titleAlignment       = .right
        backButton.contentInset         = ARTAdaptedValue(12.0)
        backButton.imageSize            = ARTAdaptedSize(width: 18.0, height: 18.0)
        backButton.setImage(UIImage(named: "icon_video_back_fullscreen"), for: .normal)
        addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.left.top.bottom.equalTo(containerView)
            make.width.equalTo(ARTAdaptedValue(52.0))
        }
        backButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.handleButtonTap(self.backButton)
        })
        .disposed(by: disposeBag)
    }
}
