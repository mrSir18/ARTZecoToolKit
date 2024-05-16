//
//  ARTAlertController.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/5/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

/// 定义 ARTAlertController 的模式枚举.
public enum ARTAlertControllerMode: Int {
    /// 第一种模式.
    case first = 1
    /// 第二种模式.
    case second
    /// 第三种模式.
    case third
    /// 第四种模式.
    case fourth
    /// 第五种模式.
    case fifth
    // 根据需要添加更多的模式.
}

/// 自定义的弹窗控制器工具类.
public class ARTAlertController {

    /// 显示弹窗控制器，仅带有按钮标题，并在按钮点击时执行处理程序.
    ///
    /// - Parameters:
    ///   - style: 弹窗控制器的样式.
    ///   - buttonTitles: 按钮标题数组.
    ///   - buttonStyles: 按钮样式数组，与按钮标题数组对应.
    ///   - viewController: 要在其上显示弹窗控制器的视图控制器.
    ///   - handler: 按钮点击时的处理程序，传递弹窗控制器的模式参数.
    public class func showAlertController(style: UIAlertController.Style,
                                          buttonTitles: [String],
                                          buttonStyles: [UIAlertAction.Style],
                                          in viewController: UIViewController,
                                          handler: ((ARTAlertControllerMode) -> Void)?) {
        
        showAlertController(title: nil,
                            message: nil,
                            preferredStyle: style,
                            buttonTitles: buttonTitles,
                            buttonStyles: buttonStyles,
                            in: viewController,
                            handler: handler)
    }
    
    /// 显示弹窗控制器，带有标题、消息、按钮标题，并在按钮点击时执行处理程序.
    ///
    /// - Parameters:
    ///   - title: 弹窗控制器的标题.
    ///   - message: 弹窗控制器的消息.
    ///   - style: 弹窗控制器的样式.
    ///   - buttonTitles: 按钮标题数组.
    ///   - buttonStyles: 按钮样式数组，与按钮标题数组对应.
    ///   - viewController: 要在其上显示弹窗控制器的视图控制器.
    ///   - handler: 按钮点击时的处理程序，传递弹窗控制器的模式参数.
    public class func showAlertController(title: String?,
                                          message: String?,
                                          preferredStyle style: UIAlertController.Style,
                                          buttonTitles: [String],
                                          buttonStyles: [UIAlertAction.Style],
                                          in viewController: UIViewController,
                                          handler: ((ARTAlertControllerMode) -> Void)?) {
        
        var actions = [UIAlertAction]()
        for (index, buttonTitle) in buttonTitles.enumerated() {
            let action = UIAlertAction(title: buttonTitle, style: buttonStyles[index], handler: { _ in
                if let handler = handler {
                    handler(ARTAlertControllerMode(rawValue: index + 1)!)
                }
            })
            actions.append(action)
        }
        
        showAlertController(title: title,
                            message: message,
                            preferredStyle: style,
                            actions: actions,
                            in: viewController)
    }

    /// 显示弹窗控制器，带有标题、消息和自定义动作.
    ///
    /// - Parameters:
    ///   - title: 弹窗控制器的标题.
    ///   - message: 弹窗控制器的消息.
    ///   - style: 弹窗控制器的样式.
    ///   - actions: 自定义的 UIAlertAction 对象数组.
    ///   - viewController: 要在其上显示弹窗控制器的视图控制器.
    public class func showAlertController(title: String?,
                                          message: String?,
                                          preferredStyle style: UIAlertController.Style,
                                          actions: [UIAlertAction],
                                          in viewController: UIViewController) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        for action in actions {
            alertController.addAction(action)
        }
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}

