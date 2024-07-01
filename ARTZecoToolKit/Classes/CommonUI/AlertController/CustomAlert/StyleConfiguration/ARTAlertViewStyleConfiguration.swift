//
//  ARTAlertViewStyleConfiguration.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/7/1.
//

/// 自定义UI样式配置
@objcMembers
public class ARTAlertViewStyleConfiguration: NSObject {
    
    private static var single = ARTAlertViewStyleConfiguration()
    
    public class func `default`() -> ARTAlertViewStyleConfiguration {
        return ARTAlertViewStyleConfiguration.single
    }
    
    public class func resetConfiguration() {
        ARTAlertViewStyleConfiguration.single = ARTAlertViewStyleConfiguration()
    }
    
    /// 容器高度.
    ///
    /// - Note: 默认246.0.
    private var pri_containerWidth: CGFloat = ARTAdaptedValue(246.0)
    public var containerWidth: CGFloat {
        get {
            pri_containerWidth
        }
        set {
            pri_containerWidth = max(0.0, newValue)
        }
    }
    
    /// 容器背景色
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
    /// - Note: 默认8.0.
    private var pri_cornerRadius: CGFloat = ARTAdaptedValue(8.0)
    public var cornerRadius: CGFloat {
        get {
            pri_cornerRadius
        }
        set {
            pri_cornerRadius = max(0.0, newValue)
        }
    }
    
    /// 标题距离顶部间距.
    ///
    /// - Note: 默认28.0.
    private var pri_titleTopSpacing: CGFloat = ARTAdaptedValue(28.0)
    public var titleTopSpacing: CGFloat {
        get {
            pri_titleTopSpacing
        }
        set {
            pri_titleTopSpacing = max(0.0, newValue)
        }
    }
    
    /// 内容标题字体.
    ///
    /// - Note: 默认.art_medium(ARTAdaptedValue(18.0)) ?? .systemFont(ofSize: ARTAdaptedValue(18.0)).
    private var pri_titleFont: UIFont = .art_medium(ARTAdaptedValue(18.0)) ?? .systemFont(ofSize: ARTAdaptedValue(18.0))
    public var titleFont: UIFont {
        get {
            pri_titleFont
        }
        set {
            pri_titleFont = newValue
        }
    }
    
    /// 内容标题字体颜色.
    ///
    /// - Note: 默认0x000000.
    private var pri_titleColor: UIColor = .art_color(withHEXValue: 0x000000)
    public var titleColor: UIColor {
        get {
            pri_titleColor
        }
        set {
            pri_titleColor = newValue
        }
    }
    
    /// 描述距离顶部间距.
    ///
    /// - Note: 默认0.0.
    private var pri_descTopSpacing: CGFloat = 0.0
    public var descTopSpacing: CGFloat {
        get {
            pri_descTopSpacing
        }
        set {
            pri_descTopSpacing = max(0.0, newValue)
        }
    }
    
    /// 内容描述字体.
    ///
    /// - Note: 默认.art_medium(ARTAdaptedValue(14.0)) ?? .systemFont(ofSize: ARTAdaptedValue(14.0)).
    private var pri_descFont: UIFont = .art_medium(ARTAdaptedValue(14.0)) ?? .systemFont(ofSize: ARTAdaptedValue(14.0))
    public var descFont: UIFont {
        get {
            pri_descFont
        }
        set {
            pri_descFont = newValue
        }
    }
    
    /// 内容描述字体颜色.
    ///
    /// - Note: 默认0x000000.
    private var pri_descColor: UIColor = .art_color(withHEXValue: 0x000000)
    public var descColor: UIColor {
        get {
            pri_descColor
        }
        set {
            pri_descColor = newValue
        }
    }
    
    /// 按钮左右间距.
    ///
    /// - Note: 默认12.0.
    private var pri_textHorizontalMargin: CGFloat = ARTAdaptedValue(12.0)
    public var textHorizontalMargin: CGFloat {
        get {
            pri_textHorizontalMargin
        }
        set {
            pri_textHorizontalMargin = max(0.0, newValue)
        }
    }
    
    /// 按钮顶部距离描述底部间距.
    ///
    /// - Note: 默认20.0.
    private var pri_buttonTopSpacingToDescription: CGFloat = ARTAdaptedValue(12.0)
    public var buttonTopSpacingToDescription: CGFloat {
        get {
            pri_buttonTopSpacingToDescription
        }
        set {
            pri_buttonTopSpacingToDescription = max(0.0, newValue)
        }
    }
    
    /// 按钮内容数组.
    ///
    /// - Note: 默认【取消 ，确定】.
    private var pri_buttonTitles: [String] = ["取消", "确定"]
    public var buttonTitles: [String] {
        get {
            pri_buttonTitles
        }
        set {
            pri_buttonTitles = newValue
        }
    }
    
    /// 按钮字体数组.
    ///
    /// - Note: 默认数组.art_regular(ARTAdaptedValue(14.0)) ，.art_regular(ARTAdaptedValue(14.0).
    private var pri_buttonTitleFonts: [UIFont] = [.art_regular(ARTAdaptedValue(14.0)) ?? .systemFont(ofSize: ARTAdaptedValue(14.0)),
                                                  .art_regular(ARTAdaptedValue(14.0)) ?? .systemFont(ofSize: ARTAdaptedValue(14.0))]
    public var buttonTitleFonts: [UIFont] {
        get {
            pri_buttonTitleFonts
        }
        set {
            pri_buttonTitleFonts = newValue
        }
    }
    
    /// 按钮字体颜色数组.
    ///
    /// - Note: 默认.art_color(withHEXValue: 0x000000)，.art_color(withHEXValue: 0xFE5C01)数组.
    private var pri_buttonTitleColors: [UIColor] = [.art_color(withHEXValue: 0x000000),
                                                   .art_color(withHEXValue: 0xFE5C01)]
    public var buttonTitleColors: [UIColor] {
        get {
            pri_buttonTitleColors
        }
        set {
            pri_buttonTitleColors = newValue
        }
    }
    
    /// 按钮背景颜色数组.
    ///
    /// - Note: 默认.art_color(withHEXValue: 0xFFFFFF)，.art_color(withHEXValue: 0xFFFFFF)数组.
    private var pri_buttonBackgroundColors: [UIColor] = [.art_color(withHEXValue: 0xFFFFFF),
                                                         .art_color(withHEXValue: 0xFFFFFF)]
    public var buttonBackgroundColors: [UIColor] {
        get {
            pri_buttonBackgroundColors
        }
        set {
            pri_buttonBackgroundColors = newValue
        }
    }
    
    /// 按钮边框颜色数组.
    ///
    /// - Note: 默认.art_color(withHEXValue: 0xF0F0F0)，.art_color(withHEXValue: 0xFE5C01)数组.
    private var pri_buttonBorderColors: [UIColor] = [.art_color(withHEXValue: 0xF0F0F0),
                                                     .art_color(withHEXValue: 0xFE5C01)]
    public var buttonBorderColors: [UIColor] {
        get {
            pri_buttonBorderColors
        }
        set {
            pri_buttonBorderColors = newValue
        }
    }
    
    /// 按钮边框宽度.
    ///
    /// - Note: 默认0.5.
    private var pri_buttonBorderWidth: CGFloat = 0.5
    public var buttonBorderWidth: CGFloat {
        get {
            pri_buttonBorderWidth
        }
        set {
            pri_buttonBorderWidth = max(0.0, newValue)
        }
    }
    
    /// 按钮圆角.
    ///
    /// - Note: 默认8.0.
    private var pri_buttonRadius: CGFloat = ARTAdaptedValue(8.0)
    public var buttonRadius: CGFloat {
        get {
            pri_buttonRadius
        }
        set {
            pri_buttonRadius = max(0.0, newValue)
        }
    }
    
    /// 按钮距离底部间距.
    ///
    /// - Note: 默认12.0.
    private var pri_buttonBottomSpacing: CGFloat = ARTAdaptedValue(12.0)
    public var buttonBottomSpacing: CGFloat {
        get {
            pri_buttonBottomSpacing
        }
        set {
            pri_buttonBottomSpacing = max(0.0, newValue)
        }
    }
    
    /// 按钮大小.
    ///
    /// - Note: 默认ARTAdaptedSize(width: 106.0, height: 32.0).
    private var pri_buttonSize: CGSize = ARTAdaptedSize(width: 106.0, height: 32.0)
    public var buttonSize: CGSize {
        get {
            pri_buttonSize
        }
        set {
            pri_buttonSize = CGSize(width: max(0.0, newValue.width), height: max(0.0, newValue.height))
        }
    }
    
    /// 按钮左右间距.
    ///
    /// - Note: 默认12.0.
    private var pri_buttonHorizontalMargin: CGFloat = ARTAdaptedValue(12.0)
    public var buttonHorizontalMargin: CGFloat {
        get {
            pri_buttonHorizontalMargin
        }
        set {
            pri_buttonHorizontalMargin = max(0.0, newValue)
        }
    }
    // 根据需要添加更多的属性表.
}
