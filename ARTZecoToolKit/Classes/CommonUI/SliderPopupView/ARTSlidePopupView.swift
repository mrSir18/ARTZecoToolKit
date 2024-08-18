//
//  ARTSlidePopupView.swift
//  Alamofire
//
//  Created by mrSir18 on 2024/5/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import SnapKit

open class ARTSlidePopupView: UIView, ARTSlidePopupHeaderViewProtocol {
    
    /// 默认配置
    public let configuration = ARTSlidePopupStyleConfiguration.default()
    
    /// 容器视图
    private var containerView: UIView!
    
    /// 头部视图视图
    private var headerView: ARTSlidePopupHeaderView!
    
    /// 初始Y坐标
    private var initialY: CGFloat = 0.0
    
    
    // MARK: - Life Cycle
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupViews() {
        
        // 创建遮罩视图
        let overlayView = UIView(frame: UIScreen.main.bounds)
        overlayView.backgroundColor = .art_color(withHEXValue: 0x000000, alpha: 0.2)
        addSubview(overlayView)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        overlayView.addGestureRecognizer(tapGesture)
        
        // 创建容器视图
        containerView = UIView()
        containerView.backgroundColor     = configuration.containerBackgroundColor
        containerView.layer.cornerRadius  = configuration.cornerRadius
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalTo(overlayView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(configuration.containerHeight + art_safeAreaBottom())
        }
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        containerView.addGestureRecognizer(panGesture)
        
        // 创建标题栏容器
        headerView = ARTSlidePopupHeaderView(self)
        containerView.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(configuration.headerHeight)
        }
    }
    
    // MARK: - Private Methods (UIPanGestureRecognizer)
    
    @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        hidePopupView()
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
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
                UIView.animate(withDuration: 0.2) { [weak self] in
                    guard let self = self else { return }
                    self.containerView.frame.origin.y = UIScreen.art_currentScreenHeight
                } completion: { [weak self] finish in
                    guard let self = self else { return }
                    if finish {
                        self.hidePopupView()
                    }
                }
            } else {
                UIView.animate(withDuration: 0.3) { [weak self] in
                    guard let self = self else { return }
                    self.containerView.frame.origin.y = self.initialY
                }
            }
        default:
            break
        }
    }
    
    // MARK: - ARTSlidePopupHeaderViewProtocol
    
    open func didTapPackUpButton(_ headerView: ARTSlidePopupHeaderView) {
        hidePopupView()
    }
    
    open func titleName(with headerView: ARTSlidePopupHeaderView) -> String {
        return ""
    }
    
    // MARK: - Override Super Method
    
    /// 展示动画
    open func showPopupView(_ completion: (() -> Void)? = nil) {
        art_keyWindow.addSubview(self)
        snp.makeConstraints { make in
            make.size.equalTo(CGSizeMake(UIScreen.art_currentScreenWidth,
                                         UIScreen.art_currentScreenHeight))
            make.left.top.equalToSuperview()
        }
        
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            self.containerView.transform = CGAffineTransformTranslate(self.containerView.transform, 0, -self.configuration.containerHeight - art_safeAreaBottom())
        } completion: { _ in
            completion?()
        }
    }
    
    /// 隐藏动画
    open func hidePopupView(_ completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return}
            self.containerView.transform = CGAffineTransformTranslate(self.containerView.transform, 0, self.configuration.containerHeight + art_safeAreaBottom())
        } completion: { [weak self] finish in
            guard let self = self else { return}
            self.removeFromSuperview()
            completion?()
        }
    }
}

// MARK: - Public Method

extension ARTSlidePopupView {
    
    /// 添加视图到容器视图
    public func addViewToContainer(_ view: UIView) {
        containerView.addSubview(view)
    }
    
    /// 移除头部视图
    public func removeHeaderView() {
        headerView.removeFromSuperview()
    }
}

