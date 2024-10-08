//
//  UIColor+ARTExtension.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/5/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

extension UIColor {
    
    /// 根据十六进制值创建一个颜色对象.
    ///
    /// - Parameters:
    ///   - hexValue: 十六进制值，例如 0xFF0000 表示红色.
    /// - Returns: 生成的颜色对象.
    public class func art_color(withHEXValue hexValue: Int) -> UIColor {
        return art_color(withHEXValue: hexValue, alpha: 1.0)
    }
    
    /// 根据十六进制值创建一个颜色对象.
    ///
    /// - Parameters:
    ///   - hexValue: 十六进制值，例如 0xFF0000 表示红色.
    ///   - alpha: 颜色的透明度，取值范围为 0 到 1，默认为不透明.
    /// - Returns: 生成的颜色对象.
    public class func art_color(withHEXValue hexValue: Int, alpha: CGFloat) -> UIColor {
        let red = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hexValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(hexValue & 0x0000FF) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /// 返回一个随机颜色对象.
    ///
    /// - Returns: 随机生成的颜色对象.
    public class func art_randomColor() -> UIColor {
        return UIColor(red: CGFloat.random(in: 0...1),
                       green: CGFloat.random(in: 0...1),
                       blue: CGFloat.random(in: 0...1),
                       alpha: 1.0)
    }
}
