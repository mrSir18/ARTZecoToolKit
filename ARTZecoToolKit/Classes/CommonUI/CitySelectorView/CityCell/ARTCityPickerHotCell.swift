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
    
    /// 位置图片
    private var locationImageView: UIImageView!
    
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
        
//        // 创建容器视图
//        let containerView = UIView()
//        containerView.backgroundColor    = .art_color(withHEXValue: 0xf8f8f8)
//        containerView.layer.cornerRadius = 2.0
//        containerView.layer.masksToBounds = true
//        contentView.addSubview(containerView)
//        containerView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//        
//        // 创建内容容器视图
//        let contentContainerView = UIView()
//        contentView.addSubview(contentContainerView)
//        
//        // 创建标题标签视图
//        let file = art_resourcePath(file: "city_location_gary.png", object: self)
//        locationImageView = UIImageView()
//        locationImageView.image = UIImage(contentsOfFile: file)
//        contentContainerView.addSubview(locationImageView)
//        locationImageView.snp.makeConstraints { make in
//            make.size.equalTo(CGSize(width: 14.0, height: 14.0))
//            make.left.equalTo(0.0)
//            make.centerY.equalToSuperview()
//        }
//        
//        // 创建标题标签视图
//        locationLabel = UILabel()
//        locationLabel.textColor       = .art_color(withHEXValue: 0x8a8a8a)
//        locationLabel.font            = .art_regular(12.0)
//        locationLabel.textAlignment   = .center
//        contentContainerView.addSubview(locationLabel)
//        locationLabel.snp.makeConstraints { make in
//            make.left.equalTo(locationImageView.snp.right).offset(4.0)
//            make.centerY.equalTo(locationImageView)
//        }
//        
//        contentContainerView.snp.makeConstraints { make in
//            make.top.bottom.equalToSuperview()
//            make.left.equalTo(locationImageView)
//            make.right.equalTo(locationLabel.snp.right)
//            make.centerX.centerY.equalTo(containerView)
//        }
    }
}
