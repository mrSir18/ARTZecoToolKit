//
//  ARTCityStyleConfiguration .swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/5/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

/// 自定义UI样式配置
@objcMembers
public class ARTCityStyleConfiguration: NSObject {
    
    private static var single = ARTCityStyleConfiguration()
    
    public class func `default`() -> ARTCityStyleConfiguration {
        return ARTCityStyleConfiguration.single
    }
    
    public class func resetConfiguration() {
        ARTCityStyleConfiguration.single = ARTCityStyleConfiguration()
    }
    
    /// 城市联级菜单 - 可选级别.
    ///
    /// - Note: 默认4级.
    /// - Note: 最小1级.
    /// - Note: 最大4级.
    /// - Note: 1级为省级, 2级为市级, 3级为区级, 4级为街道级.
    private var pri_maxLevels: Int = 4
    public var maxLevels: Int {
        get {
            pri_maxLevels
        }
        set {
            pri_maxLevels = max(1, newValue)
        }
    }
    
    /// 容器高度.
    ///
    /// - Note: 默认681.0.
    private var pri_containerHeight: CGFloat = 681.0
    public var containerHeight: CGFloat {
        get {
            pri_containerHeight
        }
        set {
            pri_containerHeight = max(0.0, newValue)
        }
    }
    
    /// 主题色.
    ///
    /// - Note: 默认0xFF5C00.
    private var pri_themeColor: UIColor = .art_color(withHEXValue: 0xFF5C00)
    public var themeColor: UIColor {
        get {
            pri_themeColor
        }
        set {
            pri_themeColor = newValue
        }
    }
    
    /// 容器圆角.
    ///
    /// - Note: 默认16.0.
    private var pri_cornerRadius: CGFloat = 16.0
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
    /// - Note: 默认[.layerMinXMinYCorner, .layerMaxXMinYCorner].
    /// - Parameters:
    ///   - layerMinXMinYCorner: 左上角.
    ///   - layerMaxXMinYCorner: 右上角.
    ///   - layerMinXMaxYCorner: 左下角.
    ///   - layerMaxXMaxYCorner: 右下角.
    private var pri_maskedCorners: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    public var maskedCorners: CACornerMask {
        get {
            pri_maskedCorners
        }
        set {
            pri_maskedCorners = newValue
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
    
    /// 是否设置渐变条.
    ///
    /// - Note: 默认false.
    private var pri_isGradientLine: Bool = false
    public var isGradientLine: Bool {
        get {
            pri_isGradientLine
        }
        set {
            pri_isGradientLine = newValue
        }
    }
    
    /// 渐变条CAGradientLayer.
    ///
    /// - Note: 默认nil.
    /// 与isGradientLine配合使用.
    private var pri_gradientLayer: CAGradientLayer?
    public var gradientLayer: CAGradientLayer? {
        get {
            pri_gradientLayer
        }
        set {
            pri_gradientLayer = newValue
        }
    }
    
    /// 勾选图片对象.
    ///
    /// - Note: 默认内置勾选图片.
    private var pri_tickImage: UIImage?
    public var tickImage: UIImage? {
        get {
            pri_tickImage
        }
        set {
            pri_tickImage = newValue
        }
    }
    // 根据需要添加更多的属性表.
}
