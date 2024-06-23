//
//  ARTCustomButton.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/6/23.
//

import UIKit

public class ARTCustomButton: UIButton {

    /// 边框宽度
    ///
    /// - Note:
    ///  默认值为 0.
    public var borderWidth: CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// 圆角半径
    ///
    /// - Note:
    ///  默认值为 0.
    public var cornerRadius: CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// 边框颜色
    ///
    /// - Note:
    /// 默认值为 UIColor.clear.
    public var borderColor: UIColor = UIColor.clear {
        didSet {
            setNeedsDisplay()
        }
    }

    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }

        // 设置边框颜色
        context.setStrokeColor(borderColor.cgColor)
        context.setLineWidth(borderWidth)
        
        // 创建路径
        let path = UIBezierPath(roundedRect: bounds.insetBy(dx: borderWidth / 2, dy: borderWidth / 2), cornerRadius: cornerRadius)
        context.addPath(path.cgPath)
        context.strokePath()
    }
}
