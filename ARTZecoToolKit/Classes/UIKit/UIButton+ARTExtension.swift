//
//  ARTExtension.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/5/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

private var art_customValueKey: UInt8 = 0

extension UIButton {
    
    /// 自定义值，用于保存额外的数据.
    ///
    /// - Note: 使用 `objc_setAssociatedObject` 和 `objc_getAssociatedObject` 函数来实现.
    var art_customValue: Any? {
        get {
            return objc_getAssociatedObject(self, &art_customValueKey)
        }
        set {
            objc_setAssociatedObject(self, &art_customValueKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 设置图像为指定的状态，将其缩放到指定的大小.
    ///
    /// - Parameters:
    ///   - image:  要设置的图像.
    ///   - size:   期望的图像大小.
    ///   - state:  使用指定镜像的状态.
    public func art_setImage(_ image: UIImage?, scaledTo size: CGSize, for state: UIControl.State) {
        guard let image = image else {
            setImage(nil, for: state)
            return
        }
        let scaledImage = image.art_scaled(to: size)
        setImage(scaledImage, for: state)
    }
}

