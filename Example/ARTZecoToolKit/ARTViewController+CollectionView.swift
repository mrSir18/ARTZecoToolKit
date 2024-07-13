//
//  ARTViewController+CollectionView.swift
//  ARTZecoToolKit_Example
//
//  Created by mrSir18 on 2024/7/13.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import ARTZecoToolKit

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension ARTViewController_CollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.collectionSections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.collectionSections[section].cellReuseIdentifiers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = viewModel.collectionSections[indexPath.section]
        let cellReuseIdentifier = section.cellReuseIdentifiers[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath)
        
        switch cell {
        case let collectionCell as ARTCollectionCell:
            if let firstSection = section as? ARTCollectionViewModel.FirstSection,
               let collectionEntity = firstSection.collectionEntity { // 数据源获取
                print("动态数据: \(collectionEntity.content)")
            }
            collectionCell.configureWithContent("ZECO", indexPath: indexPath)
        default:
            break
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = viewModel.collectionSections[indexPath.section]
        if kind == UICollectionView.elementKindSectionHeader {
            return configureHeader(for: section, in: collectionView, at: indexPath)
        } else if kind == UICollectionView.elementKindSectionFooter {
            return configureFooter(for: section, in: collectionView, at: indexPath)
        }
        return UICollectionReusableView()
    }
    
    private func configureHeader(for section: CollectionSectionProtocol, in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionReusableView {
        let reusableView = ARTCollectionHeader.dequeueHeader(from: collectionView, for: indexPath) // 根据结构类型动态自行配置头脚视图 switch section.sectionType { case .first: }
        if let header = reusableView as? ARTCollectionHeader {
            print("header \(header)")
        }
        return reusableView
    }
    
    private func configureFooter(for section: CollectionSectionProtocol, in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionReusableView {
        let reusableView = ARTCollectionFooter.dequeueFooter(from: collectionView, for: indexPath) // 根据结构类型动态自行配置头脚视图 switch section.sectionType { case .first: }
        if let footer = reusableView as? ARTCollectionFooter {
            print("footer \(footer)")
        }
        return reusableView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return viewModel.collectionSections[section].sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel.collectionSections[section].minimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel.collectionSections[section].minimumInteritemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return viewModel.collectionSections[section].headerSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return viewModel.collectionSections[section].footerSize
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelectItemAt: \(indexPath.section) - \(indexPath.item)")
    }
}

// MARK: - ARTCollectionViewDelegateFlowLayout

extension ARTViewController_CollectionView: ARTCollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, configModelForSectionAt section: Int) -> ARTCollectionViewConfigModel? {
        return viewModel.collectionSections[section].configModel
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, spacingBetweenFooterAndNextHeaderForSectionAt section: Int) -> CGFloat {
        return viewModel.collectionSections[section].spacingBetweenFooterAndNextHeader
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, columnForSectionAt section: Int) -> Int {
        return viewModel.collectionSections[section].column
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, heightForItemAt indexPath: IndexPath) -> CGFloat {
        return viewModel.collectionSections[indexPath.section].cellHeights[indexPath.item]
    }
}
