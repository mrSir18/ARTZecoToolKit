//
//  ARTVideoPlayerEpisodeSelectionView+CollectionView.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/11/5.
//

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension ARTVideoPlayerEpisodeSelectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return episodes.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(for: indexPath) as ARTVideoPlayerEpisodeSelectionCell
        cell.updateCellBorderStyle(indexPath == shouldSelectedIndexPath)
        cell.configureWithEpisodeContent(episodes[indexPath.item])
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: ARTAdaptedValue(48.0))
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        episodeCallback?(episodes[indexPath.item])
        hideExtensionsView()
    }
}
