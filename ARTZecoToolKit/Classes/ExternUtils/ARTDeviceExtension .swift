//
//  ARTDeviceExtension .swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2023/10/21.
//

import Foundation
import UIKit

/*!
 * @brief 顶部安全区高度
 */
public func art_safeAreaTop() -> CGFloat {
    if #available(iOS 13.0, *) {
        let scene = UIApplication.shared.connectedScenes.first
        guard let windowScene = scene as? UIWindowScene else { return 0 }
        guard let window = windowScene.windows.first else { return 0 }
        return window.safeAreaInsets.top
    } else if #available(iOS 11.0, *) {
        guard let window = UIApplication.shared.windows.first else { return 0 }
        return window.safeAreaInsets.top
    }
    return 0;
}

/*!
 * @brief 底部安全区高度
 */
public func art_safeAreaBottom() -> CGFloat {
    if #available(iOS 13.0, *) {
        let scene = UIApplication.shared.connectedScenes.first
        guard let windowScene = scene as? UIWindowScene else { return 0 }
        guard let window = windowScene.windows.first else { return 0 }
        return window.safeAreaInsets.bottom
    } else if #available(iOS 11.0, *) {
        guard let window = UIApplication.shared.windows.first else { return 0 }
        return window.safeAreaInsets.bottom
    }
    return 0;
}

/*!
 * @brief 顶部状态栏高度（包括安全区）
 */
public func art_statusBarHeight() -> CGFloat {
    var statusBarHeight: CGFloat = 0
    if #available(iOS 13.0, *) {
        let scene = UIApplication.shared.connectedScenes.first
        guard let windowScene = scene as? UIWindowScene else { return 0 }
        guard let statusBarManager = windowScene.statusBarManager else { return 0 }
        statusBarHeight = statusBarManager.statusBarFrame.height
    } else {
        statusBarHeight = UIApplication.shared.statusBarFrame.height
    }
    return statusBarHeight
}

/*!
 * @brief 导航栏高度
 */
public func art_navigationBarHeight() -> CGFloat {
    return 44.0
}

/*!
 * @brief 状态栏+导航栏的高度
 */
public func art_navigationFullHeight() -> CGFloat {
    return art_statusBarHeight() + art_navigationBarHeight()
}

/*!
 * @brief 底部导航栏高度
 */
public func art_tabBarHeight() -> CGFloat {
    return 49.0
}

/*!
 * @brief 底部导航栏高度（包括安全区）
 */
public func art_tabBarFullHeight() -> CGFloat {
    return art_tabBarHeight() + art_safeAreaBottom()
}
