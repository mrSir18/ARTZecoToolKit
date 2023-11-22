//
//  UIColor+ARTExtension.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2023/11/22.
//

import UIKit

extension UIColor {
    /*!
     * @brief 根据十六进制初始化UIColor
     * @param hexValue 十六进制数, 例如:0xa0a0a0
     * 注意：默认透明度(alpha:1.0f)
     */
    public class func art_color(withHEXValue hexValue: Int) -> UIColor {
        return art_color(withHEXValue: hexValue, alpha: 1.0)
    }
    
    /*!
     * @brief 根据十六进制初始化UIColor
     * @param hexValue 十六进制数, 例如:0xa0a0a0
     * @param alpha 透明度
     */
    public class func art_color(withHEXValue hexValue: Int, alpha: CGFloat) -> UIColor {
        let red = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hexValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(hexValue & 0x0000FF) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /*!
     * @brief 随机UIColor
     */
    public class func art_randomColor() -> UIColor {
        return UIColor(red: CGFloat.random(in: 0...1),
                       green: CGFloat.random(in: 0...1),
                       blue: CGFloat.random(in: 0...1),
                       alpha: 1.0)
    }
}


