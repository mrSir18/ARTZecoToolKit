//
//  ARTVideoPlayerPortraitBarrageHeader.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/11/7.
//

class ARTVideoPlayerPortraitBarrageHeader: ARTSectionHeaderView {
    
    /// 标题标签
    private var titleLabel: UILabel!
    
    /// 恢复按钮
    private var restoreButton: ARTAlignmentButton!
    
    /// 恢复弹幕设置回调
    public var restoreCallback: (() -> Void)?
    
    
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
        setupTitleLabel()
        setupRestoreButton()
        setupSeparatorLineView()
    }
    
    // MARK: - Button Actions
    
    @objc private func didTapRestoreButton() { // 恢复按钮
        restoreCallback?()
    }
}

extension ARTVideoPlayerPortraitBarrageHeader {
    
    /// 设置标题标签
    private func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.text             = "弹幕设置"
        titleLabel.textAlignment    = .left
        titleLabel.font             = .art_medium(ARTAdaptedValue(12.0))
        titleLabel.textColor        = .art_color(withHEXValue: 0x000000)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.top.equalTo(ARTAdaptedValue(20.0))
            make.height.equalTo(ARTAdaptedValue(17.0))
        }
    }
    
    /// 设置副标题标签
    private func setupRestoreButton() {
        restoreButton = ARTAlignmentButton(type: .custom)
        restoreButton.contentInset      = ARTAdaptedValue(20.0)
        restoreButton.imageAlignment    = .right
        restoreButton.titleLabel?.font  = .art_regular(ARTAdaptedValue(12.0))
        restoreButton.setTitle("恢复", for: .normal)
        restoreButton.setTitleColor(.art_color(withHEXValue: 0xC8C8CC), for: .normal)
        restoreButton.addTarget(self, action: #selector(didTapRestoreButton), for: .touchUpInside)
        addSubview(restoreButton)
        restoreButton.snp.makeConstraints { make in
            make.size.equalTo(ARTAdaptedSize(width: 80.0, height: 50.0))
            make.right.equalToSuperview()
            make.centerY.equalTo(titleLabel)
        }
    }
    
    /// 设置分割线视图
    private func setupSeparatorLineView() {
        let separatorLineView = ARTCustomView()
        separatorLineView.customBackgroundColor = .art_color(withHEXValue: 0xD8D8D8, alpha: 0.2)
        addSubview(separatorLineView)
        separatorLineView.snp.makeConstraints { make in
            make.left.equalTo(ARTAdaptedValue(20.0))
            make.bottom.equalTo(-ARTAdaptedValue(16.0))
            make.right.equalTo(-ARTAdaptedValue(20.0))
            make.height.equalTo(0.5)
        }
    }
}
