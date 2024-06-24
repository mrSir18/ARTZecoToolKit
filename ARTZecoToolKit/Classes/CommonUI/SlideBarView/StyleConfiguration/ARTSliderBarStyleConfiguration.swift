//
//  ARTSliderBarStyleConfiguration.swift
//  Alamofire
//
//  Created by mrSir18 on 2024/5/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

// 标题布局类型
public enum AverageType {
    /// 等分宽度布局（默认： (UIScreen.main.bounds.size.width - titleEdgeInsets.left - titleEdgeInsets.right - titleSpacing) /  itleAverageTypeCount）
    ///
    /// - Note: 仅在titleAverageTypeCount > 1时生效, 配合使用
    case average
    /// 固定宽度布局
    ///
    /// 指定标题内容宽度
    case fixed
    /// 内容宽度布局
    ///
    /// 根据内容宽度自适应
    case content
}

/// 自定义UI样式配置
@objcMembers
public class ARTSliderBarStyleConfiguration: NSObject {
    
    private static var single = ARTSliderBarStyleConfiguration()
    
    public class func `default`() -> ARTSliderBarStyleConfiguration {
        return ARTSliderBarStyleConfiguration.single
    }
    
    public class func resetConfiguration() {
        ARTSliderBarStyleConfiguration.single = ARTSliderBarStyleConfiguration()
    }
    
    /// 菜单栏 - 数组内容.
    ///
    /// - Note: 默认[].
    private var pri_titles: [String] = []
    public var titles: [String] {
        get {
            pri_titles
        }
        set {
            pri_titles = newValue
        }
    }
    
    /// 菜单栏 - 背景色.
    ///
    /// - Note: 默认clear.
    private var pri_backgroundColor: UIColor = .clear
    public var backgroundColor: UIColor {
        get {
            pri_backgroundColor
        }
        set {
            pri_backgroundColor = newValue
        }
    }
    
    /// 菜单栏 - 标题字体 Normal.
    ///
    /// - Note: 默认.art_regular(14.0) ?? .systemFont(ofSize: 14.0).
    private var pri_titleFont: UIFont = .art_regular(14.0) ?? .systemFont(ofSize: 14.0)
    public var titleFont: UIFont {
        get {
            pri_titleFont
        }
        set {
            pri_titleFont = newValue
        }
    }
    
    /// 菜单栏 - 标题字体 Selected.
    ///
    /// - Note: 默认.art_medium(14.0) ?? .boldSystemFont(ofSize: 14.0).
    private var pri_titleSelectedFont: UIFont = .art_medium(14.0) ?? .boldSystemFont(ofSize: 14.0)
    public var titleSelectedFont: UIFont {
        get {
            pri_titleSelectedFont
        }
        set {
            pri_titleSelectedFont = newValue
        }
    }
    
    /// 菜单栏 - 标题颜色 Normal.
    ///
    /// - Note: 默认0x282828.
    private var pri_titleColor: UIColor = .art_color(withHEXValue: 0x282828)
    public var titleColor: UIColor {
        get {
            pri_titleColor
        }
        set {
            pri_titleColor = newValue
        }
    }
    
    /// 菜单栏 - 标题颜色 Selected.
    ///
    /// - Note: 默认0x282828.
    private var pri_titleSelectedColor: UIColor = .art_color(withHEXValue: 0x282828)
    public var titleSelectedColor: UIColor {
        get {
            pri_titleSelectedColor
        }
        set {
            pri_titleSelectedColor = newValue
        }
    }
    
    /// 菜单栏 - 标题布局类型.
    ///
    /// - Note: 默认average.
    /// - Note: 与titleAverageTypeCount 配合使用
    /// - Note: 设置.average时titleFixedWidth失效
    private var pri_titleAverageType: AverageType = .average
    public var titleAverageType: AverageType {
        get {
            pri_titleAverageType
        }
        set {
            pri_titleAverageType = newValue
        }
    }
    
    /// 菜单栏 - 标题布局等分数.
    ///
    /// - Note: 默认UIScreen.main.bounds.size.width / 5.
    private var pri_titleAverageTypeCount: Int = 5
    public var titleAverageTypeCount: Int {
        get {
            pri_titleAverageTypeCount
        }
        set {
            pri_titleAverageTypeCount = max(1, newValue)
        }
    }
    
    /// 菜单栏 - 标题固定宽度.
    ///
    /// - Note: 默认100.0.
    private var pri_titleFixedWidth: CGFloat = 100.0
    public var titleFixedWidth: CGFloat {
        get {
            pri_titleFixedWidth
        }
        set {
            pri_titleFixedWidth = max(0.0, newValue)
        }
    }
    
    /// 菜单栏 - 标题左右内边距.
    ///
    /// - Note: 默认.zero.
    private var pri_titleEdgeInsets: UIEdgeInsets = .zero
    public var titleEdgeInsets: UIEdgeInsets {
        get {
            pri_titleEdgeInsets
        }
        set {
            pri_titleEdgeInsets = newValue
        }
    }
    
    /// 菜单栏 - 标题间距.
    ///
    /// - Note: 默认0.0.
    private var pri_titleSpacing: CGFloat = 0.0
    public var titleSpacing: CGFloat {
        get {
            pri_titleSpacing
        }
        set {
            pri_titleSpacing = max(0.0, newValue)
        }
    }
    
    /// 滑动块 - 尺寸.
    ///
    /// - Note: 默认CGSize(width: 20.0, height: 2.0).
    private var pri_lineSize: CGSize = CGSize(width: 20.0, height: 2.0)
    public var lineSize: CGSize {
        get {
            pri_lineSize
        }
        set {
            pri_lineSize = newValue
        }
    }
    
    /// 滑动块 - 距离标题间距.
    ///
    /// - Note: 默认6.0.
    private var pri_lineBottomSpacing: CGFloat = 6.0
    public var lineBottomSpacing: CGFloat {
        get {
            pri_lineBottomSpacing
        }
        set {
            pri_lineBottomSpacing = max(0.0, newValue)
        }
    }
    
    /// 滑动块 - 圆角.
    ///
    /// - Note: 默认0.0.
    private var pri_lineCornerRadius: CGFloat = 0.0
    public var lineCornerRadius: CGFloat {
        get {
            pri_lineCornerRadius
        }
        set {
            pri_lineCornerRadius = max(0.0, newValue)
        }
    }

    /// 滑动块 - 是否圆角
    ///
    /// - Note: 默认true.
    private var pri_lineClipsToBounds: Bool = true
    public var lineClipsToBounds: Bool {
        get {
            pri_lineClipsToBounds
        }
        set {
            pri_lineClipsToBounds = newValue
        }
    }
    
    /// 滑动块 - 颜色
    ///
    /// - Note: 默认0xff5c00.
    private var pri_lineColor: UIColor = .art_color(withHEXValue: 0xff5c00)
    public var lineColor: UIColor {
        get {
            pri_lineColor
        }
        set {
            pri_lineColor = newValue
        }
    }
    
    /// 滑动块 - 渐变色.
    ///
    /// - Note: 默认nil.
    /// - Note: 优先级高于lineColor.
    /// - Note: 与lineClipsToBounds配合使用.
    private var pri_lineGradientLayer: CAGradientLayer?
    public var lineGradientLayer: CAGradientLayer? {
        get {
            pri_lineGradientLayer
        }
        set {
            pri_lineGradientLayer = newValue
        }
    }
    
    /// 滑动块 - 是否隐藏.
    ///
    /// - Note: 默认false.
    private var pri_lineHidden: Bool = false
    public var lineHidden: Bool {
        get {
            pri_lineHidden
        }
        set {
            pri_lineHidden = newValue
        }
    }
}
