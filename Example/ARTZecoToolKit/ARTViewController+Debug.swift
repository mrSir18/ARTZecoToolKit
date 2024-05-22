//
//  ARTViewController+Debug.swift
//  ARTZecoToolKit_Example
//
//  Created by mrSir18 on 2024/5/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import ARTZecoToolKit

class ARTViewController_Debug: ARTBaseViewController {

    /// 控件名
    let dataSources: [String] = ["自定义表单", "自定义轮播图", "自定义城市选择器", "自定义提示框(Alert)(ActionSheet))", "自定义(SlideBar)", "自定义数量选择器", "自定义弹窗(SlidePopup)", "自定义视频播放器(VideoPlayer)"]
    
    /// 类名数组
    let classNames: [String] = ["ARTViewController_CollectionView", "ARTViewController_ScrollView", "ARTViewController_CitySelector",
                                "ARTViewController_Alert",          "ARTViewController_SlideBar",   "ARTViewController_Quantity",
                                "ARTViewController_SlidePopup", "ARTViewController_VideoPlayer"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backButtonHidden = true
        
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInsetAdjustmentBehavior   = .never
        collectionView.backgroundColor                  = .white
        collectionView.delegate                         = self
        collectionView.dataSource                       = self
        collectionView.showsHorizontalScrollIndicator   = false
        collectionView.contentInset                     = UIEdgeInsets(top: 0.0, left: 0.0, bottom: art_safeAreaBottom(), right: 0.0)
        collectionView.registerCell(ARTViewControllerViewCell.self)
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(baseContainerView.snp.bottom)
            make.left.bottom.right.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension ARTViewController_Debug: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return classNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(for: indexPath) as ARTViewControllerViewCell
        cell.titleLabel.text = dataSources[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let executableName = Bundle.main.infoDictionary?["CFBundleExecutable"] as? String else {
            // 处理无法获取 executableName 的情况
            return
        }
        let className = classNames[indexPath.row]
        guard let viewControllerType = NSClassFromString("\(executableName).\(className)") as? UIViewController.Type else {
            // 处理无法获取类的情况
            return
        }
        let viewController = viewControllerType.init()
        viewController.title = dataSources[indexPath.row]
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - ARTViewControllerViewCell

class ARTViewControllerViewCell: UICollectionViewCell {
    
    var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        
        titleLabel = UILabel()
        titleLabel.textAlignment = .left
        titleLabel.font          = .art_medium(18.0)
        titleLabel.textColor     = .art_color(withHEXValue: 0x000000)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(24.0)
            make.top.right.bottom.equalToSuperview()
        }
        
        let separateLine = UIView()
        separateLine.backgroundColor = .gray
        contentView.addSubview(separateLine)
        separateLine.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
