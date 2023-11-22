//
//  CALayer+ARTExtension.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2023/11/22.
//

import UIKit

extension CALayer {
    /*!
     * @brief  设置颜色
     */
    var art_borderColor: UIColor? {
        get {
            if let cgColor = self.borderColor {
                return UIColor(cgColor: cgColor)
            }
            return nil
        }
        set {
            self.borderColor = newValue?.cgColor
        }
    }
}


