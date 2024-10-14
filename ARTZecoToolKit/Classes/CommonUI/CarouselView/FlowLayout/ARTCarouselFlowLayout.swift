//
//  ARTCarouselFlowLayout.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/7/18.
//

@objc public protocol ARTCarouselFlowLayoutProtocol: UICollectionViewDelegateFlowLayout {
    
    /// 获取元素的缩放比例.
    ///
    /// - Parameters:
    ///  - collectionView: 当前的 UICollectionView.
    ///  - collectionViewLayout: 当前的 ARTCarouselFlowLayout.
    ///  - indexPath: 当前元素的 IndexPath.
    ///  - Returns: 元素的缩放比例.
    /// - Note: 如果不实现该方法，将会使用默认值 1.0.
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: ARTCarouselFlowLayout, scaleForItemAtIndexPath indexPath: IndexPath) -> CGFloat
}

open class ARTCarouselFlowLayout: UICollectionViewFlowLayout {
    
    /// 遵循 ARTCarouselFlowLayout 协议的弱引用委托对象.
    weak var art_delegate: ARTCarouselFlowLayoutProtocol?
    
    /// itemSIze.
    internal var art_itemSize: CGSize = .zero
    
    /// 行间距的最小值.
    internal var art_minimumLineSpacing: CGFloat = 0.0
    
    /// 元素的缩放比例.
    internal var art_itemScale: CGFloat = 1.0
    
    
    // MARK: - Initialization
    
    public init(_ delegate: ARTCarouselFlowLayoutProtocol?) {
        super.init()
        self.art_delegate = delegate
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ARTCarouselFlowLayout {
    
    /// 准备布局.
    ///
    /// 该方法只会调用一次，用于设置布局的基本属性.
    /// 例如，设置滚动方向、元素大小、内边距等.
    /// - Note: 该方法只会调用一次.
    /// - Note: 该方法会在 `invalidateLayout()` 之后调用.
    open override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        
        /// 设置布局属性
        let section = 0 /// 根据需要调整段的索引
        self.art_minimumLineSpacing = delegate_minimumLineSpacingForSectionAt(section)
        
        let numberOfItems = collectionView.numberOfItems(inSection: section)
        for index in 0..<numberOfItems {
            let indexPath = IndexPath(item: index, section: 0)
            self.art_itemSize = delegate_sizeForItemAt(indexPath)
            self.art_itemScale = delegate_scaleForItemAtIndexPath(indexPath)
            
            /// 设置滚动方向.
            ///
            /// 水平滚动：.horizontal.
            /// 垂直滚动：.vertical.
            /// - Note: 默认为水平滚动，根据滚动方向设置边距，使得元素居中显示.
            let inset: CGFloat
            if scrollDirection == .horizontal {
                inset = (collectionView.bounds.width - self.art_itemSize.width) / 2
                sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
            } else {
                inset = (collectionView.bounds.height - self.art_itemSize.height) / 2
                sectionInset = UIEdgeInsets(top: inset, left: 0, bottom: inset, right: 0)
            }
        }
    }
    
    /// 返回可见区域的内容大小.
    ///
    /// 该方法返回可见区域的大小，用于确定滚动范围,
    /// - Note: 该方法会在 `prepare()` 之后调用,
    /// - Note: true，以便在边界更改时使布局失效并重新计算布局,
    open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    /// 返回指定区域内的所有元素的布局属性.
    ///
    /// - Parameters:
    ///  - rect: 指定区域.
    ///  - Returns: 指定区域内的所有元素的布局属性.
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let superAttributes = super.layoutAttributesForElements(in: rect),
              let collectionView = collectionView else { /// 获取父类计算的所有布局属性.
            return nil
        }
        /// 复制父类计算的所有布局属性.
        let attributes = superAttributes.map { $0.copy() as! UICollectionViewLayoutAttributes }
        
        /// 计算中心点.
        let centerX = collectionView.bounds.width * 0.5 + collectionView.contentOffset.x
        let centerY = collectionView.bounds.height * 0.5 + collectionView.contentOffset.y
        
        for attribute in attributes { /// 遍历所有布局属性，计算缩放比例.
            let art_itemSize = delegate_sizeForItemAt(attribute.indexPath)
            let art_itemScale = delegate_scaleForItemAtIndexPath(attribute.indexPath)
            var scale: CGFloat = 1.0
            var absOffset: CGFloat = 0.0
            
            if scrollDirection == .horizontal {
                absOffset = abs(attribute.center.x - centerX)
                let distance = art_itemSize.width + self.art_minimumLineSpacing
                if absOffset < distance { /// 如果元素距离中心点小于指定距离，则计算缩放比例.
                    scale = (1 - absOffset / distance) * (art_itemScale - 1) + 1
                }
            } else {
                absOffset = abs(attribute.center.y - centerY)
                let distance = art_itemSize.height + self.art_minimumLineSpacing
                if absOffset < distance { /// 如果元素距离中心点小于指定距离，则计算缩放比例.
                    scale = (1 - absOffset / distance) * (art_itemScale - 1) + 1
                }
            }
            /// 设置布局属性.
            attribute.zIndex = Int(scale * 100)
            attribute.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
        
        return attributes
    }
    
    /// 返回滚动停止时的目标内容偏移量.
    ///
    /// - Parameters:
    ///   - proposedContentOffset: 建议的内容偏移量
    ///   - velocity: 滚动速度
    /// - Returns: 调整后的目标内容偏移量
    /// - Note: 该方法会在滚动停止时调用.
    open override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var minOffsetDifference = CGFloat.greatestFiniteMagnitude
        var targetOffset = proposedContentOffset
        guard let collectionView = collectionView else {
            return targetOffset
        }
        
        /// 计算中心点.
        let collectionViewBoundsSize = collectionView.bounds.size
        let centerOffsetX = targetOffset.x + collectionViewBoundsSize.width / 2
        let centerOffsetY = targetOffset.y + collectionViewBoundsSize.height / 2
        
        var visibleRect: CGRect
        if scrollDirection == .horizontal { /// 根据滚动方向设置可见区域的rect.
            visibleRect = CGRect(origin: CGPoint(x: targetOffset.x, y: 0), size: collectionViewBoundsSize)
        } else {
            visibleRect = CGRect(origin: CGPoint(x: 0, y: targetOffset.y), size: collectionViewBoundsSize)
        }
        
        /// 获取可见区域内的布局属性.
        if let visibleAttributes = layoutAttributesForElements(in: visibleRect) {
            for attributes in visibleAttributes { /// 遍历可见区域内的布局属性, 计算最小偏移差异.
                var distanceToCenter: CGFloat = 0
                if scrollDirection == .horizontal { /// 计算元素中心点与中心点的距离.
                    distanceToCenter = attributes.center.x - centerOffsetX
                } else {
                    distanceToCenter = attributes.center.y - centerOffsetY
                }
                
                if abs(minOffsetDifference) > abs(distanceToCenter) { /// 记录最小偏移差异.
                    minOffsetDifference = distanceToCenter
                }
            }
        }
        
        if scrollDirection == .horizontal { /// 根据滚动方向调整目标内容偏移量.
            targetOffset.x += minOffsetDifference
        } else {
            targetOffset.y += minOffsetDifference
        }
        return targetOffset
    }
}

// MARK: - Private系统方法: UICollectionViewDelegateFlowLayout

extension ARTCarouselFlowLayout {
    
    /// 获取委托方法返回的指定itemSize.
    ///
    /// - Parameters:
    /// - section: 段的索引.
    /// - Returns: itemSize.
    /// - Note: 如果不实现该方法，则使用默认UIEdgeInsets.zero.
    private func delegate_sizeForItemAt(_ indexPath: IndexPath) -> CGSize {
        return self.art_delegate?.collectionView?(collectionView!, layout: self, sizeForItemAt: indexPath) ?? itemSize
    }
    
    /// 获取委托方法返回的指定段的最小行间距.
    ///
    /// - Parameters:
    /// - section: 段的索引.
    /// - Returns: 最小行间距.
    /// - Note: 如果不实现该方法，则使用默认最小行间距0.0.
    private func delegate_minimumLineSpacingForSectionAt(_ section: Int) -> CGFloat {
        return self.art_delegate?.collectionView?(collectionView!, layout: self, minimumLineSpacingForSectionAt: section) ?? 0.0
    }
    
    /// 获取委托方法返回的指定item的缩放比例.
    ///
    /// - Parameters:
    ///  - indexPath: 索引.
    ///  - Returns: 缩放比例.
    /// - Note: 如果不实现该方法，则使用默认缩放比例1.0.
    private func delegate_scaleForItemAtIndexPath(_ indexPath: IndexPath) -> CGFloat {
        return self.art_delegate?.collectionView?(collectionView!, layout: self, scaleForItemAtIndexPath: indexPath) ?? 1.0
    }
}
