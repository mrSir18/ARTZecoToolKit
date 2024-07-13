//
//  ARTCollectionHeader.swift
//  ARTZecoToolKit_Example
//
//  Created by mrSir18 on 2024/7/13.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import ARTZecoToolKit

class ARTCollectionHeader: ARTSectionHeaderView {

    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {

        // 创建标题标签
        let titleLabel = UILabel()
        titleLabel.text             = "成长智库APP_Header"
        titleLabel.textAlignment    = .center
        titleLabel.font             = .art_semibold(ARTAdaptedValue(14.0))
        titleLabel.textColor        = .art_randomColor()
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
