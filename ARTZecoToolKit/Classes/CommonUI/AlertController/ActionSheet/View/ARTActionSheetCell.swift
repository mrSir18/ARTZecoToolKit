//
//  ARTActionSheetCell.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/7/2.
//

class ARTActionSheetCell: UICollectionViewCell {
    
    // 标题
    private var titleLabel: UILabel!
    
    // 分割线
    private var separatorLineView: UIView!
    
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
        contentView.addSubview(titleLabel)
        
        // 创建分割线
        separatorLineView = UIView()
        contentView.addSubview(separatorLineView)
        separatorLineView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    // MARK: - Public Methods
    
    func configureWithContentItem(_ item: ARTActionSheetContentEntity) {
        titleLabel.text                     = item.text
        titleLabel.font                     = item.textFont
        titleLabel.textColor                = item.textColor
        titleLabel.textAlignment            = item.textAlignment
        separatorLineView.backgroundColor   = item.separatorLineColor
        separatorLineView.isHidden          = !item.showSeparatorLine
        titleLabel.snp.remakeConstraints { make in
            make.edges.equalTo(item.textInset)
        }
    }
}
