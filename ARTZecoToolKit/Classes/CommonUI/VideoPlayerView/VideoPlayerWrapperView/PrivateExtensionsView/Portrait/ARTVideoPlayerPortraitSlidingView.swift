//
//  ARTVideoPlayerPortraitSlidingView.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/11/7.
//

import SnapKit

class ARTVideoPlayerPortraitSlidingView: UIView {
    
    /// 代理对象
    public weak var delegate: ARTVideoPlayerSlidingViewDelegate?
    
    /// 容器视图
    public var containerView: UIView!
    
    /// 容器高度
    private let containerHeight: CGFloat = ARTAdaptedValue(460.0) + art_safeAreaBottom()
    
    /// 初始Y坐标
    private var initialY: CGFloat = 0.0
    
    /// 容器底部约束
    private var containerViewBottomConstraint: Constraint?
    
    
    // MARK: - Initialization
    
    init(_ delegate: ARTVideoPlayerSlidingViewDelegate? = nil) {
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
        setupOverlayView()
        setupContainerView()
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
        
        // 设置初始位置在屏幕底部，并立即布局
        containerViewBottomConstraint?.update(offset: containerHeight)
        self.layoutIfNeeded()
        
        // 动画展示containerView
        containerViewBottomConstraint?.update(offset: 0)
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut]) {
            self.layoutIfNeeded()
        } completion: { _ in
            completion?()
        }
    }
    
    /// 移除动画视图
    ///
    /// - Parameter animated: 是否动画
    /// - Note: 重写父类方法，设置子视图布局
    func hideExtensionsView(_ completion: (() -> Void)? = nil) {
        containerViewBottomConstraint?.update(offset: containerHeight)
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut]) {
            self.layoutIfNeeded()
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
    @objc func handleSortingTapGesture(_ gesture: UITapGestureRecognizer) {
        hideExtensionsView()
    }
    
    @objc func handleSortingPanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: containerView)
        switch gesture.state {
        case .began:
            initialY = containerView.frame.origin.y
        case .changed:
            let newY = max(initialY + translation.y, UIScreen.art_currentScreenHeight - containerView.frame.height)
            containerView.frame.origin.y = newY
        case .ended, .cancelled:
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
    @objc func setupOverlayView() {
        let overlayView = UIView(frame: UIScreen.main.bounds)
        overlayView.backgroundColor = .art_color(withHEXValue: 0x000000, alpha: 0.2)
        addSubview(overlayView)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleSortingTapGesture(_:)))
        overlayView.addGestureRecognizer(tapRecognizer)
    }
    
    /// 创建容器视图
    @objc func setupContainerView() {
        containerView = UIView()
        containerView.backgroundColor     = .white
        containerView.layer.cornerRadius  = ARTAdaptedValue(18.0)
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(containerHeight)
            containerViewBottomConstraint = make.bottom.equalToSuperview().offset(containerHeight).constraint
        }
    }
}
