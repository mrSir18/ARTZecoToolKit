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
        return delegate?.collectionView(collectionView,
                                        cellForItemAt: IndexPath(item: indexPath.item % realItemCount, section: indexPath.section)) ?? UICollectionViewCell()
    }
    
    // MARK: - UICollectionViewDelegate
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        delegate?.collectionView?(collectionView, didSelectItemAt: indexPath)
        print("collectionView didSelectItemAt indexPath: \(indexPath.item % realItemCount)")
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
//    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return delegate?.collectionView?(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath) ?? .zero
//    }
//    
//    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return delegate?.collectionView?(collectionView, layout: collectionViewLayout, insetForSectionAt: section) ?? .zero
//    }
//    
//    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return delegate?.collectionView?(collectionView, layout: collectionViewLayout, minimumLineSpacingForSectionAt: section) ?? 0
//    }
//    
//    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return delegate?.collectionView?(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: section) ?? 0
//    }
}

// MARK: - ARTCarouselFlowLayoutProtocol

extension ARTCarouselView: ARTCarouselFlowLayoutProtocol {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: ARTCarouselFlowLayout, scaleForItemAtIndexPath indexPath: IndexPath) -> CGFloat {
        return delegate?.collectionView?(collectionView, layout: collectionViewLayout, scaleForItemAtIndexPath: indexPath) ?? 1.0
    }
}
