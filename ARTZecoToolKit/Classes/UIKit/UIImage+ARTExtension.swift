//
//  UIImage+ARTExtension.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2023/11/22.
//

import UIKit

extension UIImage {
    /*!
     * @brief 根据制定的颜色生成图片
     * @param color 指定的图片颜色
     * @return 生成指定颜色的图片
     */
    public class func art_image(_ color: UIColor, with size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        defer { UIGraphicsEndImageContext() }

        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(origin: .zero, size: size))

        return UIGraphicsGetImageFromCurrentImageContext()
    }

    /*!
     * @brief 根据制定的颜色生成图片
     * @param color 指定的图片颜色
     * @return 生成指定颜色的图片
     */
    public class func art_image(_ color: UIColor) -> UIImage? {
        return art_image(_: color, with: CGSize(width: 1.0, height: 1.0))
    }
    
    /*!
     * @brief 获取从中心拉伸后的图片
     * @return 拉伸后生成的新图片
     */
    public func art_stretchImageFromCenter() -> UIImage {
        return self.stretchableImage(withLeftCapWidth: Int(self.size.width * 0.5), topCapHeight: Int(self.size.height * 0.5))
    }
}

