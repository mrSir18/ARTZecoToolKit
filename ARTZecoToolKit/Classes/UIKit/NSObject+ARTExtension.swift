//
//  NSObject+ARTExtension.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/7/5.
//

extension NSObject {
    
    /// 获取对象的视图控制器对象.
    ///
    /// - Returns: 视图控制器对象.
    /// - Note: 该方法可能会返回 nil 值.
    public func getViewController() -> UIViewController? {
        var responder: UIResponder? = self as? UIResponder
        while responder != nil {
            if let viewController = responder as? UIViewController {
                return viewController
            }
            responder = responder?.next
        }
        return nil
    }
}
