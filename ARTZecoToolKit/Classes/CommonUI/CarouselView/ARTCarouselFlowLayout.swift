//
//  ARTCarouselFlowLayout.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/7/18.
//

open class ARTCarouselFlowLayout: UICollectionViewFlowLayout {

    /// 缩放比例，默认为1.0.
    ///
    /// 当 scale >= 1.0 时，布局将失效并重新计算布局.
    /// 例如，scale = 1.2，则元素将在中心点放大1.2倍，两侧元素缩小0.8倍.
    /// 例如，scale = 0.8，则元素将在中心点缩小0.8倍，两侧元素放大1.2倍.
    /// 例如，scale = 1.0，则元素大小不变.
    /// 例如，scale = 0.0，则元素将不可见.
    var scale: CGFloat = 1.0 {
        didSet {
            if scale >= 1.0 {
                invalidateLayout()
            }
        }
    }
    
    // MARK: - UICollectionViewFlowLayout Overrides
    
    /// 准备布局.
    ///
    /// 该方法只会调用一次，用于设置布局的基本属性.
    /// 例如，设置滚动方向、元素大小、内边距等.
    /// - Note: 该方法只会调用一次.
    /// - Note: 该方法会在 `invalidateLayout()` 之后调用.
    open override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        
        /// 设置滚动方向.
        ///
        /// 水平滚动：.horizontal.
        /// 垂直滚动：.vertical.
        /// - Note: 默认为水平滚动，根据滚动方向设置边距，使得元素居中显示.
        let inset: CGFloat
        if scrollDirection == .horizontal {
            inset = (collectionView.bounds.width - itemSize.width) / 2
            sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        } else {
            inset = (collectionView.bounds.height - itemSize.height) / 2
            sectionInset = UIEdgeInsets(top: inset, left: 0, bottom: inset, right: 0)
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
            var scale: CGFloat = 1.0
            var absOffset: CGFloat = 0.0

            if scrollDirection == .horizontal {
                absOffset = abs(attribute.center.x - centerX)
                let distance = itemSize.width + minimumLineSpacing
                if absOffset < distance { /// 如果元素距离中心点小于指定距离，则计算缩放比例.
                    scale = (1 - absOffset / distance) * (self.scale - 1) + 1
                }
            } else {
                absOffset = abs(attribute.center.y - centerY)
                let distance = itemSize.height + minimumLineSpacing
                if absOffset < distance { /// 如果元素距离中心点小于指定距离，则计算缩放比例.
                    scale = (1 - absOffset / distance) * (self.scale - 1) + 1
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

