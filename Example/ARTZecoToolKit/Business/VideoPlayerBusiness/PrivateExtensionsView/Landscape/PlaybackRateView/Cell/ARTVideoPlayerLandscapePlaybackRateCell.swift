//
//  ARTVideoPlayerLandscapePlaybackRateCell.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/11/5.
//

import ARTZecoToolKit

class ARTVideoPlayerLandscapePlaybackRateCell: UICollectionViewCell {
    
    /// 内容容器
    private var containerView: ARTCustomView!
    
    /// 倍数标签
    private var rateLabel: UILabel!
    
    /// 选中标识
    private var shouldSelected: Bool = false
    
    
    // MARK: - Life Cycle
    
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
        containerView.customBackgroundColor = .art_color(withHEXValue: 0xFFFFFF, alpha: 0.9)
        containerView.borderColor           = .art_color(withHEXValue: 0xFE5C01)
        containerView.borderWidth           = ARTAdaptedValue(1.0)
        containerView.cornerRadius          = ARTAdaptedValue(8.0)
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 创建倍数标签
        rateLabel = UILabel()
        rateLabel.textAlignment     = .center
        rateLabel.font              = .art_shsHeavy(ARTAdaptedValue(20.0))
        rateLabel.textColor         = .art_color(withHEXValue: 0xFE5C01)
        contentView.addSubview(rateLabel)
        rateLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Public Methods
    
    public func updateCellBorderStyle(_ shouldSelected: Bool) {
        self.shouldSelected = shouldSelected
        containerView.customBackgroundColor = shouldSelected ? .art_color(withHEXValue: 0xFFFFFF, alpha: 0.9) : .art_color(withHEXValue: 0x2A2723, alpha: 0.7)
        containerView.borderColor           = shouldSelected ? .art_color(withHEXValue: 0xFE5C01) : .clear
        rateLabel.textColor                 = shouldSelected ? .art_color(withHEXValue: 0xFE5C01) : .art_color(withHEXValue: 0xFFFFFF)
    }
    
    public func configureWithRateContent(_ rate: String) {
        rateLabel.text = "\(rate)X"
    }
}
