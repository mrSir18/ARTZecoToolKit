//
//  ARTCityPickerCell.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/5/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

class ARTCityPickerCell: UICollectionViewCell {
    
    /// 索引标签
    private var indexLabel: UILabel!
    
    /// 城市标签
    private var locationLabel: UILabel!
    
    /// 标记视图
    private var tickImageView: UIImageView!
    
    /// 城市数据
    public var citySelectorEntity: ARTCityPickerEntity? {
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
    
    
    // MARK: - Initialization
    
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
        indexLabel.textColor        = .art_color(withHEXValue: 0x999999)
        indexLabel.font             = .art_regular(ARTAdaptedValue(12.0))
        indexLabel.textAlignment    = .left
        contentView.addSubview(indexLabel)
        indexLabel.snp.makeConstraints { make in
            make.left.equalTo(ARTAdaptedValue(12.0))
            make.centerY.equalToSuperview()
        }
        
        // 创建城市标签视图
        locationLabel = UILabel()
        locationLabel.textColor     = .art_color(withHEXValue: 0x000000)
        locationLabel.font          = .art_regular(ARTAdaptedValue(12.0))
        locationLabel.textAlignment = .left
        contentView.addSubview(locationLabel)
        locationLabel.snp.makeConstraints { make in
            make.left.equalTo(ARTAdaptedValue(46.0))
            make.centerY.equalToSuperview()
        }
        
        // 标记视图
        tickImageView = UIImageView()
        tickImageView.image = ARTCityStyleConfiguration.default().tickImage
        contentView.addSubview(tickImageView)
        tickImageView.snp.makeConstraints { make in
            make.size.equalTo(ARTAdaptedSize(width: 16.0, height: 16.0))
            make.centerY.equalToSuperview()
            make.right.equalTo(-ARTAdaptedValue(12.0))
        }
    }
}
