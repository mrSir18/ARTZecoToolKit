//
//  ARTCarouselView+CollectionView.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/7/18.
//

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension ARTCarouselView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - UICollectionViewDataSource
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return expandedItemCount
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let actualIndexPath = IndexPath(item: indexPath.item % realItemCount, section: indexPath.section) /// 计算实际索引，考虑循环滚动的情况
        guard let cell = delegate?.collectionView(collectionView, cellForItemAt: actualIndexPath) else {
            return UICollectionViewCell()
        }
        return cell
    }

    // MARK: - UICollectionViewDelegate
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let centerViewPoint = convert(collectionView.center, to: collectionView)
        guard let centerIndexPath = collectionView.indexPathForItem(at: centerViewPoint) else { return }
        if indexPath.item == centerIndexPath.item {
            let adjustedItem = indexPath.item % realItemCount
            let adjustedIndexPath = IndexPath(item: adjustedItem, section: indexPath.section)
            delegate?.collectionView?(collectionView, didSelectItemAt: adjustedIndexPath)
        } else {
            let scrollPosition: UICollectionView.ScrollPosition
            switch scrollDirection {
            case .horizontal:
                scrollPosition = .centeredHorizontally
            case .vertical:
                scrollPosition = .centeredVertically
            @unknown default:
                scrollPosition = .centeredHorizontally // 默认值，以防未处理的方向
            }
            collectionView.scrollToItem(at: indexPath, at: scrollPosition, animated: true)
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return delegate?.collectionView?(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath) ?? .zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return delegate?.collectionView?(collectionView, layout: collectionViewLayout, minimumLineSpacingForSectionAt: section) ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return delegate?.collectionView?(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: section) ?? 0
    }
}

// MARK: - ARTCarouselFlowLayoutProtocol

extension ARTCarouselView: ARTCarouselFlowLayoutProtocol {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: ARTCarouselFlowLayout, scaleForItemAtIndexPath indexPath: IndexPath) -> CGFloat {
        return delegate?.collectionView?(collectionView, layout: collectionViewLayout, scaleForItemAtIndexPath: indexPath) ?? 1.0
    }
}
