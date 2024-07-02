//
//  ARTActionSheet.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/7/2.
//

import SnapKit

open class ARTActionSheet: UIView {
    
    /// 默认配置
    public let configuration = ARTActionSheetStyleConfiguration.default()
    
    /// 容器视图
    private var containerView: UIView!
    
    /// 初始Y坐标
    private var initialY: CGFloat = 0.0
    
    /// 按钮点击回调
    public var didSelectItemCallback: ((ARTAlertControllerMode) -> Void)?
    
    
    // MARK: - Life Cycle
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupViews() {
        enableAutoHeight()
        
        // 创建遮罩视图
        let overlayView = UIView(frame: UIScreen.main.bounds)
        overlayView.backgroundColor = .art_color(withHEXValue: 0x000000, alpha: 0.2)
        addSubview(overlayView)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        overlayView.addGestureRecognizer(tapGesture)
        
        // 创建容器视图
        let containerEntity  = configuration.containerEntity
        containerView = UIView()
        containerView.backgroundColor     = containerEntity.backgroundColor
        containerView.layer.cornerRadius  = containerEntity.radius
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalTo(overlayView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(containerEntity.height + art_safeAreaBottom())
        }
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        containerView.addGestureRecognizer(panGesture)
        
        // 创建分割线
        let lineEntity = configuration.lineEntity
        let separatorLineView = UIView()
        separatorLineView.isHidden              = lineEntity.showSeparatorLine
        separatorLineView.backgroundColor       = lineEntity.backgroundColor
        separatorLineView.layer.cornerRadius    = lineEntity.radius
        separatorLineView.layer.masksToBounds   = true
        addViewToContainer(separatorLineView)
        separatorLineView.snp.makeConstraints { make in
            make.size.equalTo(lineEntity.size)
            make.top.equalTo(ARTAdaptedValue(12.0))
            make.centerX.equalToSuperview()
        }
        
        // 创建列表视图
        let collectionEntity = configuration.collectionEntity
        let layout = ARTCollectionViewFlowLayout(self)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInsetAdjustmentBehavior   = .never
        collectionView.showsHorizontalScrollIndicator   = false
        collectionView.showsVerticalScrollIndicator     = false
        collectionView.backgroundColor                  = collectionEntity.backgroundColor
        collectionView.delegate                         = self
        collectionView.dataSource                       = self
        collectionView.contentInset                     = .zero
        collectionView.isScrollEnabled                  = collectionEntity.scrolling
        collectionView.layer.cornerRadius               = collectionEntity.radius
        collectionView.layer.masksToBounds              = true
        collectionView.registerCell(ARTActionSheetCell.self)
        containerView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(collectionEntity.contentInset)
        }
    }
    
    // MARK: - Private Methods (UIPanGestureRecognizer)
    
    @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        if configuration.containerEntity.allowDismissByTapOnBackground {
            hide()
        }
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        if !configuration.containerEntity.allowDismissByPullDown {
            return
        }
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
                        self.hide()
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
    
    /// 开启自动高度
    private func enableAutoHeight() {
        let containerEntity  = configuration.containerEntity
        let collectionEntity = configuration.collectionEntity
        let contentEntitys   = configuration.contentEntitys
        let cellHeight       = contentEntitys.reduce(0) { $0 + CGFloat($1.count) * collectionEntity.cellHeight }
        let autoHeight       = collectionEntity.contentInset.top + collectionEntity.headerSpacing * CGFloat(contentEntitys.count-1) + cellHeight + collectionEntity.contentInset.bottom
        if containerEntity.enableAutoHeight {
            configuration.containerEntity.height = max(0.0, round(autoHeight))
        }
    }
    
    // MARK: - Override Super Method
    
    /// 展示动画
    open func show() {
        keyWindow.addSubview(self)
        snp.makeConstraints { make in
            make.size.equalTo(CGSizeMake(UIScreen.art_currentScreenWidth,
                                         UIScreen.art_currentScreenHeight))
            make.left.top.equalToSuperview()
        }

        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            self.containerView.transform = CGAffineTransformTranslate(self.containerView.transform, 0, -self.configuration.containerEntity.height - art_safeAreaBottom())
        }
    }
    
    /// 隐藏动画
    open func hide() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return}
            self.containerView.transform = CGAffineTransformTranslate(self.containerView.transform, 0, self.configuration.containerEntity.height + art_safeAreaBottom())
        } completion: { [weak self] finish in
            guard let self = self else { return}
            self.removeFromSuperview()
        }
    }
}

// MARK: - Public Method

extension ARTActionSheet {
    
    /// 添加视图到容器视图
    public func addViewToContainer(_ view: UIView) {
        containerView.addSubview(view)
    }
}

