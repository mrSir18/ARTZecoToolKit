//
//  CALayer+ARTExtension.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/5/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

extension CALayer {
    
    /// 视图的边框颜色.
    ///
    /// 用于设置或获取视图的边框颜色，边框颜色可为空.
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


