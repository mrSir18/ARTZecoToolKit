//
//  ARTViewController_CollectionView.swift
//  ARTZecoToolKit_Example
//
//  Created by mrSir18 on 2024/5/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import ARTZecoToolKit

class ARTViewController_CollectionView: ARTBaseViewController {
    
    /// 数据源
    private let sectionNames: [String] = ["瀑布流布局", "列表布局", "九宫格布局"]
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// 自定义UICollectionView
        let layout = ARTCollectionViewFlowLayout(self)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerCell(ARTZecoTestCell.self)
        collectionView.register(ARTZecoTestReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ARTZecoTestReusableView.elementKindSectionHeader)
        collectionView.register(ARTZecoTestReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: ARTZecoTestReusableView.elementKindSectionfooter)
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(baseContainerView.snp.bottom)
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension ARTViewController_CollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 7
        case 1:
            return 3
        default:
            return 9
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(for: indexPath) as ARTZecoTestCell
        cell.artTestLabel.text = " \(indexPath.section) section \(indexPath.row) item"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let reuseIdentifier: String
        let labelText: String
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            reuseIdentifier = ARTZecoTestReusableView.elementKindSectionHeader
            labelText = "\(self.sectionNames[indexPath.section]) header view"
        case UICollectionView.elementKindSectionFooter:
            reuseIdentifier = ARTZecoTestReusableView.elementKindSectionfooter
            labelText = "\(self.sectionNames[indexPath.section]) footer view"
        default:
            return UICollectionReusableView()
        }
        
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseIdentifier, for: indexPath) as! ARTZecoTestReusableView
        reusableView.artTestLabel.text = labelText
        reusableView.configureCornerRadius(reuseIdentifier)
        return reusableView
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.size.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.size.width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("第\(indexPath.section)组，第\(indexPath.row)个")
    }
}

// MARK: - ARTCollectionViewDelegateFlowLayout

extension ARTViewController_CollectionView: ARTCollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, configModelForSectionAt section: Int) -> ARTCollectionViewConfigModel? {
        let entity: ARTCollectionViewConfigModel = ARTCollectionViewConfigModel()
        entity.cornerRadius     = 15
//        entity.maskedCorners    = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        if section == 0 {
            entity.imageURLString = "https://img.tukuppt.com/preview/00/06/79/32/6793262612eb23740eshow.jpg"
        } else {
            entity.imageURLString   = String(describing: section)
        }
        entity.backgroundColor  = .white
        return entity
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, spacingBetweenFooterAndNextHeaderForSectionAt section: Int) -> CGFloat {
        return 15
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, heightForItemAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            return CGFloat((arc4random() % 3 + 1) * 30)
        case 1:
            return 100
        default:
            return 80
        }
    }
}

// MARK: - ARTZecoTestCell

class ARTZecoTestCell: UICollectionViewCell {
    lazy var artTestLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.art_randomColor()
        self.addSubview(self.artTestLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.artTestLabel.frame = self.bounds
    }
}

// MARK: - ARTZecoTestReusableView

class ARTZecoTestReusableView: UICollectionReusableView {
    static let elementKindSectionHeader = "ARTZecoElementKindSectionHeader"
    static let elementKindSectionfooter = "ARTZecoElementKindSectionfooter"
    
    lazy var artTestLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 75.0/255.0, green: 75.0/255.0, blue: 75.0/255.0, alpha: 0.5)
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.addSubview(self.artTestLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.artTestLabel.frame = CGRectMake(10, 0, self.bounds.width-20, self.bounds.height)
    }
    
    func configureCornerRadius(_ kind: String) {
        if ARTZecoTestReusableView.elementKindSectionHeader == kind {
            self.artTestLabel.layer.cornerRadius = 15
            self.artTestLabel.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            self.artTestLabel.clipsToBounds = true
        }
    }
}

