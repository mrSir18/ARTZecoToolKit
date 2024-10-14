//
//  ARTCityPickerHotCell.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/5/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

class ARTCityPickerHotCell: UICollectionViewCell {
    
    /// 容器视图
    public var containerView: ARTCustomView!
    
    /// 位置标签
    private var locationLabel: UILabel!
    
    /// 城市数据
    public var citySelectorEntity: ARTCityPickerEntity? {
        didSet {
            guard let citySelectorEntity = citySelectorEntity else { return }
            locationLabel.text  = citySelectorEntity.ext_name
        }
    }
    
    /// 是否选中城市
    lazy var isSelectedCity: Bool = false {
        didSet {
            containerView.customBackgroundColor = isSelectedCity ? ARTCityStyleConfiguration.default().themeColor.withAlphaComponent(0.15) : UIColor.art_color(withHEXValue: 0xf8f8f8)
            containerView.borderWidth   = isSelectedCity ? 0.5 : 0.0
            containerView.borderColor   = isSelectedCity ? ARTCityStyleConfiguration.default().themeColor.withAlphaComponent(0.6) : UIColor.clear
            locationLabel.textColor     = isSelectedCity ? ARTCityStyleConfiguration.default().themeColor : .art_color(withHEXValue: 0x999999)
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
        
        // 创建容器视图
        containerView = ARTCustomView()
        containerView.customBackgroundColor = .art_color(withHEXValue: 0xf8f8f8)
        containerView.cornerRadius          = ARTAdaptedValue(6.0)
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 创建标题标签视图
        locationLabel = UILabel()
        locationLabel.textColor       = .art_color(withHEXValue: 0x999999)
        locationLabel.font            = .art_regular(ARTAdaptedValue(10.0))
        locationLabel.textAlignment   = .center
        containerView.addSubview(locationLabel)
        locationLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
}
