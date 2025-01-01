//
//  ARTStarRatingStyleConfiguration.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/7/4.
//

/// 自定义UI样式配置
@objcMembers
public class ARTStarRatingStyleConfiguration: NSObject {
    
    /// 星星对齐方式.
    public enum ARTAlignment: Int {
        case left
        case center
        case right
    }
    
    private static var single = ARTStarRatingStyleConfiguration()
    
    public class func `default`() -> ARTStarRatingStyleConfiguration {
        return ARTStarRatingStyleConfiguration.single
    }
    
    public class func resetConfiguration() {
        ARTStarRatingStyleConfiguration.single = ARTStarRatingStyleConfiguration()
    }
    
    /// 视图背景色.
    ///
    /// - Note: 默认.clear.
    private var pri_backgroundColor: UIColor = .clear
    public var backgroundColor: UIColor {
        get {
            pri_backgroundColor
        }
        set {
            pri_backgroundColor = newValue
        }
    }
    
    /// 星星对齐方式.
    ///
    /// - Note: 默认.left.
    private var pri_starAlignment: ARTAlignment = .left
    public var starAlignment: ARTAlignment {
        get {
            pri_starAlignment
        }
        set {
            pri_starAlignment = newValue
        }
    }
    
    /// 星星的Size.
    ///
    /// - Note: 默认16x16.
    private var pri_starSize: CGSize = ARTAdaptedSize(width: 16.0, height: 16.0)
    public var starSize: CGSize {
        get {
            pri_starSize
        }
        set {
            pri_starSize = newValue
        }
    }
    
    /// 星星的数量 .
    ///
    /// - Note: 默认5.
    private var pri_starCount: Int = 5
    public var starCount: Int {
        get {
            pri_starCount
        }
        set {
            pri_starCount = max(0, newValue)
        }
    }
    
    /// 星星之间的间距.
    ///
    /// - Note: 默认12.
    private var pri_starSpacing: CGFloat = ARTAdaptedValue(12.0)
    public var starSpacing: CGFloat {
        get {
            pri_starSpacing
        }
        set {
            pri_starSpacing = max(0.0, newValue)
        }
    }
    
    /// 星星默认图片.
    ///
    /// - Note: 默认icon_order_review_star.
    private var pri_starNormalImageName: String = "icon_order_review_star"
    public var starNormalImageName: String {
        get {
            pri_starNormalImageName
        }
        set {
            pri_starNormalImageName = newValue
        }
    }
    
    /// 星星选择图片.
    ///
    /// - Note: 默认icon_order_review_star_fill.
    private var pri_starSelectedImageName: String = "icon_order_review_star_fill"
    public var starSelectedImageName: String {
        get {
            pri_starSelectedImageName
        }
        set {
            pri_starSelectedImageName = newValue
        }
    }
    // 根据需要添加更多的属性表.
}
