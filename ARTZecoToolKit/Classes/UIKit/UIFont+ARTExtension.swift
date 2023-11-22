//
//  UIFont+ARTExtension.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2023/11/22.
//

import UIKit

extension UIFont {
    /*!
     * @brief 苹方常规字体 (PingFangSC-Regular)
     * @param fontSize 字体大小
     */
    public class func art_fontPingFangSC(_ fontSize: CGFloat) -> UIFont? {
        return UIFont(name: "PingFangSC-Regular", size: fontSize)
    }

    /*!
     * @brief 平方中等字体 (PingFangSC-Medium)
     * @param fontSize 字体大小
     */
    public class func art_fontPingFangSCMedium(_ fontSize: CGFloat) -> UIFont? {
        return UIFont(name: "PingFangSC-Medium", size: fontSize)
    }

    /*!
     * @brief 平方加粗字体 (PingFangSC-Semibold)
     * @param fontSize 字体大小
     */
    public class func art_fontPingFangSCSemibold(_ fontSize: CGFloat) -> UIFont? {
        return UIFont(name: "PingFangSC-Semibold", size: fontSize)
    }
}

