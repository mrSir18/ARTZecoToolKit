//
//  NSMutableAttributedString+ARTExtension.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/5/19.
//

extension NSMutableAttributedString {
    
    /// 创建带有货币符号的富文本字符串。
    ///
    /// - Parameters:
    ///   - text: 价格字符串。
    ///   - symbolFont: 货币符号字体。
    ///   - integerFont: 整数部分字体。
    ///   - decimalFont: 小数部分字体。
    /// - Returns: 带有货币符号的富文本字符串。
    public static func attributedStringWithCurrencySymbol(_ text: String,
                                                          symbolFont: UIFont?,
                                                          integerFont: UIFont?,
                                                          decimalFont: UIFont?) -> NSAttributedString {
        guard text.count > 0 else {
             print("Price text is empty.")
             return NSAttributedString(string: "")
         }
        
        let pattern = "¥([0-9]+)(\\.[0-9]*)?"
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let matches = regex.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))
            guard let match = matches.first else {
                return NSAttributedString(string: text)
            }
            
            let symbolRange  = match.range(at: 0)
            let integerRange = match.range(at: 1)
            let decimalRange = match.range(at: 2)
            
            let attributedString = NSMutableAttributedString(string: text)
            
            if let symbolFont = symbolFont {
                attributedString.addAttribute(.font, value: symbolFont, range: symbolRange)
            }
            
            if let integerFont = integerFont {
                attributedString.addAttribute(.font, value: integerFont, range: integerRange)
            }
            
            // 设置小数部分字体，如果存在
            if let decimalFont = decimalFont, decimalRange.location != NSNotFound {
                attributedString.addAttribute(.font, value: decimalFont, range: decimalRange)
            }
            
            return attributedString
        } catch {
            print("Invalid regular expression: \(error.localizedDescription)")
            return NSMutableAttributedString(string: text)
        }
    }
}


