//
//  ARTCitySelectorCell.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/5/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

class ARTCitySelectorCell: UICollectionViewCell {
    
    /// 索引标签
    private var indexLabel: UILabel!
    
    /// 城市标签
    private var locationLabel: UILabel!
    
    /// 标记视图
    private var tickImageView: UIImageView!
    
    /// 城市数据
    public var citySelectorEntity: ARTCitySelectorEntity? {
        didSet {
            guard let citySelectorEntity = citySelectorEntity else { return }
            locationLabel.text  = citySelectorEntity.ext_name
            indexLabel.text     = citySelectorEntity.pinyin_prefix
        }
    }
    
    /// 是否选中城市
    lazy var isSelectedCity: Bool = false { 
        didSet {
            tickImageView.isHidden = !isSelectedCity
            locationLabel.textColor = isSelectedCity ? ARTCityStyleConfiguration.default().themeColor : .art_color(withHEXValue: 0x18171f)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        // 创建索引标签视图
        indexLabel = UILabel()
        indexLabel.textColor       = .art_color(withHEXValue: 0x808080)
        indexLabel.font            = .art_regular(13.0)
        indexLabel.textAlignment   = .left
        contentView.addSubview(indexLabel)
        indexLabel.snp.makeConstraints { make in
            make.left.equalTo(18.0)
            make.centerY.equalToSuperview()
        }
        
        // 创建城市标签视图
        locationLabel = UILabel()
        locationLabel.textColor       = .art_color(withHEXValue: 0x18171f)
        locationLabel.font            = .art_regular(15.0)
        locationLabel.textAlignment   = .left
        contentView.addSubview(locationLabel)
        locationLabel.snp.makeConstraints { make in
            make.left.equalTo(55.0)
            make.centerY.equalToSuperview()
        }
        
        // 标记视图
        tickImageView = UIImageView()
        contentView.addSubview(tickImageView)
        tickImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 16.0, height: 16.0))
            make.centerY.equalToSuperview()
            make.right.equalTo(-39.0)
        }
        if let tickImage = ARTCityStyleConfiguration.default().tickImage {
            tickImageView.image = tickImage
        } else {
            let file = art_resourcePath(file: "city_selector_tick.png", object: self)
            tickImageView.image = UIImage(contentsOfFile: file)
            ARTCityStyleConfiguration.default().tickImage(tickImageView.image)
        }
    }
}
