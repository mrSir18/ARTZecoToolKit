//
//  ARTCollectionView+Extension.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2023/11/22.
//

import UIKit

extension UICollectionView {
    public func registerCell(_ cls: AnyClass) {
        register(cls, forCellWithReuseIdentifier: String(describing: cls))
    }
    
    public func registerElementKindSectionHeader(_ cls: AnyClass) {
        registerElementKindReusableView(cls, kind: UICollectionElementKindSectionHeader, identifier: String(describing: cls))
    }
    
    public func registerElementKindSectionFooter(_ cls: AnyClass) {
        registerElementKindReusableView(cls, kind: UICollectionElementKindSectionFooter, identifier: String(describing: cls))
    }
    
    public func registerElementKindReusableView(_ cls: AnyClass, kind: String, identifier: String) {
        register(cls, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
    }
}

