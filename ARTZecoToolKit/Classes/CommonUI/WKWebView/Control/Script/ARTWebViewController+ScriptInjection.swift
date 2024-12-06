//
//  ARTWebViewControllerScriptInjection.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/12/6.
//

import WebKit

// MARK:  WKWebView 脚本注入扩展
extension ARTWebViewController {
    
    // MARK:  枚举：脚本注入类型
    public enum ScriptInjectionType {
        case nonoe  // 无脚本注入
        case userScript  // 使用 WKUserScript 注入脚本
        case evaluateJavaScript  // 使用 evaluateJavaScript 执行脚本
    }
    
    /// 配置 WebView 的脚本注入
    ///
    /// Parameters:
    ///  - scripts: 脚本数组，每个元素是一个 JavaScript 脚本字符串
    ///  - injectionType: 脚本注入类型，默认为 `.evaluateJavaScript`
    ///  - injectionTime: 注入脚本的时机，默认为 `.atDocumentEnd`
    ///  - forMainFrameOnly: 【仅针对主框架 = `true`】、【主框架和子框架（包括所有 iframe），默认为 `false`】。
    ///  - completion: 脚本执行完成后的回调，返回执行结果或错误
    public func configurationInjectScripts(scripts: [String],
                                           injectionType: ScriptInjectionType = .evaluateJavaScript,
                                           injectionTime: WKUserScriptInjectionTime = .atDocumentEnd,
                                           forMainFrameOnly: Bool = false,
                                           completion: (([Any]?, [Error]?) -> Void)? = nil) {
        dynamicScripts = scripts
        self.injectionType = injectionType
        self.injectionTime = injectionTime
        self.forMainFrameOnly = forMainFrameOnly
    }
    
    /// 将多个脚本注入到 WebView 中
    ///
    /// Parameters:
    ///  - scripts: 脚本数组，每个元素是一个 JavaScript 脚本字符串
    ///  - injectionType: 脚本注入类型，默认为 `.evaluateJavaScript`
    ///  - injectionTime: 注入脚本的时机，默认为 `.atDocumentEnd`
    ///  - forMainFrameOnly: 【仅针对主框架 = `true`】、【主框架和子框架（包括所有 iframe），默认为 `false`】。
    ///  - completion: 脚本执行完成后的回调，返回执行结果或错误
    public func injectScripts(completion: (([Any]?, [Error]?) -> Void)? = nil) {
        
        switch injectionType {
        case .userScript: // 适合全局和持久化脚本注入，注入的脚本会对后续加载的页面（主框架或子框架）自动生效，无需每次手动注入
            dynamicScripts.forEach {
                addJavaScript(script: $0,
                              injectionTime: injectionTime,
                              forMainFrameOnly: forMainFrameOnly)
            }
            webView.reload() // 需要重新加载页面，才能使注入的脚本生效
            
        case .evaluateJavaScript: // 适合临时和即时脚本执行，脚本的作用是一次性的，不需要对后续加载页面生效
            executeJavaScripts(scripts: dynamicScripts, completion: completion)
        default:
            break
        }
    }
}

// MARK:  Dynamic UserScript Injection

extension ARTWebViewController {
    
    /// 动态添加 JavaScript 脚本。
    ///
    ///  Parameters:
    ///    script: JavaScript 脚本内容。
    ///    injectionTime: 注入时间，默认为 `.atDocumentEnd`。
    ///    forMainFrameOnly: 【仅针对主框架 = `true`】、【主框架和子框架（包括所有 iframe），默认为 `false`】。
    public func addJavaScript(script: String, injectionTime: WKUserScriptInjectionTime = .atDocumentEnd, forMainFrameOnly: Bool = false) {
        let userScript = WKUserScript(source: script,
                                      injectionTime: injectionTime,
                                      forMainFrameOnly: forMainFrameOnly)
        webView.configuration.userContentController.addUserScript(userScript)
    }
    
    /// 移除所有动态添加的 JavaScript 脚本。
    public func removeAllJavaScript() {
        webView.configuration.userContentController.removeAllUserScripts()
    }
}

// MARK: - Dynamic JavaScript Execution

extension ARTWebViewController {
    
    /// 动态执行多个 JavaScript 脚本，并返回结果和错误。
    ///
    /// - Parameters:
    ///   - scripts: 脚本内容的数组，每个元素为一个 JavaScript 脚本字符串。
    ///   - completion: 执行完成后的回调，返回所有脚本的执行结果和错误。
    public func executeJavaScripts(scripts: [String], completion: (([Any]?, [Error]?) -> Void)? = nil) {
        var results: [Any] = []  // 存储每个脚本的执行结果
        var errors: [Error] = []  // 存储脚本执行中的错误
        let dispatchGroup = DispatchGroup()
        
        scripts.forEach { script in
            dispatchGroup.enter()
            webView.evaluateJavaScript(script) { (result, error) in
                if let error = error {
                    print("注入脚本时发生错误: \(error.localizedDescription)")
                    errors.append(error)
                } else {
                    print("脚本注入成功: \(String(describing: result))")
                    results.append(result ?? "无返回值")
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion?(results.isEmpty ? nil : results, errors.isEmpty ? nil : errors)
        }
    }
}
