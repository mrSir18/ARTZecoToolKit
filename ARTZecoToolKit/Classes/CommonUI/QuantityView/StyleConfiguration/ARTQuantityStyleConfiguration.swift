//
//  ARTQuantityStyleConfiguration.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/5/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation

/// 自定义UI样式配置
@objcMembers
public class ARTQuantityStyleConfiguration: NSObject {
    
    private static var single = ARTQuantityStyleConfiguration()
    
    public class func `default`() -> ARTQuantityStyleConfiguration {
        return ARTQuantityStyleConfiguration.single
    }
    
    public class func resetConfiguration() {
        ARTQuantityStyleConfiguration.single = ARTQuantityStyleConfiguration()
    }
    
    /// 最小输入数量.
    ///
    /// - Note: 默认1.
    private var pri_minimumQuantity: Int = 1
    public var minimumQuantity: Int {
        get {
            pri_minimumQuantity
        }
        set {
            pri_minimumQuantity = max(0, newValue)
        }
    }
    
    /// 最大输入数量.
    ///
    /// - Note: 默认999.
    private var pri_maximumQuantity: Int = 999
    public var maximumQuantity: Int {
        get {
            pri_maximumQuantity
        }
        set {
            pri_maximumQuantity = max(1, newValue)
        }
    }
    
    /// 容器背景颜色.
    ///
    /// - Note: 默认0xFFFFFF.
    private var pri_containerBackgroundColor: UIColor = .art_color(withHEXValue: 0xFFFFFF)
    public var containerBackgroundColor: UIColor {
        get {
            pri_containerBackgroundColor
        }
        set {
            pri_containerBackgroundColor = newValue
        }
    }
    
    /// 容器圆角.
    ///
    /// - Note: 默认5.0.
    private var pri_cornerRadius: CGFloat = 5.0
    public var cornerRadius: CGFloat {
        get {
            pri_cornerRadius
        }
        set {
            pri_cornerRadius = max(0.0, newValue)
        }
    }

    /// 容器指定圆角效果需设定cornerRadius大小.
    ///
    /// - Note: 默认[.layerMinXMinYCorner, .layerMaxXMinYCorner,
    ///             .layerMinXMaxYCorner, .layerMaxXMaxYCorner].
    /// - Parameters:
    ///   - layerMinXMinYCorner: 左上角.
    ///   - layerMaxXMinYCorner: 右上角.
    ///   - layerMinXMaxYCorner: 左下角.
    ///   - layerMaxXMaxYCorner: 右下角.
    private var pri_maskedCorners: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner, 
                                                   .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    public var maskedCorners: CACornerMask {
        get {
            pri_maskedCorners
        }
        set {
            pri_maskedCorners = newValue
        }
    }
    
    /// 容器边框颜色.
    ///
    /// - Note: 默认0xD0D1D3.
    private var pri_borderColor: UIColor = .art_color(withHEXValue: 0xD0D1D3)
    public var borderColor: UIColor {
        get {
            pri_borderColor
        }
        set {
            pri_borderColor = newValue
        }
    }
    
    /// 容器边框宽度.
    ///
    /// - Note: 默认0.5.
    private var pri_borderWidth: CGFloat = 0.5
    public var borderWidth: CGFloat {
        get {
            pri_borderWidth
        }
        set {
            pri_borderWidth = max(0.0, newValue)
        }
    }
    
    /// 容器圆角是否裁剪.
    ///
    /// - Note: 默认true.
    private var pri_clipsToBounds: Bool = true
    public var clipsToBounds: Bool {
        get {
            pri_clipsToBounds
        }
        set {
            pri_clipsToBounds = newValue
        }
    }
    
    /// 按钮背景颜色.
    ///
    /// - Note: 默认0xF3F3F4.
    private var pri_buttonBackgroundColor: UIColor = .art_color(withHEXValue: 0xF3F3F4)
    public var buttonBackgroundColor: UIColor {
        get {
            pri_buttonBackgroundColor
        }
        set {
            pri_buttonBackgroundColor = newValue
        }
    }
    
    /// 减少按钮图片.
    ///
    /// - Note: 默认nil.
    private var pri_decreaseImageName: String?
    public var decreaseImageName: String? {
        get {
            pri_decreaseImageName
        }
        set {
            pri_decreaseImageName = newValue
        }
    }
    
    /// 增加按钮图片.
    ///
    /// - Note: 默认nil.
    private var pri_increaseImageName: String?
    public var increaseImageName: String? {
        get {
            pri_increaseImageName
        }
        set {
            pri_increaseImageName = newValue
        }
    }
    
    /// 按钮imageSize.
    ///
    /// - Note: 默认CGSize = CGSize(width: 18.0, height: 18.0).
    private var pri_imageSize: CGSize = CGSize(width: 18.0, height: 18.0)
    public var imageSize: CGSize {
        get {
            pri_imageSize
        }
        set {
            pri_imageSize = newValue
        }
    }
    
    /// 按钮宽度
    ///
    /// - Note: 默认26.0.
    private var pri_buttonWidth: CGFloat = 26.0
    public var buttonWidth: CGFloat {
        get {
            pri_buttonWidth
        }
        set {
            pri_buttonWidth = max(0.0, newValue)
        }
    }
    
    /// 数量输入框背景颜色.
    ///
    /// - Note: 默认0xFFFFFF.
    private var pri_textFieldBackgroundColor: UIColor = .art_color(withHEXValue: 0xFFFFFF)
    public var textFieldBackgroundColor: UIColor {
        get {
            pri_textFieldBackgroundColor
        }
        set {
            pri_textFieldBackgroundColor = newValue
        }
    }
    
    /// 数量输入框字体.
    ///
    /// - Note: 默认.art_medium(14.0) ?? .systemFont(ofSize: 14.0).
    private var pri_textFieldFont: UIFont = .art_medium(14.0) ?? .systemFont(ofSize: 14.0)
    public var textFieldFont: UIFont {
        get {
            pri_textFieldFont
        }
        set {
            pri_textFieldFont = newValue
        }
    }
    
    /// 数量输入框字体颜色.
    ///
    /// - Note: 默认0x161822.
    private var pri_textFieldTextColor: UIColor = .art_color(withHEXValue: 0x161822)
    public var textFieldTextColor: UIColor {
        get {
            pri_textFieldTextColor
        }
        set {
            pri_textFieldTextColor = newValue
        }
    }
    
    /// 是否隐藏分割线
    ///
    /// - Note: 默认false.
    private var pri_hideSeparator: Bool = false
    public var hideSeparator: Bool {
        get {
            pri_hideSeparator
        }
        set {
            pri_hideSeparator = newValue
        }
    }
    // 根据需要添加更多的属性表.
}
