//
//  ARTActionSheet+CollectionView.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/7/2.
//

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension ARTActionSheet: UICollectionViewDelegate, UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return configuration.contentEntitys.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return configuration.contentEntitys[section].count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(for: indexPath) as ARTActionSheetCell
        cell.configureWithContentItem(configuration.contentEntitys[indexPath.section][indexPath.item])
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let packedArray = configuration.contentEntitys.flatMap { $0 }
        let item = configuration.contentEntitys[indexPath.section][indexPath.item]
        guard let index = packedArray.firstIndex(where: { $0.text == item.text }) else { return }
        let mode = index < ARTAlertControllerMode.allCases.count ? ARTAlertControllerMode.allCases[index] : .custom(index + 1)
        self.didSelectItemCallback?(mode)
        self.hide()
    }
}

// MARK: - ARTCollectionViewDelegateFlowLayout

extension ARTActionSheet: ARTCollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, configModelForSectionAt section: Int) -> ARTCollectionViewConfigModel? {
        let entity: ARTCollectionViewConfigModel = ARTCollectionViewConfigModel()
        entity.cornerRadius     = configuration.collectionEntity.radius
        entity.backgroundColor  = configuration.collectionEntity.groupBackgroundColor
        return entity
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, spacingBetweenFooterAndNextHeaderForSectionAt section: Int) -> CGFloat {
        if section == 0 {
            return 0.0
        }
        return configuration.collectionEntity.headerSpacing
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, heightForItemAt indexPath: IndexPath) -> CGFloat {
        return configuration.collectionEntity.cellHeight
    }
}
