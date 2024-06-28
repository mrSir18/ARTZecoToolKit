//
//  ARTSlidePopupStyleConfiguration.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/5/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

/// 自定义UI样式配置
@objcMembers
public class ARTSlidePopupStyleConfiguration: NSObject {
    
    private static var single = ARTSlidePopupStyleConfiguration()
    
    public class func `default`() -> ARTSlidePopupStyleConfiguration {
        return ARTSlidePopupStyleConfiguration.single
    }
    
    public class func resetConfiguration() {
        ARTSlidePopupStyleConfiguration.single = ARTSlidePopupStyleConfiguration()
    }
    
    /// 容器高度.
    ///
    /// - Note: 默认600.0 + art_safeAreaBottom底部安全区域.
    private var pri_containerHeight: CGFloat = 600.0
    public var containerHeight: CGFloat {
        get {
            pri_containerHeight
        }
        set {
            pri_containerHeight = max(0.0, round(newValue))
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
    /// - Note: 默认10.0.
    private var pri_cornerRadius: CGFloat = 10.0
    public var cornerRadius: CGFloat {
        get {
            pri_cornerRadius
        }
        set {
            pri_cornerRadius = max(0.0, newValue)
        }
    }
    
    /// 头部视图高度.
    ///
    /// - Note: 默认50.0.
    private var pri_headerHeight: CGFloat = 50.0
    public var headerHeight: CGFloat {
        get {
            pri_headerHeight
        }
        set {
            pri_headerHeight = max(0.0, newValue)
        }
    }
    // 根据需要添加更多的属性表.
}
