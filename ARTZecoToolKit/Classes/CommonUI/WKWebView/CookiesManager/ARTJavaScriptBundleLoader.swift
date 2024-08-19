//
//  ARTJavaScriptBundleLoader.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/8/19.
//

/// 管理和加载 JS 代码的工具类。
///
/// 用于加载本地的 JavaScript 代码，例如用于注入到 WKWebView 中的 Cookie 相关代码。
class ARTJavaScriptBundleLoader {
    
    /// ARTZecoToolKit 框架的 Bundle 路径。
    private static let frameworkBundlePath = "Frameworks/ARTZecoToolKit.framework/ARTZecoToolKit.bundle"
    /// ARTZecoToolKit 库的 Bundle 路径。
    private static let libBundlePath = "ARTZecoToolKit.bundle"
    
    /**
     加载本地 JavaScript 文件的内容。
     
     - Parameters:
     - fileName: 文件名（不包括扩展名）。
     - type: 文件类型（例如 "js"）。
     - Returns: JavaScript 代码的字符串。如果文件无法加载，则返回 nil。
     */
    static func loadJavaScriptCode(fileName: String, ofType type: String) -> String? {
        // 尝试从两个路径中加载 JavaScript 代码
        let loadedJavaScript = loadJavaScriptCode(fromBundleAt: frameworkBundlePath, fileName: fileName, ofType: type) ??
                               loadJavaScriptCode(fromBundleAt: libBundlePath, fileName: fileName, ofType: type)
        return loadedJavaScript
    }
    
    private static func loadJavaScriptCode(fromBundleAt bundlePath: String, fileName: String, ofType type: String) -> String? {
        /// 从指定路径加载 JavaScript 代码。
        guard let bundle = bundle(forPath: bundlePath) else { return nil }
        /// 从指定 Bundle 中加载指定文件的内容。
        guard let filePath = bundle.path(forResource: fileName, ofType: type) else { return nil }
        /// 从指定文件路径加载文件内容。
        return try? String(contentsOfFile: filePath, encoding: .utf8)
    }
    
    /// 返回指定路径的 Bundle 实例。
    ///
    /// - Parameter path: Bundle 的相对路径。
    /// - Returns: 对应路径的 Bundle 实例，如果路径无效则返回 nil。
    private static func bundle(forPath path: String) -> Bundle? {
        let fullPath = (Bundle.main.resourcePath as NSString?)?.appendingPathComponent(path)
        return Bundle(path: fullPath ?? "")
    }
}
