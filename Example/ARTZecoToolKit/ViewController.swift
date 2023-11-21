//
//  ViewController.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 11/16/2023.
//  Copyright (c) 2023 mrSir18. All rights reserved.
//

import UIKit
import ARTZecoToolKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "collection"
        
        setupUI()
    }
    
    fileprivate func setupUI() {
        let layout = ARTCollectionViewFlowLayout()
        let collection = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collection.backgroundColor = .white
        collection.delegate = self
        collection.dataSource = self
        collection.register(testCell.self, forCellWithReuseIdentifier: testCell.identifiers)
        collection.register(testHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: testHeaderView.header)
        collection.register(testHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: testHeaderView.footer)
        view.addSubview(collection)
    }
    
    
    private func sectionName(section: Int) -> String {
        switch section {
        case 0:
            return "瀑布流布局"
        case 1:
            return "列表布局"
        case 2:
            return "九宫格布局"
        default:
            return ""
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
            // 瀑布流
        case 0:
            return 7
            // 线性
        case 1:
            return 3
            // 九宫格
        default:
            return 9
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: testCell.identifiers, for: indexPath) as! testCell
        cell.testLab.text = " \(indexPath.section) section \(indexPath.row) item"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: testHeaderView.header, for: indexPath) as! testHeaderView
            header.testLab.text = "\(sectionName(section: indexPath.section)) header view"
            header.backgroundColor = UIColor(red: 75.0/255.0, green: 75.0/255.0, blue: 75.0/255.0, alpha: 0.5)
            return header
        } else if kind == UICollectionElementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: testHeaderView.footer, for: indexPath) as! testHeaderView
            footer.testLab.text = "\(sectionName(section: indexPath.section)) footer view"
            footer.backgroundColor = UIColor(red: 75.0/255.0, green: 75.0/255.0, blue: 75.0/255.0, alpha: 0.5)
            return footer
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("第\(indexPath.section)组，第\(indexPath.row)个")
    }
}

extension ViewController: ARTCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, configModelForSectionAt section: Int) -> ARTCollectionViewConfigModel? {
        let entity: ARTCollectionViewConfigModel = ARTCollectionViewConfigModel()
        if section == 0 {
            entity.cornerRadius = 15
            entity.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            entity.imageURLString = "1"
            entity.backgroundColor = .orange
            
        } else {
            entity.cornerRadius = 5
            entity.backgroundColor = .red
        }
        return entity
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, heightForItemAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
//            print("第\(indexPath.section)组，第\(indexPath.row)个")
            if indexPath.row == 0 {
                return 120
            }
            return 100
            //      return CGFloat((arc4random() % 3 + 1) * 30)
        case 1:
            return 100
        default:
            return 80
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, columnForSectionAt section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 1
        default:
            return 3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.size.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.size.width, height: 30)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, spacingBetweenFooterAndNextHeaderForSectionAt section: Int) -> CGFloat {
        return 15
    }
}

class testCell: UICollectionViewCell {
    static let identifiers = "testcellssss"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configBaseView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configBaseView() {
        backgroundColor = .darkGray
        addSubview(testLab)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        testLab.frame = self.bounds
    }
    
    lazy var testLab: UILabel = {
        let tmp = UILabel()
        tmp.textColor = .white
        tmp.font = .systemFont(ofSize: 14)
        tmp.textAlignment = .center
        tmp.numberOfLines = 0
        return tmp
    }()
}

class testHeaderView: UICollectionReusableView {
    static let header = "testHeaderViewId"
    static let footer = "testFooterViewId"
    override init(frame: CGRect) {
        super.init(frame: frame)
        configBaseView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configBaseView() {
        addSubview(testLab)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        testLab.frame = bounds
    }
    
    lazy var testLab: UILabel = {
        let tmp = UILabel()
        tmp.textColor = .white
        tmp.font = .systemFont(ofSize: 14)
        tmp.textAlignment = .center
        tmp.numberOfLines = 0
        return tmp
    }()
}

