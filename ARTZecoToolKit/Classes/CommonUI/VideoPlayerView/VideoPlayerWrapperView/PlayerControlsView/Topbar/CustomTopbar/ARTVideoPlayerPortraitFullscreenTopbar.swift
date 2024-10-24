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
        setupGradient()
        setupContainerView()
        setupBackButton()
    }
    
    // MARK: - Setup Methods
    
    private func setupGradient() { // 创建渐变色
        let gradientView = UIView()
        gradientView.backgroundColor            = .clear
        gradientView.isUserInteractionEnabled   = false
        addSubview(gradientView)
        gradientView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        gradientView.setNeedsLayout()
        gradientView.layoutIfNeeded()
        let gradient = CAGradientLayer()
        gradient.frame      = CGRect(x: 0.0,
                                     y: 0.0,
                                     width: UIScreen.art_currentScreenWidth,
                                     height: art_navigationFullHeight())
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint   = CGPoint(x: 0.5, y: 1.0)
        gradient.colors     = [
            UIColor.art_color(withHEXValue: 0x000000, alpha: 1.0).cgColor,
            UIColor.art_color(withHEXValue: 0x000000, alpha: 0.0).cgColor
        ]
        gradient.locations = [0.0, 1.0]
        gradientView.layer.addSublayer(gradient)
    }
    
    private func setupContainerView() { // 创建容器视图
        containerView = UIView()
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
}
