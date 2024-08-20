//
//  ARTViewController_CollectionView.swift
//  ARTZecoToolKit_Example
//
//  Created by mrSir18 on 2024/7/13.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import ARTZecoToolKit

class ARTViewController_CollectionView: ARTBaseViewController {
    
    // 视图模型
    var viewModel: ARTCollectionViewModel!
    
    // 列表视图
    private var collectionView: UICollectionView!
    
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 创建列表视图
        let layout = ARTCollectionViewFlowLayout(self)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInsetAdjustmentBehavior       = .never
        collectionView.showsHorizontalScrollIndicator       = false
        collectionView.showsVerticalScrollIndicator         = false
        collectionView.backgroundColor                      = .art_randomColor()
        collectionView.delegate                             = self
        collectionView.dataSource                           = self
        collectionView.contentInset                         = UIEdgeInsets(top: ARTAdaptedValue(12.0), left: 0.0, bottom: art_safeAreaBottom(), right: 0.0)
        collectionView.registerCell(ARTCollectionCell.self)
        collectionView.registerSectionHeader(ARTCollectionHeader.self)
        collectionView.registerSectionFooter(ARTCollectionFooter.self)
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(baseContainerView.snp.bottom)
        }
        
        //TODO: 临时数据测试属性
        viewModel = ARTCollectionViewModel()
        viewModel.loadData { [weak self] in
            guard let self = self else { return }
            //TODO: 更新列表视图
            self.collectionView.reloadData()
        }
    }
}


