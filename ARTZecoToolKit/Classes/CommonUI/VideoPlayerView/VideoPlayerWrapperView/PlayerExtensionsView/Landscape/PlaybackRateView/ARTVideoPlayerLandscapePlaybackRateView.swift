//
//  ARTVideoPlayerLandscapePlaybackRateView.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/11/4.
//

open class ARTVideoPlayerLandscapePlaybackRateView: ARTVideoPlayerLandscapeSlidingView {
    
    /// 默认选中的索引路径
    public var shouldSelectedIndexPath: IndexPath = IndexPath(item: 4, section: 0)
    
    /// 倍数数据
    public var rates: [String] = ["3.0", "2.0", "1.5", "1.25", "1.0", "0.5"]
    
    /// 回调事件
    public var rateCallback: ((_ rate: Float) -> Void)?
    
    
    // MARK: - Override Super Methods
    
    open override func setupViews() {
        super.setupViews()
        titleLabel.text = "倍速设置"
        setupCollectionView()
    }
    
    open override func handleSortingTapGesture(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: containerView)
        if !collectionView.frame.contains(location) && !restoreButton.frame.contains(location) {
            hideExtensionsView()
        }
    }
    
    // MARK: - Button Actions
    
    open override func didTapRestoreButton() { // 恢复按钮
        shouldSelectedIndexPath = IndexPath(item: 4, section: 0)
        rateCallback?(1.0)
        hideExtensionsView()
    }
    
    open override func showExtensionsView(_ completion: (() -> Void)? = nil) {
        super.showExtensionsView(completion)
        collectionView.reloadData()
    }
}

// MARK: - Setup Initializer

extension ARTVideoPlayerLandscapePlaybackRateView {
    
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
        collectionView.contentInset                   = UIEdgeInsets(top: 0, left: ARTAdaptedValue(8.0), bottom: 0, right: ARTAdaptedValue(8.0))
        collectionView.registerCell(ARTVideoPlayerLandscapePlaybackRateCell.self)
        containerView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(separatorLineView.snp.bottom).offset(ARTAdaptedValue(24.0))
            make.left.right.equalTo(separatorLineView)
            make.bottom.equalTo(-ARTAdaptedValue(24.0))
        }
    }
}
