//
//  ARTCollectionCell.swift
//  ARTZecoToolKit_Example
//
//  Created by mrSir18 on 2024/7/13.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import ARTZecoToolKit

class ARTCollectionCell: UICollectionViewCell {
    
    // 分类标签
    private var titleLabel: UILabel!
    
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .art_randomColor()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {

        // 创建标题标签
        titleLabel = UILabel()
        titleLabel.textAlignment        = .center
        titleLabel.font                 = .art_regular(ARTAdaptedValue(12.0))
        titleLabel.textColor            = .art_randomColor()
        titleLabel.numberOfLines        = 0
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Public Methods
    
    func configureWithContent(_ content: String?, indexPath: IndexPath) {
        titleLabel.text = "\(content!)\nsection: \(indexPath.section) row: \(indexPath.item)"
    }
}
