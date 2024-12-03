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
    
    /// 弹幕尺寸（宽度 - 必须设定）
    public var danmakuSize: CGSize = .zero
    
    
    // MARK: - Initialization
    
    public init(_ delegate: ARTDanmakuCellDelegate? = nil) {
        super.init(frame: .zero)
        self.isUserInteractionEnabled = true
        self.delegate = delegate
        setupViews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Super Methods
    
    open func setupViews() {

    }
}
