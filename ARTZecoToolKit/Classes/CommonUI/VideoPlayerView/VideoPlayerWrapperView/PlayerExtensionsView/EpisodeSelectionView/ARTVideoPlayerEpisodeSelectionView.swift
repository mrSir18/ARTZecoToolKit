//
//  ARTVideoPlayerEpisodeSelectionView.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/11/4.
//

open class ARTVideoPlayerEpisodeSelectionView: ARTVideoPlayerSlidingOverlayView {
    
    /// 标题标签
    private var titleLabel: UILabel!
    
    /// 分割线视图
    private var separatorLineView: ARTCustomView!
    
    /// 列表视图
    private var collectionView: UICollectionView!
    
    /// 默认选中的索引路径
    public var shouldSelectedIndexPath: IndexPath = IndexPath(item: 0, section: 0)
    
    /// 目录数据
    public var episodes: [String] = ["第一部分：亲子游戏逻辑", "第二部分：游戏方法", "第三部分：亲子逻辑"]
    
    /// 回调事件
    public var episodeCallback: ((_ index: String) -> Void)?
    
    
    // MARK: - Override Super Methods
    
    open override func setupViews() {
        super.setupViews()
        setupSeparatorLineView()
        setupTitleLabel()
        setupCollectionView()
    }
    
    open override func handleSortingTapGesture(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: containerView)
        if !collectionView.frame.contains(location) {
            hideExtensionsView()
        }
    }
}

// MARK: - Setup Initializer

extension ARTVideoPlayerEpisodeSelectionView {
    
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
        titleLabel.text               = "目录"
        titleLabel.textAlignment      = .left
        titleLabel.font               = .art_medium(ARTAdaptedValue(13.0))
        titleLabel.textColor          = .art_color(withHEXValue: 0xFFFFFF)
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(separatorLineView.snp.left).offset(ARTAdaptedValue(12.0))
            make.bottom.equalTo(separatorLineView.snp.bottom).offset(-ARTAdaptedValue(14.0))
            make.height.equalTo(ARTAdaptedValue(18.0))
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
        collectionView.contentInset                   = .zero
        collectionView.registerCell(ARTVideoPlayerEpisodeSelectionCell.self)
        containerView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(separatorLineView.snp.bottom)
            make.left.right.equalTo(separatorLineView)
            make.bottom.equalTo(-ARTAdaptedValue(12.0))
        }
    }
}
