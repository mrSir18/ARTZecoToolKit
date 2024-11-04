//
//  ARTVideoPlayerSlidingOverlayView.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/11/4.
//

/// 协议方法
///
/// - NOTE: 可继承该协议方法
@objc public protocol ARTVideoPlayerSlidingOverlayViewDelegate: AnyObject {
    
}

open class ARTVideoPlayerSlidingOverlayView: UIView {
    
    /// 代理对象
    public weak var delegate: ARTVideoPlayerSlidingOverlayViewDelegate?
    
    
    // MARK: - Initialization
    
    public init(_ delegate: ARTVideoPlayerSlidingOverlayViewDelegate? = nil) {
        super.init(frame: .zero)
        self.delegate = delegate
        self.backgroundColor = .clear
        setupViews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Super Methods
    
    /// 重写父类方法，设置子视图
    open func setupViews() {
        
    }
}
