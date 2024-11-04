//
//  ARTVideoPlayerSlidingOverlayView.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/11/4.
//

/// 协议方法
///
/// - NOTE: 可继承该协议方法
@objc public protocol ARTVideoPlayerSlidingOverlayViewDelegate: AnyObject {
    
}

open class ARTVideoPlayerSlidingOverlayView: UIView {
    
    /// 代理对象
    public weak var delegate: ARTVideoPlayerSlidingOverlayViewDelegate?
    
    /// 容器视图
    public var containerView: UIView!
    
    
    // MARK: - Initialization
    
    public init(_ delegate: ARTVideoPlayerSlidingOverlayViewDelegate? = nil) {
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
    open func setupViews() {
        setupContainerView()
        setupGradientView()
        setupGestureRecognizer()
    }
    
    
    // MARK: - Override Super Method
    
    /// 显示动画视图
    ///
    /// - Parameter animated: 是否动画
    /// - Note: 重写父类方法，设置子视图布局
    open func showExtensionsView(_ completion: (() -> Void)? = nil) {
        art_keyWindow.addSubview(self)
        snp.makeConstraints { make in
            make.size.equalTo(CGSizeMake(UIScreen.art_currentScreenWidth,
                                         UIScreen.art_currentScreenHeight))
            make.left.top.equalToSuperview()
        }
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut]) {
            self.containerView.alpha = 1.0
        } completion: { _ in
            completion?()
        }
    }
    
    /// 移除动画视图
    ///
    /// - Parameter animated: 是否动画
    /// - Note: 重写父类方法，设置子视图布局
    open func hideExtensionsView(_ completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut]) {
            self.containerView.alpha = 0.0
        } completion: { _ in
            self.removeFromSuperview()
            completion?()
        }
    }
    
    /// 点击手势
    ///
    /// - Parameter gesture: 点击手势
    /// - Note: 重写父类方法，处理点击手势
    @objc open func handleSortingTapGesture(_ gesture: UITapGestureRecognizer) {
        hideExtensionsView()
    }
}

// MARK: - Setup Initializer

extension ARTVideoPlayerSlidingOverlayView {
    
    /// 创建容器视图
    @objc open func setupContainerView() {
        containerView = UIView()
        containerView.backgroundColor = .clear
        containerView.alpha = 0.0
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    /// 创建渐变视图
    @objc open func setupGradientView() {
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
    
    /// 创建手势识别器
    @objc open func setupGestureRecognizer() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleSortingTapGesture(_:)))
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        addGestureRecognizer(tapRecognizer)
    }
}
