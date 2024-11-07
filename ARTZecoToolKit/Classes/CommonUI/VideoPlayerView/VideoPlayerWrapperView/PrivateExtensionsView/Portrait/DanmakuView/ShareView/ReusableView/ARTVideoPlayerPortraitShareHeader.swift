//
//  ARTVideoPlayerPortraitShareHeader.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/11/7.
//

class ARTVideoPlayerPortraitShareHeader: ARTSectionHeaderView {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        setupViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // 创建标题标签
        let titleLabel = UILabel()
        titleLabel.text             = "分享至"
        titleLabel.textAlignment    = .left
        titleLabel.font             = .art_medium(ARTAdaptedValue(12.0))
        titleLabel.textColor        = .art_color(withHEXValue: 0x000000)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(ARTAdaptedValue(8.0))
            make.top.equalTo(ARTAdaptedValue(20.0))
            make.right.equalTo(-ARTAdaptedValue(8.0))
            make.height.equalTo(ARTAdaptedValue(17.0))
        }
    }
}
