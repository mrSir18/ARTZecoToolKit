//
//  UIApplication+ARTExtension.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/7/5.
//

extension UIApplication {
    
    /// 返回当前应用程序的顶级视图控制器对象.
    ///
    /// - Parameter base: 要查找的视图控制器对象.
    /// - Returns: 顶级视图控制器对象.
    /// - Note: 该方法可能会返回 nil 值.
    public class func art_topViewController(base: UIViewController? = UIApplication.shared.windows.first(where: \.isKeyWindow)?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return art_topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return art_topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return art_topViewController(base: presented)
        }
        return base
    }
}
