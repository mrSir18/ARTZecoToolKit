//
//  ARTVideoPlayerLandscapeDanmakuView.swift
//  ARTZeco
//
//  Created by mrSir18 on 2024/11/4.
//

import ARTZecoToolKit

class ARTVideoPlayerLandscapeDanmakuView: ARTVideoPlayerLandscapeSlidingView {
    
    /// 弹幕设置实例
    public var danmakuEntity = ARTVideoPlayerGeneralDanmakuEntity()
    
    /// 触觉反馈发生器
    private var feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    
    // MARK: - Override Super Methods
    
    override func setupViews() {
        super.setupViews()
        feedbackGenerator.prepare() // 准备好触觉反馈
        titleLabel.text = "弹幕设置"
        setupCollectionView()
    }
    
    override func handleSortingTapGesture(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: containerView)
        if !collectionView.frame.contains(location) && !restoreButton.frame.contains(location) {
            hideExtensionsView()
        }
    }
    
    // MARK: - Button Actions
    
    override func didTapRestoreButton() { // 恢复按钮
        feedbackGenerator.impactOccurred()
        danmakuEntity.restoreDefaults()
        collectionView.reloadData()
        delegate?.slidingViewDidTapRestoreButton(for: danmakuEntity)
    }
    
    override func showExtensionsView(_ completion: (() -> Void)? = nil) {
        super.showExtensionsView(completion)
        collectionView.reloadData()
    }
}

// MARK: - Setup Initializer

extension ARTVideoPlayerLandscapeDanmakuView {
    
    /// 设置列表视图
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator   = false
        collectionView.backgroundColor                = .clear
        collectionView.delegate                       = self
        collectionView.dataSource                     = self
        collectionView.contentInset                   = .zero
        collectionView.registerCell(ARTVideoPlayerLandscapeDanmakuCell.self)
        containerView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(separatorLineView.snp.bottom).offset(ARTAdaptedValue(16.0))
            make.left.right.equalTo(separatorLineView)
            make.bottom.equalTo(-ARTAdaptedValue(16.0))
        }
    }
}
