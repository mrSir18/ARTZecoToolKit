//
//  ARTCustomView.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/7/10.
//

public class ARTCustomView: UIView {
    
    /// 背景颜色
    ///
    /// - Note:
    /// 默认值为 UIColor.clear.
    public var customBackgroundColor: UIColor = UIColor.clear {
        didSet {
            setNeedsDisplay()
        }
    }

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
        
        // 创建路径
        let path = UIBezierPath(roundedRect: bounds.insetBy(dx: borderWidth / 2, dy: borderWidth / 2), cornerRadius: cornerRadius)
        
        // 设置背景颜色
        context.addPath(path.cgPath)
        context.setFillColor(customBackgroundColor.cgColor)
        context.fillPath()
        
        // 设置边框颜色
        context.addPath(path.cgPath)
        context.setStrokeColor(borderColor.cgColor)
        context.setLineWidth(borderWidth)
        context.strokePath()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayer()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayer()
    }
    
    private func setupLayer() {
        backgroundColor = .clear
        layer.allowsEdgeAntialiasing = true
        layer.edgeAntialiasingMask   = [.layerLeftEdge, .layerRightEdge, .layerBottomEdge, .layerTopEdge]
    }
}
