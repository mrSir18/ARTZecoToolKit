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
        let actualIndexPath = IndexPath(item: indexPath.item % realItemCount, section: indexPath.section) /// 计算实际索引，考虑循环滚动的情况.
        guard let cell = delegate?.collectionView(collectionView, cellForItemAt: actualIndexPath) else {
            return UICollectionViewCell()
        }
        return cell
    }

    // MARK: - UICollectionViewDelegate
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        resetScrollTimer() /// 重置定时器.
        let centerViewPoint = convert(collectionView.center, to: collectionView)
        guard let centerIndexPath = collectionView.indexPathForItem(at: centerViewPoint) else { return }
        if indexPath.item == centerIndexPath.item { /// 如果当前选中的是中心.
            let adjustedItem = indexPath.item % realItemCount
            let adjustedIndexPath = IndexPath(item: adjustedItem, section: indexPath.section)
            delegate?.collectionView?(collectionView, didSelectItemAt: adjustedIndexPath)
        } else { /// 如果当前选中的不是中心.
            let scrollPosition: UICollectionView.ScrollPosition
            switch scrollDirection {
            case .horizontal:
                scrollPosition = .centeredHorizontally
            case .vertical:
                scrollPosition = .centeredVertically
            @unknown default:
                scrollPosition = .centeredHorizontally /// 默认值，以防未处理的方向.
            }
            collectionView.scrollToItem(at: indexPath, at: scrollPosition, animated: true)
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return art_itemSize[indexPath.item % realItemCount]
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return art_minimumLineSpacing
    }
}

// MARK: - ARTCarouselFlowLayoutProtocol

extension ARTCarouselView: ARTCarouselFlowLayoutProtocol {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: ARTCarouselFlowLayout, scaleForItemAtIndexPath indexPath: IndexPath) -> CGFloat {
        return art_itemScale[indexPath.item % realItemCount]
    }
}
