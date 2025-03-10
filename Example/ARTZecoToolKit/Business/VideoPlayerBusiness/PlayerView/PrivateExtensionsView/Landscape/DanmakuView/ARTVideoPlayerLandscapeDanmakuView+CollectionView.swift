//
//  ARTVideoPlayerLandscapeDanmakuView+CollectionView.swift
//  ARTZeco
//
//  Created by mrSir18 on 2024/11/6.
//

import ARTZecoToolKit

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension ARTVideoPlayerLandscapeDanmakuView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return danmakuEntity.sliderOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(for: indexPath) as ARTVideoPlayerLandscapeDanmakuCell
        cell.sliderValueChanged = { [weak self] value, shouldSave in
            guard let self = self else { return }
            if shouldSave {
                var option = self.danmakuEntity.sliderOptions[indexPath.item] // 更新滑块值
                option.defaultValue = value
                self.danmakuEntity.updateOption(at: indexPath.item, with: option) // 更新弹幕设置选项并保存
                self.delegate?.slidingViewDidSliderValueChanged(for: option) // 通知代理滑块值改变事件
            }
        }
        cell.configureWithSliderOption(danmakuEntity.sliderOptions[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: ARTAdaptedValue(52.0))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
