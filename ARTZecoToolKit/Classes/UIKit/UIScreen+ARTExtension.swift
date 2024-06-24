//
//  UIScreen+ARTExtension.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/5/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

extension UIScreen {
    
    /// 返回当前屏幕的宽度.
    ///
    /// - Returns: 屏幕宽度，单位为点.
    public static var art_currentScreenWidth: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    /// 返回当前屏幕的高度.
    ///
    /// - Returns: 屏幕高度，单位为点.
    public static var art_currentScreenHeight: CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    /// 返回一个布尔值，指示当前设备是否具有刘海屏（iPhone X 风格）.
    ///
    /// - Returns: 如果设备具有刘海屏，则为 `true`，否则为 `false`.
    public static var art_currentScreenIsIphoneX: Bool {
        let screenWidth = ceil(art_currentScreenWidth)
        let screenHeight = ceil(art_currentScreenHeight)
        
        if (screenWidth == 375 && screenHeight == 812) || (screenWidth == 414 && screenHeight == 896) {
            return true
        }
        
        if #available(iOS 11.0, *), 
            let appDelegate = UIApplication.shared.delegate,
            let window = appDelegate.window!,
            window.safeAreaInsets.bottom > 0 && UIDevice.current.userInterfaceIdiom == .phone {
            return true
        }
        return false
    }
}

