//
//  ARTCitySelectorView+CollectionView.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/5/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension ARTCitySelectorView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.viewModel.layoutConfigs.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = viewModel.cityType(for: section)
        switch sectionType {
        case .hotCities:
            return self.viewModel.hotCities.count
        case .allCities:
            return self.viewModel.allCities.count
        default:
            return 0
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = viewModel.cityType(for: indexPath.section)
        switch sectionType {
        case .hotCities:
            let cell = collectionView.dequeueCell(for: indexPath) as ARTCitySelectorHotCell
            cell.isSelectedCity     = indexPath == self.viewModel.hotLastSelectedIndex
            cell.citySelectorEntity = self.viewModel.hotCities[indexPath.row]
            return cell
            
        case .allCities:
            let cell = collectionView.dequeueCell(for: indexPath) as ARTCitySelectorCell
            cell.isSelectedCity     = indexPath == self.viewModel.cityLastSelectedIndex
            cell.citySelectorEntity = self.viewModel.allCities[indexPath.row]
            return cell
        default:
            return UICollectionViewCell()
        }
    }

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let sectionType = viewModel.cityType(for: indexPath.section)
            if sectionType == .hotCities {
                let reusableView = ARTCitySelectorHotHeader.dequeueHeader(from: collectionView, for: indexPath)
                return reusableView
            }
            let reusableView = ARTSectionHeaderView.dequeueHeader(from: collectionView, for: indexPath)
            return reusableView
        } else {
            let reusableView = ARTSectionFooterView.dequeueFooter(from: collectionView, for: indexPath)
            return reusableView
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return self.viewModel.layoutConfigs[section].insets
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.viewModel.layoutConfigs[section].lineSpacing
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.viewModel.layoutConfigs[section].interitemSpacing
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return self.viewModel.layoutConfigs[section].headerSize
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return self.viewModel.layoutConfigs[section].footerSize
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.setContentOffset(CGPoint(x: 0, y: -collectionView.contentInset.top), animated: false)
        let sectionType = viewModel.cityType(for: indexPath.section)
        self.viewModel.addToOriginalAllCities(indexPath, 
                                              sectionType) { cityNames in
            self.headerView.updateCitySelectorHeader(cityNames)
        } completion: { historyCities, fullCityName in
            self.delegate?.citySelectorView?(self, didSelectItemAt: fullCityName)
            self.removeCitySelector()
        }
        collectionView.reloadData()
    }
}

// MARK: - ARTCollectionViewDelegateFlowLayout

extension ARTCitySelectorView: ARTCollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, columnForSectionAt section: Int) -> Int {
        return self.viewModel.layoutConfigs[section].columnCount
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, heightForItemAt indexPath: IndexPath) -> CGFloat {
        return self.viewModel.layoutConfigs[indexPath.section].itemHeight
    }
}
