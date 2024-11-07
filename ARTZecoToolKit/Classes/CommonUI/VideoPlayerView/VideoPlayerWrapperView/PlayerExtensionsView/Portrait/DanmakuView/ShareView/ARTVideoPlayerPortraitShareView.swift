//
//  ARTVideoPlayerPortraitShareView.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/11/7.
//

open class ARTVideoPlayerPortraitShareView: UIView {
    
    /// 分享实例
    public var shareEntity = ARTVideoPlayerPortraitShareEntity()
    
    /// 列表视图
    public var collectionView: UICollectionView!

    /// 分享回调
    public var shareCallback: ((ARTVideoPlayerPortraitShareEntity.ShareOptionType) -> Void)?
    
    
    // MARK: - Initialization

    public init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Super Methods
    
    private func setupViews() {
        
        /// 设置列表视图
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator   = false
        collectionView.backgroundColor                = .clear
        collectionView.delegate                       = self
        collectionView.dataSource                     = self
        collectionView.bounces                        = false
        collectionView.contentInset                   = UIEdgeInsets(top: 0, left: ARTAdaptedValue(12.0), bottom: 0, right: ARTAdaptedValue(12.0))
        collectionView.registerCell(ARTVideoPlayerPortraitShareCell.self)
        collectionView.registerSectionHeader(ARTVideoPlayerPortraitShareHeader.self)
        collectionView.registerSectionFooter(ARTSectionFooterView.self)
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension ARTVideoPlayerPortraitShareView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shareEntity.shareOptions.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(for: indexPath) as ARTVideoPlayerPortraitShareCell
        cell.configureWithShareEntity(shareEntity.shareOptions[indexPath.item])
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return ARTAdaptedSize(width: 87.0, height: 100.0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let reusableView = ARTVideoPlayerPortraitShareHeader.dequeueHeader(from: collectionView, for: indexPath)
            return reusableView
        }
        let reusableView = ARTSectionFooterView.dequeueFooter(from: collectionView, for: indexPath)
        reusableView.backgroundColor = .clear
        return reusableView
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: ARTAdaptedValue(48.0))
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .zero
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        shareCallback?(shareEntity.shareOptions[indexPath.item].type)
    }
}
