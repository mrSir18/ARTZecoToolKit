//
//  ARTVideoPlayerLandscapePlaybackRateView+CollectionView.swift
//  ARTZeco
//
//  Created by mrSir18 on 2024/11/5.
//

import ARTZecoToolKit

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension ARTVideoPlayerLandscapePlaybackRateView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(for: indexPath) as ARTVideoPlayerLandscapePlaybackRateCell
        cell.updateCellBorderStyle(indexPath == shouldSelectedIndexPath)
        cell.configureWithRateContent(rates[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ARTAdaptedValue(108.0), height: ARTAdaptedValue(80.0))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return ARTAdaptedValue(14.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return ARTAdaptedValue(12.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let rate = Float(rates[indexPath.item]) else { return }
        shouldSelectedIndexPath = indexPath
        rateCallback?(rate)
        hideExtensionsView()
    }
}
