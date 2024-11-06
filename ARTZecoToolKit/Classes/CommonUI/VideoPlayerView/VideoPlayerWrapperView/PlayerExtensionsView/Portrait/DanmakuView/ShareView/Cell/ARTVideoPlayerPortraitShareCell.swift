//
//  ARTVideoPlayerPortraitShareCell.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/11/7.
//

class ARTVideoPlayerPortraitShareCell: UICollectionViewCell {
    
    /// icon视图
    private var iconImageView: UIImageView!
    
    /// 标题标签
    private var titleLabel: UILabel!
    
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        // 创建图片视图
        iconImageView = UIImageView()
        iconImageView.backgroundColor = .art_randomColor()
        contentView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(ARTAdaptedSize(width: 64.0, height: 64.0))
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        // 创建标题标签
        titleLabel = UILabel()
        titleLabel.textAlignment        = .center
        titleLabel.font                 = .art_regular(ARTAdaptedValue(12.0))
        titleLabel.textColor            = .art_color(withHEXValue: 0x000000)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(ARTAdaptedValue(6.0))
            make.centerX.equalToSuperview()
            make.height.equalTo(ARTAdaptedValue(17.0))
        }
    }
    
    // MARK: - Public Methods
    
    func configureWithShareEntity(_ entity: ARTVideoPlayerPortraitShareEntity.ShareOption) {
        iconImageView.image = UIImage(named: entity.icon)
        titleLabel.text = entity.title
    }
}
