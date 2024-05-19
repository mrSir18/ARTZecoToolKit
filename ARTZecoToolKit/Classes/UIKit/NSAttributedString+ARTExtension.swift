//
//  NSAttributedString+ARTExtension.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/5/19.
//

import UIKit

extension NSAttributedString {
    
    /// 创建带有价格符号的富文本字符串.
    ///
    /// - Parameters:
    ///  - text: 价格字符串.
    ///  - symbolFont:  价格符号字体.
    ///  - middleFont:  价格整数部分字体.
    ///  - decimalFont: 价格小数部分字体.
    func createAttributedPriceString(_ text: String,
                                     _ symbolFont: UIFont,
                                     _ middleFont: UIFont,
                                     _ decimalFont: UIFont) -> NSAttributedString {
        let pattern = "¥([0-9]+)(\\.[0-9]{2})?"
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let matches = regex.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))
            guard let match = matches.first else {
                return NSAttributedString(string: text)
            }
            let symbolRange  = match.range(at: 0)
            let middleRange  = match.range(at: 1)
            let decimalRange = match.range(at: 2)

            let attrib = NSMutableAttributedString(string: text)
            
            attrib.addAttribute(.font, value: symbolRange, range: symbolRange)
            attrib.addAttribute(.font, value: middleFont, range: middleRange)
            
            // 如果存在小数部分，应用对应的字体样式
            if decimalRange.location != NSNotFound {
                attrib.addAttribute(.font, value: decimalFont, range: decimalRange)
            }
            return attrib
        } catch {
            print("Invalid regular expression: \(error.localizedDescription)")
            return NSAttributedString(string: text)
        }
    }
}
