//
//  ARTCityPickerHotHeader.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/5/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

class ARTCityPickerHotHeader: ARTSectionHeaderView {
    
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
        titleLabel.text             = "常用城市"
        titleLabel.textAlignment    = .left
        titleLabel.font             = .art_regular(ARTAdaptedValue(12.0))
        titleLabel.textColor        = .art_color(withHEXValue: 0x999999)
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(ARTAdaptedValue(12.0))
            make.top.equalTo(ARTAdaptedValue(10.0))
            make.height.equalTo(ARTAdaptedValue(17.0))
        }
    }
}
