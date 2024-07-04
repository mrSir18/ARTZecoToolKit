//
//  UIFont+ARTExtension.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/5/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

extension UIFont {
    
    public static func art_regular(_ fontSize: CGFloat) -> UIFont? {
        return art_fontPingFangSCRegular(fontSize)
    }
    
    public static func art_medium(_ fontSize: CGFloat) -> UIFont? {
        return art_fontPingFangSCMedium(fontSize)
    }
    
    public static func art_semibold(_ fontSize: CGFloat) -> UIFont? {
        return art_fontPingFangSCSemibold(fontSize)
    }
    
    public static func art_bold(_ fontSize: CGFloat) -> UIFont? {
        return art_fontPingFangSCBold(fontSize)
    }
    
    public static func art_heavy(_ fontSize: CGFloat) -> UIFont? {
        return art_fontPingFangSCHeavy(fontSize)
    }
    
    public static func art_light(_ fontSize: CGFloat) -> UIFont? {
        return art_fontPingFangSCLight(fontSize)
    }
    
    public static func art_ultralight(_ fontSize: CGFloat) -> UIFont? {
        return art_fontPingFangSCUltralight(fontSize)
    }
    
    public static func art_thin(_ fontSize: CGFloat) -> UIFont? {
        return art_fontPingFangSCThin(fontSize)
    }
    
    public static func art_shsHeavy(_ fontSize: CGFloat) -> UIFont? {
        return art_fontSourceHanSansHeavy(fontSize)
    }
    
    /// 返回一个使用苹方-常规字体的字体对象.
    ///
    /// - Parameter fontSize: 字体的大小.
    /// - Returns: 苹方-常规字体的字体对象，如果创建失败则返回系统默认字体.
    private static func art_fontPingFangSCRegular(_ fontSize: CGFloat) -> UIFont? {
        guard let font = UIFont(name: "PingFangSC-Regular", size: fontSize) else {
            return .systemFont(ofSize: fontSize)
        }
        return font
    }
    
    /// 返回一个使用苹方-中黑字体的字体对象.
    ///
    /// - Parameter fontSize: 字体的大小.
    /// - Returns: 苹方-中黑字体的字体对象，如果创建失败则返回系统默认字体.
    private static func art_fontPingFangSCMedium(_ fontSize: CGFloat) -> UIFont? {
        guard let font = UIFont(name: "PingFangSC-Medium", size: fontSize) else {
            return .systemFont(ofSize: fontSize)
        }
        return font
    }
    
    /// 返回一个使用苹方-中粗字体的字体对象.
    ///
    /// - Parameter fontSize: 字体的大小.
    /// - Returns: 苹方-中粗字体的字体对象，如果创建失败则返回系统默认字体.
    private static func art_fontPingFangSCSemibold(_ fontSize: CGFloat) -> UIFont? {
        guard let font = UIFont(name: "PingFangSC-Semibold", size: fontSize) else {
            return .systemFont(ofSize: fontSize)
        }
        return font
    }
    
    /// 返回一个使用苹方-粗体的字体对象.
    ///
    /// - Parameter fontSize: 字体的大小.
    /// - Returns: 苹方-粗体的字体对象，如果创建失败则返回系统默认字体.
    private static func art_fontPingFangSCBold(_ fontSize: CGFloat) -> UIFont? {
        guard let font = UIFont(name: "PingFangSC-Bold", size: fontSize) else {
            return .systemFont(ofSize: fontSize)
        }
        return font
    }
    
    /// 返回一个使用苹方-中粗黑字体的字体对象.
    ///
    /// - Parameter fontSize: 字体的大小.
    /// - Returns: 苹方-中粗黑字体的字体对象，如果创建失败则返回系统默认字体.
    private static func art_fontPingFangSCHeavy(_ fontSize: CGFloat) -> UIFont? {
        guard let font = UIFont(name: "PingFangSC-Heavy", size: fontSize) else {
            return .systemFont(ofSize: fontSize)
        }
        return font
    }
    
    /// 返回一个使用苹方-轻体字体的字体对象.
    ///
    /// - Parameter fontSize: 字体的大小.
    /// - Returns: 苹方-轻体字体的字体对象，如果创建失败则返回系统默认字体.
    private static func art_fontPingFangSCLight(_ fontSize: CGFloat) -> UIFont? {
        guard let font = UIFont(name: "PingFangSC-Light", size: fontSize) else {
            return .systemFont(ofSize: fontSize)
        }
        return font
    }
    
    /// 返回一个使用苹方-极细字体的字体对象.
    ///
    /// - Parameter fontSize: 字体的大小.
    /// - Returns: 苹方-极细字体的字体对象，如果创建失败则返回系统默认字体.
    private static func art_fontPingFangSCUltralight(_ fontSize: CGFloat) -> UIFont? {
        guard let font = UIFont(name: "PingFangSC-Ultralight", size: fontSize) else {
            return .systemFont(ofSize: fontSize)
        }
        return font
    }
    
    /// 返回一个使用苹方-纤细字体的字体对象.
    ///
    /// - Parameter fontSize: 字体的大小.
    /// - Returns: 苹方-纤细字体的字体对象，如果创建失败则返回系统默认字体.
    private static func art_fontPingFangSCThin(_ fontSize: CGFloat) -> UIFont? {
        guard let font = UIFont(name: "PingFangSC-Thin", size: fontSize) else {
            return .systemFont(ofSize: fontSize)
        }
        return font
    }
    
    /// 返回一个使用思源-黑体字体的字体对象.
    ///
    /// - Parameter fontSize: 字体的大小.
    /// - Returns: 思源-黑体字体的字体对象，如果创建失败则返回系统默认字体.
    private static func art_fontSourceHanSansHeavy(_ fontSize: CGFloat) -> UIFont? {
        guard let font = UIFont(name: "SourceHanSansCN-Heavy", size: fontSize) else {
            return .systemFont(ofSize: fontSize)
        }
        return font
    }
}

