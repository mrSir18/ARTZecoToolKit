//
//  ARTVideoPlayerPortraitSlidingView.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/11/7.
//

/// 协议方法
///
/// - NOTE: 可继承该协议方法
@objc public protocol ARTVideoPlayerPortraitSlidingViewDelegate: AnyObject {
    
}

open class ARTVideoPlayerPortraitSlidingView: UIView {
    
    /// 代理对象
    public weak var delegate: ARTVideoPlayerPortraitSlidingViewDelegate?
    
    /// 容器视图
    public var containerView: UIView!
    
    /// 容器高度
    public let containerHeight: CGFloat = ARTAdaptedValue(460.0) + art_safeAreaBottom()
    
    /// 初始Y坐标
    private var initialY: CGFloat = 0.0
    
    
    // MARK: - Initialization
    
    public init(_ delegate: ARTVideoPlayerPortraitSlidingViewDelegate? = nil) {
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
        setupOverlayView()
        setupContainerView()
    }
    
    
    // MARK: - Override Super Method
    
    /// 显示动画视图
    ///
    /// - Parameter animated: 是否动画
    /// - Note: 重写父类方法，设置子视图布局
    open func showExtensionsView(_ completion: (() -> Void)? = nil) {
        if self.superview == nil { // 判断视图是否已在父视图中
            art_keyWindow.addSubview(self)
            snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        art_keyWindow.bringSubviewToFront(self)
        self.isHidden = false
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut]) {
            self.containerView.transform = CGAffineTransformTranslate(self.containerView.transform, 0, -self.containerHeight)
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
            self.containerView.transform = CGAffineTransformTranslate(self.containerView.transform, 0, self.containerHeight)
        } completion: { _ in
            self.isHidden = true
            completion?()
        }
    }
    
    
    // MARK: - Gesture Recognizer
    
    /// 点击手势
    ///
    /// - Parameter gesture: 点击手势
    /// - Note: 重写父类方法，处理点击手势
    @objc open func handleSortingTapGesture(_ gesture: UITapGestureRecognizer) {
        hideExtensionsView()
    }
    
    /// 拖动手势
    ///
    /// - Parameter gesture: 拖动手势
    /// - Note: 重写父类方法，处理拖动手势
    @objc open func handleSortingPanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: containerView)
        switch gesture.state {
        case .began:
            initialY = containerView.frame.origin.y
        case .changed:
            let newY = max(initialY + translation.y, UIScreen.art_currentScreenHeight - containerView.frame.height)
            containerView.frame.origin.y = newY
        case .ended, .cancelled:
            // 根据手势速度确定是否收起containerView
            let velocity = gesture.velocity(in: containerView).y
            if velocity > 100.0 {
                UIView.animate(withDuration: 0.2) {
                    self.containerView.frame.origin.y = UIScreen.art_currentScreenHeight
                } completion: { finish in
                    if finish {
                        self.hideExtensionsView()
                    }
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.containerView.frame.origin.y = self.initialY
                }
            }
        default:
            break
        }
    }
}

// MARK: - Setup Initializer

extension ARTVideoPlayerPortraitSlidingView {
    
    /// 创建遮罩视图
    @objc open func setupOverlayView() {
        let overlayView = UIView(frame: UIScreen.main.bounds)
        overlayView.backgroundColor = .art_color(withHEXValue: 0x000000, alpha: 0.2)
        addSubview(overlayView)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleSortingTapGesture(_:)))
        overlayView.addGestureRecognizer(tapRecognizer)
    }
    
    /// 创建容器视图
    @objc open func setupContainerView() {
        containerView = UIView()
        containerView.backgroundColor     = .white
        containerView.layer.cornerRadius  = ARTAdaptedValue(18.0)
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalTo(UIScreen.art_currentScreenHeight)
            make.left.right.equalToSuperview()
            make.height.equalTo(containerHeight)
        }
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSortingPanGesture(_:)))
        containerView.addGestureRecognizer(panGesture)
    }
}
