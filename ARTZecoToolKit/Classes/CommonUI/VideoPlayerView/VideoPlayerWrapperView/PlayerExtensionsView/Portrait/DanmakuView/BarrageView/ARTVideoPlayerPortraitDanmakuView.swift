//
//  ARTVideoPlayerPortraitDanmakuView.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/11/7.
//

open class ARTVideoPlayerPortraitDanmakuView: ARTVideoPlayerPortraitSlidingView {
    
    /// 弹幕设置实例
    public var danmakuEntity = ARTVideoPlayerGeneralDanmakuEntity()
    
    /// 列表视图
    public var collectionView: UICollectionView!
    
    
    // MARK: - Override Super Methods
    
    open override func setupViews() {
        super.setupViews()
        setupCollectionView()
    }
}

// MARK: - Setup Initializer

extension ARTVideoPlayerPortraitDanmakuView {
    
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
        collectionView.registerCell(ARTVideoPlayerPortraitDanmakuCell.self)
        containerView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
//            make.top.equalTo(separatorLineView.snp.bottom).offset(ARTAdaptedValue(16.0))
//            make.left.right.equalTo(separatorLineView)
//            make.bottom.equalTo(-ARTAdaptedValue(16.0))
        }
    }
}

