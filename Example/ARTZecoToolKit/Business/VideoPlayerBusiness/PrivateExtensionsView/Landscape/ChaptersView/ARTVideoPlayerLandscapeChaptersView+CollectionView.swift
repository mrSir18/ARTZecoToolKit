//
//  ARTVideoPlayerLandscapeChaptersView+CollectionView.swift
//  ARTZeco
//
//  Created by mrSir18 on 2024/11/5.
//

import ARTZecoToolKit

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension ARTVideoPlayerLandscapeChaptersView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chapters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(for: indexPath) as ARTVideoPlayerLandscapeChaptersCell
        cell.updateCellBorderStyle(indexPath == shouldSelectedIndexPath)
        cell.configureWithChapterContent(chapters[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: ARTAdaptedValue(48.0))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        chapterCallback?(chapters[indexPath.item])
        hideExtensionsView()
    }
}
