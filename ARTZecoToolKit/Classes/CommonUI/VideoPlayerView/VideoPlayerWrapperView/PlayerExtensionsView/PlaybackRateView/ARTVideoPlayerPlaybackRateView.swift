//
//  ARTVideoPlayerPlaybackRateView.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/11/4.
//

open class ARTVideoPlayerPlaybackRateView: ARTVideoPlayerSlidingOverlayView {
    
    /// 标题标签
    private var titleLabel: UILabel!
    
    /// 恢复按钮
    private var restoreButton: UIButton!
    
    /// 分割线视图
    private var separatorLineView: ARTCustomView!

    /// 列表视图
    private var collectionView: UICollectionView!
    
    /// 默认选中的索引路径
    public var shouldSelectedIndexPath: IndexPath = IndexPath(item: 4, section: 0)
    
    /// 倍数数据
    public var rates: [String] = ["3.0", "2.0", "1.5", "1.25", "1.0", "0.5"]
    
    /// 回调事件
    public var rateCallback: ((_ rate: Float) -> Void)?
    
    
    // MARK: - Override Super Methods
    
    open override func setupViews() {
        super.setupViews()
        setupSeparatorLineView()
        setupTitleLabel()
        setupRestoreButton()
        setupCollectionView()
    }
    
    open override func handleSortingTapGesture(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: containerView)
        if !collectionView.frame.contains(location) && !restoreButton.frame.contains(location) {
            hideExtensionsView()
        }
    }
    
    // MARK: - Button Actions
    
    @objc private func didTapRestoreButton() { // 恢复
        rateCallback?(1.0)
        hideExtensionsView()
    }
}

// MARK: - Setup Initializer

extension ARTVideoPlayerPlaybackRateView {
    
    /// 设置分割线视图
    private func setupSeparatorLineView() {
        separatorLineView = ARTCustomView()
        separatorLineView.customBackgroundColor = .art_color(withHEXValue: 0xD8D8D8, alpha: 0.2)
        containerView.addSubview(separatorLineView)
        separatorLineView.snp.makeConstraints { make in
            make.right.equalTo(-ARTAdaptedValue(16.0))
            make.top.equalTo(ARTAdaptedValue(44.0))
            make.width.equalTo(ARTAdaptedValue(246.0))
            make.height.equalTo(0.5)
        }
    }
    
    /// 设置标题标签
    private func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.text               = "倍速设置"
        titleLabel.textAlignment      = .left
        titleLabel.font               = .art_medium(ARTAdaptedValue(13.0))
        titleLabel.textColor          = .art_color(withHEXValue: 0xFFFFFF)
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.right.equalTo(-ARTAdaptedValue(196.0))
            make.top.equalTo(ARTAdaptedValue(12.0))
            make.height.equalTo(ARTAdaptedValue(18.0))
        }
    }
    
    /// 设置副标题标签
    private func setupRestoreButton() {
        restoreButton = UIButton(type: .custom)
        restoreButton.titleLabel?.font = .art_regular(ARTAdaptedValue(11.0))
        restoreButton.contentHorizontalAlignment = .right
        restoreButton.setTitle("恢复", for: .normal)
        restoreButton.setTitleColor(.art_color(withHEXValue: 0xC8C8CC), for: .normal)
        restoreButton.addTarget(self, action: #selector(didTapRestoreButton), for: .touchUpInside)
        containerView.addSubview(restoreButton)
        restoreButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.right.equalTo(separatorLineView.snp.right).offset(-ARTAdaptedValue(16.0))
            make.bottom.equalTo(separatorLineView)
            make.width.equalTo(ARTAdaptedValue(60.0))
        }
    }
    
    /// 设置列表视图
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator   = false
        collectionView.backgroundColor                = .clear
        collectionView.delegate                       = self
        collectionView.dataSource                     = self
        collectionView.contentInset                   = UIEdgeInsets(top: 0, left: ARTAdaptedValue(8.0), bottom: 0, right: ARTAdaptedValue(8.0))
        collectionView.registerCell(ARTVideoPlayerPlaybackRateCell.self)
        containerView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(separatorLineView.snp.bottom).offset(ARTAdaptedValue(24.0))
            make.left.right.equalTo(separatorLineView)
            make.bottom.equalTo(-ARTAdaptedValue(24.0))
        }
    }
}
