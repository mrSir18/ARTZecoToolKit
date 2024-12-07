//
//  ARTVideoPlayerLandscapeSlidingView.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/11/4.
//

public class ARTVideoPlayerLandscapeSlidingView: UIView {
    
    /// 代理对象
    public weak var delegate: ARTVideoPlayerSlidingViewDelegate?
    
    /// 容器视图
    public var containerView: UIView!
    
    /// 标题标签
    public var titleLabel: UILabel!
    
    /// 恢复按钮
    public var restoreButton: ARTAlignmentButton!
    
    /// 分割线视图
    public var separatorLineView: ARTCustomView!
    
    /// 列表视图
    public var collectionView: UICollectionView!
    
    
    // MARK: - Initialization
    
    public init(_ delegate: ARTVideoPlayerSlidingViewDelegate? = nil) {
        super.init(frame: .zero)
        self.delegate = delegate
        self.backgroundColor = .clear
        setupViews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Super Methods
    
    /// 重写父类方法，设置子视图
    func setupViews() {
        setupContainerView()
        setupGradientView()
        setupSeparatorLineView()
        setupTitleLabel()
        setupRestoreButton()
        setupGestureRecognizer()
    }
    
    
    // MARK: - Override Super Method
    
    /// 显示动画视图
    ///
    /// - Parameter animated: 是否动画
    /// - Note: 重写父类方法，设置子视图布局
    func showExtensionsView(_ completion: (() -> Void)? = nil) {
        if self.superview == nil { // 判断视图是否已在父视图中
            art_keyWindow.addSubview(self)
            snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        art_keyWindow.bringSubviewToFront(self)
        self.isHidden = false
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut]) {
            self.containerView.transform = CGAffineTransformTranslate(self.containerView.transform, -UIScreen.art_currentScreenWidth, 0)
        } completion: { _ in
            completion?()
        }
    }
    
    /// 移除动画视图
    ///
    /// - Parameter animated: 是否动画
    /// - Note: 重写父类方法，设置子视图布局
    func hideExtensionsView(_ completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut]) {
            self.containerView.transform = CGAffineTransformTranslate(self.containerView.transform, UIScreen.art_currentScreenWidth, 0)
        } completion: { _ in
            self.isHidden = true
            completion?()
        }
    }
    
    // MARK: - Button Actions
    
    @objc func didTapRestoreButton() { // 恢复

    }
    
    // MARK: - Gesture Recognizer
    
    /// 点击手势
    ///
    /// - Parameter gesture: 点击手势
    /// - Note: 重写父类方法，处理点击手势
    @objc func handleSortingTapGesture(_ gesture: UITapGestureRecognizer) {
        hideExtensionsView()
    }
}

// MARK: - Setup Initializer

extension ARTVideoPlayerLandscapeSlidingView {
    
    /// 创建容器视图
    @objc private func setupContainerView() {
        containerView = UIView()
        containerView.backgroundColor = .clear
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(snp.right)
            make.width.equalTo(UIScreen.art_currentScreenWidth)
        }
    }
    
    /// 创建渐变视图
    @objc private func setupGradientView() {
        let gradientWidth: CGFloat = ARTAdaptedValue(660.0)+art_safeAreaBottom()
        let gradientView = UIView()
        gradientView.backgroundColor            = .clear
        gradientView.isUserInteractionEnabled   = false
        containerView.addSubview(gradientView)
        gradientView.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(gradientWidth)
        }
        gradientView.setNeedsLayout()
        gradientView.layoutIfNeeded()
        let gradient = CAGradientLayer()
        gradient.frame      = CGRect(x: 0.0,
                                     y: 0.0,
                                     width: gradientWidth,
                                     height: UIScreen.art_currentScreenHeight)
        gradient.startPoint = CGPoint(x: 0.11, y: 0.46)
        gradient.endPoint   = CGPoint(x: 0.81, y: 0.46)
        gradient.colors     = [
            UIColor.art_color(withHEXValue: 0x000000, alpha: 0.0).cgColor,
            UIColor.art_color(withHEXValue: 0x000000, alpha: 0.66).cgColor,
            UIColor.art_color(withHEXValue: 0x000000, alpha: 0.88).cgColor,
            UIColor.art_color(withHEXValue: 0x000000, alpha: 1.0).cgColor
        ]
        gradient.locations = [0.0, 0.65, 0.85, 1.0]
        gradientView.layer.addSublayer(gradient)
    }
    
    /// 设置分割线视图
    @objc private func setupSeparatorLineView() {
        separatorLineView = ARTCustomView()
        separatorLineView.customBackgroundColor = .art_color(withHEXValue: 0xD8D8D8, alpha: 0.2)
        containerView.addSubview(separatorLineView)
        separatorLineView.snp.makeConstraints { make in
            make.right.equalTo(-ARTAdaptedValue(16.0))
            make.top.equalTo(ARTAdaptedValue(44.0))
            make.width.equalTo(ARTAdaptedValue(246.0))
            make.height.equalTo(0.5)
        }
    }
    
    /// 设置标题标签
    @objc private func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.textAlignment      = .left
        titleLabel.font               = .art_medium(ARTAdaptedValue(13.0))
        titleLabel.textColor          = .art_color(withHEXValue: 0xFFFFFF)
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(separatorLineView.snp.left).offset(ARTAdaptedValue(12.0))
            make.top.equalTo(ARTAdaptedValue(12.0))
            make.height.equalTo(ARTAdaptedValue(18.0))
        }
    }
    
    /// 设置副标题标签
    @objc private func setupRestoreButton() {
        restoreButton = ARTAlignmentButton(type: .custom)
        restoreButton.contentInset      = ARTAdaptedValue(32.0)
        restoreButton.imageAlignment    = .right
        restoreButton.titleLabel?.font  = .art_regular(ARTAdaptedValue(11.0))
        restoreButton.setTitle("恢复", for: .normal)
        restoreButton.setTitleColor(.art_color(withHEXValue: 0xC8C8CC), for: .normal)
        restoreButton.addTarget(self, action: #selector(didTapRestoreButton), for: .touchUpInside)
        containerView.addSubview(restoreButton)
        restoreButton.snp.makeConstraints { make in
            make.top.right.equalToSuperview()
            make.bottom.equalTo(separatorLineView)
            make.width.equalTo(ARTAdaptedValue(90.0))
        }
    }
    
    /// 创建手势识别器
    @objc private func setupGestureRecognizer() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleSortingTapGesture(_:)))
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        tapRecognizer.cancelsTouchesInView = false // 允许触摸事件传递到子视图
        containerView.addGestureRecognizer(tapRecognizer)
    }
}
