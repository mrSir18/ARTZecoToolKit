//
//  UITextField+ARTExtension.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/7/6.
//

extension UITextField {
    
    /// 设置占位符的颜色和字体.
    ///
    /// - Parameters:
    ///  - color: 占位符颜色.
    ///  - font: 占位符字体.
    ///  - Note: 该方法
    public func art_placeholderColor(_ color: UIColor, font: UIFont) {
        guard let placeholder = self.placeholder else { return }
        self.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                        attributes: [.foregroundColor: color,
                                                                     .font: font])
    }
}
