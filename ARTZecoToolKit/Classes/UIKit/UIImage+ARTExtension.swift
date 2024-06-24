//
//  UIImage+ARTExtension.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/5/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

extension UIImage {
    
    /// 创建一个指定颜色和大小的图片.
    ///
    /// - Parameters:
    ///   - color:  图片的颜色.
    ///   - size:   图片的大小.
    /// - Returns:  生成的图片，如果创建失败则返回 nil.
    public class func art_image(_ color: UIColor, with size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        defer { UIGraphicsEndImageContext() }

        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(origin: .zero, size: size))

        return UIGraphicsGetImageFromCurrentImageContext()
    }

    /// 创建一个指定颜色的 1x1 大小的图片.
    ///
    /// - Parameter color: 图片的颜色.
    /// - Returns: 生成的图片，如果创建失败则返回 nil.
    public class func art_image(_ color: UIColor) -> UIImage? {
        return art_image(_: color, with: CGSize(width: 1.0, height: 1.0))
    }
    
    /// 返回从中心拉伸后的图片.
    ///
    /// - Returns: 拉伸后的图片.
    public func art_stretchImageFromCenter() -> UIImage {
        return self.stretchableImage(withLeftCapWidth: Int(self.size.width * 0.5), topCapHeight: Int(self.size.height * 0.5))
    }

    /// 返回一个缩放到指定大小的图片.
    ///
    /// - Parameter size: 图片的目标大小.
    /// - Returns: 缩放后的图片.
    public func art_scaled(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

