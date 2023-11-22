//
//  UIScreen+ARTExtension.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2023/11/22.
//

import UIKit

extension UIScreen {
    /**
     * @desc  当前屏幕宽度
     */
    public static var art_currentScreenWidth: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    /**
     * @desc 当前屏幕高度
     */
    public static var art_currentScreenHeight: CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    /**
     * @desc 判断当前屏幕顶部是否有刘海
     */
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

