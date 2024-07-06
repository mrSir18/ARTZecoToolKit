//
//  UITextField+ARTExtension.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/7/6.
//

extension UITextField {
    
    /// 设置占位符的颜色.
    ///
    /// - Parameter color: 占位符的颜色.
    /// - Note: 该方法会覆盖掉原有的占位符颜色.
    func setPlaceholderColor(_ color: UIColor) {
        guard let placeholder = self.placeholder else { return }
        self.attributedPlaceholder = NSAttributedString(string: placeholder, 
                                                        attributes: [NSAttributedString.Key.foregroundColor: color])
    }
}
