//
//  ARTCollectionViewConfigModel.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/5/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

/// 定义用于设置集合视图图层圆角的枚举.
public enum ARTCollectionCornerMask: Int {
    /// <指定elementKindSectionHeader起点和elementKindSectionFooter结束点为圆角裁切点>.
    case art_layerDefaultCorner     = 1
    
    /// <指定cell顶部的左上角和右上角为圆角裁切点>.
    case art_layerMinXMinYCorner    = 2
    
    /// <指定cell顶部的左下角和右下角为圆角裁切点>.
    case art_layerMinXMaxYCorner    = 3
    
    /// <指定cell四个角为圆角裁切点>.
    case art_layerAllCorner         = 4
}

// MARK: - ARTCollectionViewConfigModel
public class ARTCollectionViewConfigModel: NSObject {
    
    /// 边框宽度.
    public var borderWidth: CGFloat = 0.0
    
    /// 边框颜色.
    public var borderColor: UIColor?
    
    /// 背景颜色.
    public var backgroundColor: UIColor?
    
    /// 阴影颜色.
    public var shadowColor: UIColor?
    
    /// 阴影偏移量.
    public var shadowOffset: CGSize = .zero
    
    /// 阴影透明度.
    public var shadowOpacity: Float = 0.0
    
    /// 阴影圆角.
    public var shadowRadius: CGFloat = 0.0
    
    /// 圆角.
    public var cornerRadius: CGFloat = 0.0
    
    /// 指定应用圆角效果需设定cornerRadius大小.
    /// - Parameters:
    ///   - layerMinXMinYCorner: 左上角.
    ///   - layerMaxXMinYCorner: 右上角.
    ///   - layerMinXMaxYCorner: 左下角.
    ///   - layerMaxXMaxYCorner: 右下角.
    public var maskedCorners: CACornerMask?
    
    /// 图片地址或本地图片名.
    public var imageURLString: String?
    
    /// 图片填充模式 - <默认按比例缩放图片以填充>.
    public var contentMode: UIView.ContentMode = .scaleAspectFill
    
    /// view是否裁剪 - <默认裁剪>.
    public var clipsToBounds: Bool = true
    
    /// view是否设置为CollectionView宽度 - <默认Section去掉边距宽度>.
    public var isFullScreen: Bool = false
    
    /// 指定Cell圆角裁切点 - <默认elementKindSectionHeader为圆角点，与isFullScreen全屏背景圆角互斥>.
    public var collectionCornerMask: ARTCollectionCornerMask = .art_layerDefaultCorner
}
