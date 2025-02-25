//
//  ARTDanmakuCell.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/11/27.
//

open class ARTDanmakuCell: UIView {
    
    /// 弹幕尺寸（宽度 - 必须设定）
    public var danmakuSize: CGSize = .zero
    
    
    // MARK: - Initialization
    
    public init() {
        super.init(frame: .zero)
        self.isUserInteractionEnabled = true
        setupViews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Super Methods
    
    open func setupViews() {

    }
}
