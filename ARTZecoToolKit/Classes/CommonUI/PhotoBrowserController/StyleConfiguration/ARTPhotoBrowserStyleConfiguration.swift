//
//  ARTPhotoBrowserStyleConfiguration.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/7/15.
//

/// 自定义UI样式配置
@objcMembers
public class ARTPhotoBrowserStyleConfiguration: NSObject {
    
    private static var single = ARTPhotoBrowserStyleConfiguration()
    
    public class func `default`() -> ARTPhotoBrowserStyleConfiguration {
        return ARTPhotoBrowserStyleConfiguration.single
    }
    
    public class func resetConfiguration() {
        ARTPhotoBrowserStyleConfiguration.single = ARTPhotoBrowserStyleConfiguration()
    }
    
    /// 模态展示样式
    ///
    /// 默认值为 `.custom`.
    private var pri_modalPresentationStyle: UIModalPresentationStyle = .custom
    public var modalPresentationStyle: UIModalPresentationStyle {
        get {
            pri_modalPresentationStyle
        }
        set {
            pri_modalPresentationStyle = newValue
        }
    }
    
    /// 模态过渡样式
    ///
    /// 默认值为 `.crossDissolve`.
    private var pri_modalTransitionStyle: UIModalTransitionStyle = .crossDissolve
    public var modalTransitionStyle: UIModalTransitionStyle {
        get {
            pri_modalTransitionStyle
        }
        set {
            pri_modalTransitionStyle = newValue
        }
    }
    
    /// 控制器淡出动画持续时间.
    ///
    /// 默认值为 0.15.
    private var pri_controllerFadeOutAnimatorDuration: CGFloat = 0.15
    public var controllerFadeOutAnimatorDuration: CGFloat {
        get {
            pri_controllerFadeOutAnimatorDuration
        }
        set {
            pri_controllerFadeOutAnimatorDuration = max(0.0, newValue)
        }
    }
    
    /// 顶栏用户交互方式是否开启
    ///
    /// 默认值为 true.
    /// - Note: 开启后可点击顶栏区域不可进行图片放大交互等操作.
    private var pri_topBarUserInteractionEnabled: Bool = true
    public var topBarUserInteractionEnabled: Bool {
        get {
            pri_topBarUserInteractionEnabled
        }
        set {
            pri_topBarUserInteractionEnabled = newValue
        }
    }
    
    /// 底栏用户交互方式是否开启
    ///
    /// 默认值为 false.
    /// - Note: 开启后可点击底栏区域不可进行图片放大交互等操作.
    private var pri_bottomBarUserInteractionEnabled: Bool = false
    public var bottomBarUserInteractionEnabled: Bool {
        get {
            pri_bottomBarUserInteractionEnabled
        }
        set {
            pri_bottomBarUserInteractionEnabled = newValue
        }
    }
    
    /// 顶底栏淡出动画持续时间.
    ///
    /// 默认值为 3.0.
    private var pri_topBottomFadeOutAnimatorDuration: CGFloat = 3.0
    public var topBottomFadeOutAnimatorDuration: CGFloat {
        get {
            pri_topBottomFadeOutAnimatorDuration
        }
        set {
            pri_topBottomFadeOutAnimatorDuration = max(0.0, newValue)
        }
    }
    
    /// 控制器背景颜色.
    ///
    /// - Note: 默认.black.
    private var pri_controllerBackgroundColor: UIColor = .black
    public var controllerBackgroundColor: UIColor {
        get {
            pri_controllerBackgroundColor
        }
        set {
            pri_controllerBackgroundColor = newValue
        }
    }
    
    /// 是否开启背景图模糊效果.
    ///
    /// - Note: 默认true.
    private var pri_enableBackgroundBlurEffect: Bool = true
    public var enableBackgroundBlurEffect: Bool {
        get {
            pri_enableBackgroundBlurEffect
        }
        set {
            pri_enableBackgroundBlurEffect = newValue
        }
    }
    
    /// 是否开启单击退出图片浏览手势.
    ///
    /// - Note: 默认true.
    private var pri_enableSingleTapDismissGesture: Bool = true
    public var enableSingleTapDismissGesture: Bool {
        get {
            pri_enableSingleTapDismissGesture
        }
        set {
            pri_enableSingleTapDismissGesture = newValue
        }
    }
    
    /// 是否开启双击图片放大手势.
    ///
    /// - Note: 默认true.
    private var pri_enableDoubleTapZoomGesture: Bool = true
    public var enableDoubleTapZoomGesture: Bool {
        get {
            pri_enableDoubleTapZoomGesture
        }
        set {
            pri_enableDoubleTapZoomGesture = newValue
        }
    }
    
    /// 双击最大缩放比例.
    ///
    /// - Note: 默认1.8.
    private var pri_maximumZoomScale: CGFloat = 1.8
    public var maximumZoomScale: CGFloat {
        get {
            pri_maximumZoomScale
        }
        set {
            pri_maximumZoomScale = max(1.0, newValue)
        }
    }
    
    /// 双击最小缩放比例.
    ///
    /// - Note: 默认1.0.
    private var pri_minimumZoomScale: CGFloat = 1.0
    public var minimumZoomScale: CGFloat {
        get {
            pri_minimumZoomScale
        }
        set {
            pri_minimumZoomScale = max(1.0, newValue)
        }
    }
    
    /// 关闭按钮资源图片名.
    ///
    /// - Note: 默认nil.
    /// - Note: 未设置时则显示默认【关闭】文字按钮.
    private var pri_customBackButtonImageName: String?
    public var customBackButtonImageName: String? {
        get {
            pri_customBackButtonImageName
        }
        set {
            pri_customBackButtonImageName = newValue
        }
    }
    // 未满足需求时，可继承ARTPhotoBrowserViewController重写顶底栏，或通过代理自定义顶底栏View.
}
