//
//  ARTDanmakuCell.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/11/27.
//

// 协议方法
//
// - NOTE: 可继承该协议方法，实现自定义的弹幕视图
@objc public protocol ARTDanmakuCellDelegate: AnyObject {
    
}

open class ARTDanmakuCell: UIView {
    
    /// 代理对象
    public weak var delegate: ARTDanmakuCellDelegate?
    
    /// 弹幕尺寸（必须设定）
    public var danmakuSize: CGSize = .zero
    
    
    // MARK: - Initializer
    
    public init() {
        super.init(frame: .zero)
        isUserInteractionEnabled = true
        setupViews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Super Methods
    
    open func setupViews() {
        let contents: [String] = [
            "这款产品非常好，使用！",
            "质量很不错。",
            "非常满意的一次购。",
            "非常亮。",
            "收到商品比很高。",
            "给朋友买的，他很喜欢，赞一个！",
            "弹幕 😄 \(arc4random())"
        ]
        let bulletLabel = UILabel()
        bulletLabel.text = contents.randomElement()
        bulletLabel.textColor = .white
        bulletLabel.font = UIFont.systemFont(ofSize: 16)
        bulletLabel.backgroundColor = .art_randomColor()
        bulletLabel.sizeToFit()
        addSubview(bulletLabel)
        danmakuSize = bulletLabel.bounds.size
    }
}
