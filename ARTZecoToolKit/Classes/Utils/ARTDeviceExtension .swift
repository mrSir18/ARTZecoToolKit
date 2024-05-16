//
//  ARTDeviceExtension .swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/5/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

/// 获取安全区域顶部的高度
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

/// 获取安全区域底部的高度
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

/// 获取状态栏的高度（包括安全区）
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

/// 获取导航栏的高度
public func art_navigationBarHeight() -> CGFloat {
    return 44.0
}

/// 获取导航栏全高度（包括状态栏）
public func art_navigationFullHeight() -> CGFloat {
    return art_statusBarHeight() + art_navigationBarHeight()
}

/// 获取底部导航栏高度
public func art_tabBarHeight() -> CGFloat {
    return 49.0
}

/// 获取底部导航栏高度（包括安全区）
public func art_tabBarFullHeight() -> CGFloat {
    return art_tabBarHeight() + art_safeAreaBottom()
}

/// 获取Window窗口
public var keyWindow: UIWindow {
    return getKeyWindow() ?? UIWindow.init(frame: UIScreen.main.bounds)
}

private func getKeyWindow() -> UIWindow? {
    if #available(iOS 13.0, *) {
        if let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            return windowScene.windows.first(where: { $0.isKeyWindow })
        }
    }
    return UIApplication.shared.delegate?.window ?? nil
}

/// 获取ResourcePath
///
/// - Parameters:
///   - object: 对象.
///   - file: 文件名.
public func art_resourcePath(file: String, object: AnyObject) -> String {
    let currentBundle = Bundle(for: type(of: object))
    guard let bundleName = currentBundle.infoDictionary?["CFBundleName"] as? String else {
        print("无法获取当前 Bundle 名称")
        return ""
    }
    
    guard let path = currentBundle.path(forResource: file, ofType: nil, inDirectory: "\(bundleName).bundle") else {
        print("无法找到资源文件: \(file)")
        return ""
    }
    return path
}

/// 自定义的打印函数，仅在调试模式下生效..
///
/// - Parameters:
///   - message: 需要打印的信息.
///   - file: 文件名.
///   - funcName: 函数名.
///   - lineNum: 行数.
public func print<T>(_ items: T..., separator: String = " ", terminator: String = "\n", file: NSString = #file, funcName: String = #function, lineNum: Int = #line) {
    #if DEBUG
    let fileName: String = file.lastPathComponent
    let output = items.map { "\($0)" }.joined(separator: separator)
    let log = "\(fileName)-\(funcName)-(\(lineNum))-\(output)"
    Swift.print(log, terminator: terminator)
    #endif
}


