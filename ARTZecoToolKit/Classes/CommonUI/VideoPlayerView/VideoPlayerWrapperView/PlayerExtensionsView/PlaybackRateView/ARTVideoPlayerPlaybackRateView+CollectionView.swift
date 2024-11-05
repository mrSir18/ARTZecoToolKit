//
//  ARTVideoPlayerPlaybackRateView+CollectionView.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/11/5.
//

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension ARTVideoPlayerPlaybackRateView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rates.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(for: indexPath) as ARTVideoPlayerPlaybackRateCell
        cell.updateCellBorderStyle(indexPath == shouldSelectedIndexPath)
        cell.configureWithRateContent(rates[indexPath.item])
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ARTAdaptedValue(108.0), height: ARTAdaptedValue(80.0))
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return ARTAdaptedValue(14.0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return ARTAdaptedValue(12.0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let rate = Float(rates[indexPath.item]) else { return }
        shouldSelectedIndexPath = indexPath
        rateCallback?(rate)
        hideExtensionsView()
    }
}
