//
//  ARTCollectionViewConfigModel.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2023/11/22.
//

import UIKit

// MARK: - ARTCollectionViewConfigModel
public class ARTCollectionViewConfigModel: NSObject {
    /// 边框宽度
    public var borderWidth: CGFloat = 0.0
    /// 边框颜色
    public var borderColor: UIColor?
    /// 背景颜色
    public var backgroundColor: UIColor?
    /// 阴影颜色
    public var shadowColor: UIColor?
    /// 阴影偏移量
    public var shadowOffset: CGSize = .zero
    /// 阴影透明度
    public var shadowOpacity: Float = 0.0
    /// 阴影圆角
    public var shadowRadius: CGFloat = 0.0
    /// 圆角
    public var cornerRadius: CGFloat = 0.0
    /// 指定应用圆角效果需设定cornerRadius大小
    /// - Parameters:
    ///   - layerMinXMinYCorner: 左上角
    ///   - layerMaxXMinYCorner: 右上角
    ///   - layerMinXMaxYCorner: 左下角
    ///   - layerMaxXMaxYCorner: 右下角
    public var maskedCorners: CACornerMask?
    /// 图片地址或本地图片名
    public var imageURLString: String?
    /// 图片填充模式 - <默认按比例缩放图片以填充>
    public var contentMode: UIView.ContentMode = .scaleAspectFill
    /// view是否裁剪 - <默认裁剪>
    public var clipsToBounds: Bool = true
}
