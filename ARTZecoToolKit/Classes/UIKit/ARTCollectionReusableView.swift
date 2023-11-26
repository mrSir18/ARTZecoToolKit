//
//  ARTCollectionReusableView.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2023/11/27.
//

import UIKit

// MARK: - ARTCollectionReusableView
open class ARTCollectionReusableView: UICollectionReusableView {

    open class func dequeueReusableCell(from collectionView: UICollectionView, ofKind elementKind: String, withReuseIdentifier identifier: AnyClass, for indexPath: IndexPath) -> ARTCollectionReusableView {
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: String(describing: identifier), for: indexPath) as! ARTCollectionReusableView
        return reusableView
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// MARK: - ARTElementKindSectionHeader
open class ARTElementKindSectionHeader: ARTCollectionReusableView {

    open class func dequeueHeader(from collectionView: UICollectionView, for indexPath: IndexPath) -> ARTCollectionReusableView {
        return dequeueReusableCell(from: collectionView, ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: self, for: indexPath) as! ARTElementKindSectionHeader
    }
}

// MARK: - ARTElementKindSectionFooter
open class ARTElementKindSectionFooter: ARTCollectionReusableView {
    
    open class func dequeueFooter(from collectionView: UICollectionView, for indexPath: IndexPath) -> ARTCollectionReusableView {
        return dequeueReusableCell(from: collectionView, ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: self, for: indexPath) as! ARTElementKindSectionFooter
    }
}
