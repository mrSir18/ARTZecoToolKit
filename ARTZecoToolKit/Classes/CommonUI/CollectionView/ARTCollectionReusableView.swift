//
//  ARTCollectionReusableView.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/5/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

// MARK: - ARTCollectionReusableView

/// 自定义集合视图可重用视图基类.
open class ARTCollectionReusableView: UICollectionReusableView {
    
    /// 从集合视图获取可重用的视图实例.
    ///
    /// - Parameters:
    ///   - collectionView: 集合视图对象.
    ///   - elementKind: 视图类型.
    ///   - identifier: 视图标识符.
    ///   - indexPath: 索引路径.
    /// - Returns: 可重用的视图实例.
    open class func dequeueReusableView(from collectionView: UICollectionView, ofKind elementKind: String, withReuseIdentifier identifier: AnyClass, for indexPath: IndexPath) -> ARTCollectionReusableView {
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: String(describing: identifier), for: indexPath) as! ARTCollectionReusableView
        return reusableView
    }
    
    /// 初始化方法，设置背景色为白色.
    ///
    /// - Parameter frame: 视图的框架.
    override public init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// MARK: - ARTSectionHeaderView

/// 自定义集合视图段头视图.
open class ARTSectionHeaderView: ARTCollectionReusableView {
    
    /// 从集合视图获取段头视图实例.
    ///
    /// - Parameters:
    ///   - collectionView: 集合视图对象.
    ///   - indexPath: 索引路径.
    /// - Returns: 段头视图实例.
    open class func dequeueHeader(from collectionView: UICollectionView, for indexPath: IndexPath) -> ARTSectionHeaderView {
        return dequeueReusableView(from: collectionView, ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: self, for: indexPath) as! ARTSectionHeaderView
    }
}

// MARK: - ARTSectionFooterView

/// 自定义集合视图段尾视图.
open class ARTSectionFooterView: ARTCollectionReusableView {
    
    /// 从集合视图获取段尾视图实例.
    ///
    /// - Parameters:
    ///   - collectionView: 集合视图对象.
    ///   - indexPath: 索引路径.
    /// - Returns: 段尾视图实例.
    open class func dequeueFooter(from collectionView: UICollectionView, for indexPath: IndexPath) -> ARTSectionFooterView {
        return dequeueReusableView(from: collectionView, ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: self, for: indexPath) as! ARTSectionFooterView
    }
}
