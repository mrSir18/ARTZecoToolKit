//
//  ARTCitySelectorHotHeader.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/5/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

class ARTCitySelectorHotHeader: ARTSectionHeaderView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.backgroundColor = .clear

        // 创建常用城市标签视图
        let titleLabel = UILabel()
        titleLabel.text = "常用城市"
        titleLabel.textAlignment = .left
        titleLabel.font          = .art_regular(14.0)
        titleLabel.textColor     = .art_color(withHEXValue: 0x8b8b8b)
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(18.0)
            make.centerY.equalToSuperview()
        }
    }
}
