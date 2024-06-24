//
//  UICollectionView+ARTExtension.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/5/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

extension UICollectionView {
    
    /// 注册一个 UICollectionViewCell 子类.
    ///
    /// - Parameter cellClass: UICollectionViewCell 子类的类型.
    public func registerCell(_ cellClass: AnyClass) {
        register(cellClass, forCellWithReuseIdentifier: String(describing: cellClass))
    }
    
    /// 注册一个 UICollectionReusableView 子类作为段头视图.
    ///
    /// - Parameter headerClass: UICollectionReusableView 子类的类型.
    public func registerSectionHeader(_ headerClass: AnyClass) {
        register(headerClass, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: headerClass))
    }
    
    /// 注册一个 UICollectionReusableView 子类作为段尾视图.
    ///
    /// - Parameter footerClass: UICollectionReusableView 子类的类型.
    public func registerSectionFooter(_ footerClass: AnyClass) {
        register(footerClass, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: footerClass))
    }
    
    /// 注册一个 UICollectionReusableView 子类.
    ///
    /// - Parameters:
    ///   - viewClass: UICollectionReusableView 子类的类型.
    ///   - kind: 视图类型，可以是段头视图或段尾视图.
    ///   - identifier: 重用标识符.
    public func registerReusableView(_ viewClass: AnyClass, ofKind kind: String, withIdentifier identifier: String) {
        register(viewClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
    }
    
    /// 从缓存中获取一个 UICollectionViewCell 子类.
    /// - Parameter indexPath: 索引路径.
    /// - Returns: UICollectionViewCell 子类.
    /// - Note: 该方法需要在注册之后调用.
    public func dequeueCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as! T
    }
}

