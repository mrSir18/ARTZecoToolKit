//
//  ARTVideoPlayerLandscapeChaptersView.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/11/4.
//

open class ARTVideoPlayerLandscapeChaptersView: ARTVideoPlayerSlidingOverlayView {
    
    /// 默认选中的索引路径
    public var shouldSelectedIndexPath: IndexPath = IndexPath(item: 0, section: 0)
    
    /// 目录数据
    public var chapters: [String] = ["第一部分：亲子游戏逻辑", "第二部分：游戏方法", "第三部分：亲子逻辑"]
    
    /// 回调事件
    public var chapterCallback: ((_ index: String) -> Void)?
    
    
    // MARK: - Override Super Methods
    
    open override func setupViews() {
        super.setupViews()
        titleLabel.text = "目录"
        restoreButton.isHidden = true
        setupCollectionView()
    }
    
    open override func handleSortingTapGesture(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: containerView)
        if !collectionView.frame.contains(location) {
            hideExtensionsView()
        }
    }
}

// MARK: - Setup Initializer

extension ARTVideoPlayerLandscapeChaptersView {
    
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
        collectionView.registerCell(ARTVideoPlayerLandscapeChaptersCell.self)
        containerView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(separatorLineView.snp.bottom)
            make.left.right.equalTo(separatorLineView)
            make.bottom.equalTo(-ARTAdaptedValue(12.0))
        }
    }
}
