//
//  ARTCarouselView.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/7/18.
//

@objc public protocol ARTCarouselViewProtocol: AnyObject {
    
    // MARK: - required Methods
    
    /// 注册 Cell 类型.
    ///
    /// - Parameters:
    ///  - collectionView: UICollectionView.
    /// - Note: 由于不同的视图需要注册不同的 Cell 类型，所以需要重写该方法.
    func registerCells(for collectionView: UICollectionView)
    
    /// 获取 Cell 数量.
    ///
    /// - Parameters:
    ///  - collectionView: UICollectionView.
    ///  - Returns: Int.
    /// - Warning: 该方法为必选方法，如果不重写则默认返回 0.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    
    /// 获取 Cell 对象.
    ///
    /// - Parameters:
    ///  - collectionView: UICollectionView.
    ///  - indexPath: IndexPath.
    ///  - Returns: UICollectionViewCell.
    /// - Note: 由于不同的视图需要返回不同的 Cell 对象，所以需要重写该方法.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    
    
    // MARK: - optional Methods
    
    /// 点击 Cell 事件.
    ///
    /// - Parameters:
    ///  - collectionView: UICollectionView.
    ///  - indexPath: IndexPath.
    /// - Note: 由于不同的视图需要实现不同的点击事件，所以需要重写该方法.
    @objc optional func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    
    /// 获取 Cell 尺寸.
    ///
    /// - Parameters:
    ///  - collectionView: UICollectionView.
    ///  - layout: UICollectionViewLayout.
    ///  - indexPath: IndexPath.
    ///  - Returns: CGSize.
    /// - Warning: 该方法为可选方法，如果不重写则默认返回 CGSize.zero.
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    
    /// 获取 Cell 行间距.
    ///
    /// - Parameters:
    ///  - collectionView: UICollectionView.
    ///  - layout: UICollectionViewLayout.
    ///  - section: Int.
    ///  - Returns: CGFloat.
    /// - Warning: 该方法为可选方法，如果不重写则默认返回 0.
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    
    /// 获取 Cell 列间距.
    ///
    /// - Parameters:
    ///  - collectionView: UICollectionView.
    ///  - layout: UICollectionViewLayout.
    ///  - section: Int.
    ///  - Returns: CGFloat.
    /// - Warning: 该方法为可选方法，如果不重写则默认返回 0.
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    
    /// 获取 Cell 缩放.
    ///
    /// - Parameters:
    ///  - collectionView: UICollectionView.
    ///  - layout: UICollectionViewLayout.
    ///  - indexPath: IndexPath.
    ///  - Returns: CGFloat.
    /// - Warning: 该方法为可选方法，如果不重写则默认返回 1.0.
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, scaleForItemAtIndexPath indexPath: IndexPath) -> CGFloat
    
    /// 开始拖拽到某个 Cell的位置.
    ///
    /// - Parameters:
    ///  - carouselView: ARTCarouselView.
    ///  - indexPath: IndexPath.
    /// - Note: 由于不同的视图需要实现不同的滚动事件，所以需要重写该方法.
    @objc optional func carouselView(_ carouselView: ARTCarouselView, didBeginDraggingItemAt index: Int)
    
    /// 滚动结束到某个 Cell的位置.
    ///
    /// - Parameters:
    ///  - carouselView: ARTCarouselView.
    ///  - indexPath: IndexPath.
    /// - Note: 由于不同的视图需要实现不同的滚动结束事件，所以需要重写该方法.
    @objc optional func carouselView(_ carouselView: ARTCarouselView, didEndScrollingAnimationAt index: Int)
    
    /// 滚动到某个 Cell的位置.
    ///
    /// - Parameters:
    /// - carouselView: ARTCarouselView.
    /// - indexPath: IndexPath.
    /// - Note: 由于不同的视图需要实现不同的滚动事件，所以需要重写该方法.
    @objc optional func carouselView(_ carouselView: ARTCarouselView, didScrollToItemAt index: Int)
}

open class ARTCarouselView: UIView {
    
    /// 代理对象
    internal weak var delegate: ARTCarouselViewProtocol?
    
    /// 视图列表
    internal var collectionView: UICollectionView!
    
    internal var layout: ARTCarouselFlowLayout!
    
    /// 滚动方向 默认水平滚动
    public var scrollDirection: UICollectionView.ScrollDirection = .horizontal {
        didSet { updateCollectionViewLayout() }
    }
    
    /// 是否分页 默认 true
    public var isPagingEnabled: Bool = true {
        didSet { updatePagingEnabled() }
    }
    
    /// 起始下标 默认 0
    public var startIndex: Int?
    
    /// 是否自动滚动 默认 true
    public var isAutoScroll: Bool = true
    
    /// 自动滚动时间间隔 默认 3 秒
    public var autoScrollInterval: TimeInterval = 3.0
    
    /// 是否循环滚动 默认 true
    public var isCycleScroll: Bool = true
    
    /// 定时器
    private var timer: Timer?
    
    /// 扩大 item 数量倍数
    internal var expandedItemCount: Int = 0
    
    /// 实际Item总数
    internal var realItemCount: Int = 0
    
    
    // MARK: - Life Cycle
    
    public convenience init(_ delegate: ARTCarouselViewProtocol) {
        self.init()
        self.backgroundColor = .clear
        self.delegate        = delegate
        setupViews()
    }
    
    // MARK: - Override Super Methods
    
    /// 重写父类方法，设置子视图.
    ///
    /// - Note: 由于子类需要自定义视图，所以需要重写该方法.
    open func setupViews() {
        
        /// 创建列表视图
        layout = ARTCarouselFlowLayout(self)
        layout.scrollDirection = scrollDirection
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInsetAdjustmentBehavior   = .never
        collectionView.showsHorizontalScrollIndicator   = false
        collectionView.showsVerticalScrollIndicator     = false
        collectionView.backgroundColor                  = .clear
        collectionView.delegate                         = self
        collectionView.dataSource                       = self
        collectionView.isPagingEnabled                  = false
        collectionView.contentInset                     = .zero
        delegate?.registerCells(for: collectionView)
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        /// 如果有初始索引，将目标索引调整为初始索引，并且重置初始索引.
        ///
        /// - Note: 由于在 reloadData 之后会调整显示位置，所以需要在 layoutSubviews 之后调整显示位置.
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.adjustFirstPageDisplay()
        }
    }
    
    override public func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if newWindow != nil {
            startScrollTimer()
        } else {
            stopScrollTimer()
        }
    }
    
    // MARK: - Public Methods
    
    public func reloadData() {
        realItemCount = numberOfItems(inSection: 0) /// 获取实际的 item 数量 section 默认为 0.
        expandedItemCount = calculateItemCount(for: realItemCount) /// item 扩大倍数.
        collectionView.reloadData()
        collectionView.setContentOffset(.zero, animated: true)
    }
    
    /// 获取当前所在位置的 IndexItem.
    ///
    /// - Returns: IndexItem? 当前所在位置的 IndexItem，如果无法确定位置则返回 nil.
    public func currentVisibleIndexItem() -> Int? {
        let visibleCells = collectionView.visibleCells
        guard !visibleCells.isEmpty else {
            return nil
        }
        let closestCell = visibleCells.min { (cell1, cell2) -> Bool in /// 找到距离中心点最近的 cell.
            let distance1 = distanceFromCenter(of: cell1)
            let distance2 = distanceFromCenter(of: cell2)
            return distance1 < distance2
        }
        return closestCell.flatMap { collectionView.indexPath(for: $0)?.item }
    }
    
    /// 获取当前Cell.
    ///
    /// - Returns: UICollectionViewCell? 当前所在位置的 UICollectionViewCell，如果无法确定位置则返回 nil.
    /// - Note: 该方法为可选方法，如果不重写则默认返回 nil.
    public func currentVisibleCell() -> UICollectionViewCell? {
        let visibleCells = collectionView.visibleCells
        guard !visibleCells.isEmpty else {
            return nil
        }
        let closestCell = visibleCells.min { (cell1, cell2) -> Bool in
            let distance1 = distanceFromCenter(of: cell1)
            let distance2 = distanceFromCenter(of: cell2)
            return distance1 < distance2
        }
        return closestCell
    }
}

// MARK: - Private Methods

extension ARTCarouselView {
    
    /// 更新布局.
    ///
    /// - Note: 由于不同的视图需要实现不同的布局，所以需要重写该方法.
    private func updateCollectionViewLayout() {
        guard let layout = collectionView.collectionViewLayout as? ARTCarouselFlowLayout else { return }
        layout.scrollDirection = scrollDirection
        collectionView.collectionViewLayout.invalidateLayout() /// 重新布局.
    }
    
    /// 更新分页状态.
    ///
    /// - Note: 由于缩放比例不同，分页状态也会不同，所以需要根据缩放比例来判断是否启用分页.
    /// - Note: 该方法为可选方法，如果不重写则默认启用分页.
    private func updatePagingEnabled() {
//        guard let indexPaths = collectionView.indexPathsForVisibleItems.first else {
//            collectionView.isPagingEnabled = isPagingEnabled
//            return
//        }
//        let scale = delegate?.collectionView?(collectionView, layout: collectionView.collectionViewLayout, scaleForItemAtIndexPath: indexPaths) ?? 1.0
//        collectionView.isPagingEnabled = isPagingEnabled && scale == 1.0 /// 当用户设定了分页状态并且缩放比例为 1.0 时启用分页，否则不启用分页.
    }
    
    /// 获取Item数量.
    ///
    /// - Parameters:
    ///  - section: Int section.
    /// - Returns: 所有单元格数量.
    /// - Note: 该方法为可选方法，如果不重写则默认返回 0.
    private func numberOfItems(inSection section: Int) -> Int {
        return delegate?.collectionView(collectionView, numberOfItemsInSection: section) ?? 0
    }
    
    /// 循环滚动时，item 数量扩大 200 倍.
    ///
    /// - Parameters:
    ///  - realItemCount: 实际的 item 数量.
    /// - Returns: Int 扩大后的 item 数量.
    /// - Note: 如果 item 数小于等于 1 或者不是循环滚动模式，则直接返回真实的项目数.
    private func calculateItemCount(for realItemCount: Int) -> Int {
        if realItemCount <= 1 || !isCycleScroll { /// 如果 item 数小于等于 1 或者不是循环滚动模式，则直接返回真实的项目数.
            return realItemCount
        }
        return realItemCount * 200
    }

    /// 计算给定单元格的中心点与 collectionView 中心点之间的距离.
    ///
    /// - Parameters:
    ///  - cell: UICollectionViewCell.
    /// - Returns: CGFloat 距离.
    private func distanceFromCenter(of cell: UICollectionViewCell) -> CGFloat {
        let cellCenter = CGPoint(x: cell.frame.midX, y: cell.frame.midY)
        let collectionViewCenter = CGPoint(x: collectionView.bounds.midX, y: collectionView.bounds.midY)
        return hypot(cellCenter.x - collectionViewCenter.x, cellCenter.y - collectionViewCenter.y)
    }
    
    /// 调整轮播视图的首页显示.
    ///
    /// - Note: 由于在 reloadData 之后会调整显示位置，所以需要在 layoutSubview之后调整显示位置.
    private func adjustFirstPageDisplay() {
        guard !collectionView.frame.isEmpty,
              currentVisibleIndexItem() == 0,
              expandedItemCount > 1 else { return }
        
        var targetIndex = isCycleScroll ? expandedItemCount / 2 : 0 /// 计算目标索引，若为无限轮播模式则为 expandedItemCount 的中间索引，否则为 0.
        
        if let startIndex = startIndex { /// 如果有初始索引，将目标索引调整为初始索引，并且重置初始索引.
            targetIndex += max(0, min(startIndex, realItemCount - 1))
            self.startIndex = nil
        }
        adjustItemToCenter(at: targetIndex)
    }
    
    /// 调整轮播视图的末页显示.
    ///
    /// - Note: 由于在 reloadData 之后会调整显示位置，所以需要在 layoutSubview之后调整显示位置.
    private func adjustLastPageDisplay() {
        guard let currentIndex = currentVisibleIndexItem(), /// 确保当前索引是最后一个索引并且 itemsCount 大于 1.
                currentIndex == expandedItemCount - 1,
                expandedItemCount > 1 else { return }
        
        let targetIndex: Int
        if isCycleScroll { /// 无限轮播模式：目标索引为中间索引前一项.
            targetIndex = expandedItemCount / 2 - 1
        } else { /// 非无限轮播模式：目标索引为实际项数的最后一项.
            targetIndex = realItemCount - 1
        }
        adjustItemToCenter(at: targetIndex)
    }
    
    /// 将指定索引的 item 居中显示.
    ///
    /// - Parameters:
    ///  - index: 指定的索引.
    /// - Note: 该方法会根据滚动方向调整 contentOffset.
    private func adjustItemToCenter(at index: Int) {
        guard let attributes = collectionView.layoutAttributesForItem(at: IndexPath(item: index, section: 0)) else { return }
        
        let edgeOffset: CGFloat
        if scrollDirection == .horizontal { /// 水平方向滚动，计算水平边缘偏移量.
            edgeOffset = (collectionView.bounds.width - layout.art_itemSize.width) / 2
            collectionView.setContentOffset(CGPoint(x: attributes.frame.minX - edgeOffset, y: 0), animated: false)
        } else { /// 垂直方向滚动，计算垂直边缘偏移量.
            edgeOffset = (collectionView.bounds.height - layout.art_itemSize.height) / 2
            collectionView.setContentOffset(CGPoint(x: 0, y: attributes.frame.minY - edgeOffset), animated: false)
        }
    }
}

// MARK: - UIscrollViewDelegate

extension ARTCarouselView {
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) { /// 开始拖拽时停止定时器.
        if isAutoScroll { stopScrollTimer() }
        adjustLastPageDisplay()
        adjustFirstPageDisplay()

        if let currentIndex = currentVisibleIndexItem() {
            let index = currentIndex % realItemCount
            delegate?.carouselView?(self, didBeginDraggingItemAt: index)
        }
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) { /// 结束拖拽时开启定时器.
        if isAutoScroll { startScrollTimer() }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) { /// 结束减速时调整显示位置.
        scrollViewDidEndScrollingAnimation(scrollView)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) { /// 结束滚动动画时调整显示位置.
        if let currentIndex = currentVisibleIndexItem() {
            let index = currentIndex % realItemCount
            delegate?.carouselView?(self, didEndScrollingAnimationAt: index)
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) { /// 滚动时调整显示位置.
        if let currentIndex = currentVisibleIndexItem() {
            let index = currentIndex % realItemCount
            delegate?.carouselView?(self, didScrollToItemAt: index)
        }
    }
}

// MARK: - Timer Methods

extension ARTCarouselView {
    
    /// 开启定时器.
    ///
    /// - Note: 由于不同的视图需要实现不同的定时器事件，所以需要重写该方法.
    /// - Warning: 该方法为可选方法，如果不重写则默认返回.
    public func startScrollTimer() {
        guard isAutoScroll, expandedItemCount > 1 else { /// 如果不需要自动滚动或项目数不足以滚动，则停止定时器.
            stopScrollTimer()
            return
        }
        stopScrollTimer()
        timer = Timer.scheduledTimer(timeInterval: autoScrollInterval,
                                      target: self,
                                      selector: #selector(autoScroll),
                                      userInfo: nil,
                                      repeats: true)
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    /// 关闭定时器.
    ///
    /// - Note: 由于不同的视图需要实现不同的定时器事件，所以需要重写该方法.
    /// - Warning: 该方法为可选方法，如果不重写则默认返回.
    public func stopScrollTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    /// 自动滚动.
    ///
    /// - Note: 由于不同的视图需要实现不同的滚动事件，所以需要重写该方法.
    /// - Warning: 该方法为可选方法，如果不重写则默认返回.
    @objc public func autoScroll() {
        guard let currentIndex = currentVisibleIndexItem() else { return }

        var targetIndex = currentIndex + 1
        if currentIndex == expandedItemCount - 1 { /// 如果当前索引是最后一个索引.
            if !isCycleScroll { /// 如果不是循环滚动模式，则不做任何操作.
                stopScrollTimer()
                return
            }
            adjustLastPageDisplay()
            targetIndex = expandedItemCount / 2
        }
        let scrollPosition: UICollectionView.ScrollPosition
        switch scrollDirection {
        case .horizontal:
            scrollPosition = .centeredHorizontally
        case .vertical:
            scrollPosition = .centeredVertically
        @unknown default:
            scrollPosition = .centeredHorizontally // 默认值.
        }
        collectionView.scrollToItem(at: IndexPath(item: targetIndex, section: 0), at: scrollPosition, animated: true)
    }
}
