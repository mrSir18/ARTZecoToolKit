//
//  ARTPhotoBrowserViewController+CollectionView.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/7/15.
//

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension ARTPhotoBrowserViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(for: indexPath) as ARTPhotoBrowserCell
        cell.singleTapCallback = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
        }
        cell.loadImage(from: photos[indexPath.item])
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}

