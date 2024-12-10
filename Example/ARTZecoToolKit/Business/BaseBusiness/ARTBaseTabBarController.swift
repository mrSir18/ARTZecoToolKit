//
//  ARTBaseTabBarController.swift
//  ARTZecoToolKit_Example
//
//  Created by mrSir18 on 2024/5/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

class ARTBaseTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.isHidden = true
        
        let viewController = ARTViewController_Debug()
        self.viewControllers = [viewController]
        self.selectedIndex = 0
    }
}

extension ARTBaseTabBarController {
    
    /// 获取当前选中视图控制器的指定属性
    ///
    /// - Parameter keyPath: 属性路径
    /// - Returns: 属性值
    /// - Note: 如果当前选中的视图控制器是导航控制器，则返回其顶部视图控制器的对应属性
    private func getSelectedViewControllerProperty<T>(_ keyPath: KeyPath<UIViewController, T>) -> T? {
        guard let navigationController = selectedViewController as? UINavigationController else {
            return selectedViewController?[keyPath: keyPath] ?? nil
        }
        return navigationController.topViewController?[keyPath: keyPath] ?? nil
    }

    /// 是否支持自动转屏
    override var shouldAutorotate: Bool {
        return getSelectedViewControllerProperty(\.shouldAutorotate) ?? false
    }

    /// 支持哪些屏幕方向
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return getSelectedViewControllerProperty(\.supportedInterfaceOrientations) ?? .portrait
    }

    /// 默认的屏幕方向
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return getSelectedViewControllerProperty(\.preferredInterfaceOrientationForPresentation) ?? .portrait
    }

    /// 状态栏样式
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return getSelectedViewControllerProperty(\.preferredStatusBarStyle) ?? .default
    }

    /// 是否隐藏状态栏
    override var prefersStatusBarHidden: Bool {
        return getSelectedViewControllerProperty(\.prefersStatusBarHidden) ?? false
    }
}
