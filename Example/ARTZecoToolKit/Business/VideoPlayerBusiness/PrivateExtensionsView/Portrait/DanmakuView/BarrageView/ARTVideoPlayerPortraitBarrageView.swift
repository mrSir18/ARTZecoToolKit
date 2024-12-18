//
//  ARTVideoPlayerPortraitBarrageView.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/11/7.
//

import ARTZecoToolKit

class ARTVideoPlayerPortraitBarrageView: UIView {
    
    /// 弹幕设置实例
    private var danmakuEntity = ARTVideoPlayerGeneralDanmakuEntity()
    
    /// 列表视图
    private var collectionView: UICollectionView!
    
    /// 弹幕设置选项回调
    public var sliderValueChangedCallback: ((ARTVideoPlayerGeneralDanmakuEntity.SliderOption) -> Void)?
    
    /// 弹幕初始化状态回调
    public var restoreDanmakuCallback: ((ARTVideoPlayerGeneralDanmakuEntity) -> Void)?
    
    
    // MARK: - Initialization

    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        setupCollectionView()
    }
}

// MARK: - Setup Initializer

extension ARTVideoPlayerPortraitBarrageView {
    
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
        collectionView.bounces                        = false
        collectionView.registerCell(ARTVideoPlayerPortraitBarrageCell.self)
        collectionView.registerSectionHeader(ARTVideoPlayerPortraitBarrageHeader.self)
        collectionView.registerSectionFooter(ARTSectionFooterView.self)
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension ARTVideoPlayerPortraitBarrageView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return danmakuEntity.sliderOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(for: indexPath) as ARTVideoPlayerPortraitBarrageCell
        cell.sliderValueChanged = { [weak self] value, shouldSave in
            guard let self = self else { return }
            if shouldSave {
                var option = self.danmakuEntity.sliderOptions[indexPath.item] // 更新滑块值
                option.defaultValue = value
                self.danmakuEntity.updateOption(at: indexPath.item, with: option) // 更新弹幕设置选项并保存
                self.sliderValueChangedCallback?(option) // 滑块值改变事件回调
            }
        }
        cell.configureWithSliderOption(danmakuEntity.sliderOptions[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: ARTAdaptedValue(52.0))
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let reusableView = ARTVideoPlayerPortraitBarrageHeader.dequeueHeader(from: collectionView, for: indexPath)
            if let header = reusableView as? ARTVideoPlayerPortraitBarrageHeader {
                header.restoreCallback = { [weak self] in
                    guard let self = self else { return }
                    self.danmakuEntity.restoreDefaults()
                    self.collectionView.reloadData()
                    self.restoreDanmakuCallback?(self.danmakuEntity) // 恢复弹幕设置事件回调
                }
            }
            return reusableView
        }
        let reusableView = ARTSectionFooterView.dequeueFooter(from: collectionView, for: indexPath)
        reusableView.backgroundColor = .clear
        return reusableView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: ARTAdaptedValue(68.0))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .zero
    }
}
