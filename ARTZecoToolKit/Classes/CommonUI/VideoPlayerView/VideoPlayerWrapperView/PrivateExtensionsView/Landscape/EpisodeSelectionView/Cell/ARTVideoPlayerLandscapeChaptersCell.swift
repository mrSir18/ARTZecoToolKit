//
//  ARTVideoPlayerLandscapeChaptersCell.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/11/5.
//

class ARTVideoPlayerLandscapeChaptersCell: UICollectionViewCell {
    
    /// 标题标签
    private var titleLabel: UILabel!
    
    /// 副标题标签
    private var subTitleLabel: UILabel!
    
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {

        // 创建标题标签
        titleLabel = UILabel()
        titleLabel.textAlignment        = .left
        titleLabel.font                 = .art_medium(ARTAdaptedValue(13.0))
        titleLabel.textColor            = .art_color(withHEXValue: 0xFE5C01)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(ARTAdaptedValue(12.0))
            make.top.equalTo(ARTAdaptedValue(9.0))
            make.right.equalTo(-ARTAdaptedValue(12.0))
            make.height.equalTo(ARTAdaptedValue(18.0))
        }
        
        // 创建副标题标签
        subTitleLabel = UILabel()
        subTitleLabel.text              = "正在播放"
        subTitleLabel.textAlignment     = .left
        subTitleLabel.font              = .art_light(ARTAdaptedValue(8.0))
        subTitleLabel.textColor         = .art_color(withHEXValue: 0xFE5C01)
        contentView.addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints { make in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom)
            make.height.equalTo(ARTAdaptedValue(11.0))
        }
        
        // 创建容器视图
        let separatorLineView = ARTCustomView()
        separatorLineView.customBackgroundColor = .art_color(withHEXValue: 0xD8D8D8, alpha: 0.2)
        contentView.addSubview(separatorLineView)
        separatorLineView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    // MARK: - Public Methods
    
    public func updateCellBorderStyle(_ shouldSelected: Bool) {
        titleLabel.textColor    = shouldSelected ? .art_color(withHEXValue: 0xFE5C01) : .art_color(withHEXValue: 0xFFFFFF)
        subTitleLabel.textColor = shouldSelected ? .art_color(withHEXValue: 0xFE5C01) : .art_color(withHEXValue: 0xFFFFFF)
        subTitleLabel.isHidden  = !shouldSelected
        titleLabel.snp.updateConstraints { make in
            make.top.equalTo(shouldSelected ? ARTAdaptedValue(9.0) : ARTAdaptedValue(15.0))
        }
    }
    
    public func configureWithChapterContent(_ episode: String) {
        titleLabel.text = episode
    }
}
