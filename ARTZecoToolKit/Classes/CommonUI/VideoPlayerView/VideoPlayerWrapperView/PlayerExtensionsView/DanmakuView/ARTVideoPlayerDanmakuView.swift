//
//  ARTVideoPlayerDanmakuView.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/11/4.
//

/// 协议方法
///
/// - NOTE: 可继承该协议方法
public protocol ARTVideoPlayerDanmakuViewDelegate: ARTVideoPlayerSlidingOverlayViewDelegate {

}

/// 弹幕设置选项
extension ARTVideoPlayerDanmakuView {
    public struct SliderOption {
        let title: String
        let minValue: Float
        let maxValue: Int
        let segments: [String]  // 分段标签（不透明度、字体大小等具体的值）
        let defaultValue: Float // 默认值属性
    }
}

open class ARTVideoPlayerDanmakuView: ARTVideoPlayerSlidingOverlayView {
    
    /// 代理对象
    public weak var subclassDelegate: ARTVideoPlayerDanmakuViewDelegate?
    
    /// 弹幕设置选项
    public var sliderOptions: [SliderOption] = [
        SliderOption(title: "不透明度", minValue: 0, maxValue: 100, segments: [], defaultValue: 50), // 默认50%
        SliderOption(title: "显示区域", minValue: 0, maxValue: 3, segments: ["1/4屏", "2/4屏", "3/4屏", "4/4屏"], defaultValue: 2), // 默认中间的2/4屏
        SliderOption(title: "字体大小", minValue: 0, maxValue: 4, segments: ["小", "较小", "适中", "较大", "大"], defaultValue: 2), // 默认适中
        SliderOption(title: "移动速度", minValue: 0, maxValue: 4, segments: ["慢", "较慢", "适中", "较快", "快"], defaultValue: 2) // 默认适中
    ]
    
    // MARK: - Initializatio
    
    public init(_ subclassDelegate: ARTVideoPlayerDanmakuViewDelegate? = nil) {
        self.subclassDelegate = subclassDelegate
        super.init(subclassDelegate)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Override Super Methods
    
    open override func setupViews() {
        super.setupViews()
        titleLabel.text = "弹幕设置"
        setupCollectionView()
    }
    
    open override func handleSortingTapGesture(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: containerView)
        if !collectionView.frame.contains(location) && !restoreButton.frame.contains(location) {
            hideExtensionsView()
        }
    }
    
    // MARK: - Button Actions
    
    open override func didTapRestoreButton() { // 恢复按钮
        hideExtensionsView()
    }
    
    open override func showExtensionsView(_ completion: (() -> Void)? = nil) {
        super.showExtensionsView(completion)
        collectionView.reloadData()
    }
}

// MARK: - Setup Initializer

extension ARTVideoPlayerDanmakuView {
    
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
        collectionView.registerCell(ARTVideoPlayerDanmakuCell.self)
        containerView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(separatorLineView.snp.bottom).offset(ARTAdaptedValue(16.0))
            make.left.right.equalTo(separatorLineView)
            make.bottom.equalTo(-ARTAdaptedValue(16.0))
        }
    }
}
