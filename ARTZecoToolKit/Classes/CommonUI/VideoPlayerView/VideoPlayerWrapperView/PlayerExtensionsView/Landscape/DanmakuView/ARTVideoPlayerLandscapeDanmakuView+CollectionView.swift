//
//  ARTVideoPlayerLandscapeDanmakuView+CollectionView.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/11/6.
//

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension ARTVideoPlayerLandscapeDanmakuView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return danmakuEntity.sliderOptions.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(for: indexPath) as ARTVideoPlayerLandscapeDanmakuCell
        cell.sliderValueChanged = { [weak self] value, shouldSave in
            guard let self = self else { return }
            if shouldSave {
                self.danmakuEntity.sliderOptions[indexPath.item].defaultValue = value
            }
        }
        cell.configureWithSliderOption(danmakuEntity.sliderOptions[indexPath.item])
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: ARTAdaptedValue(52.0))
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
