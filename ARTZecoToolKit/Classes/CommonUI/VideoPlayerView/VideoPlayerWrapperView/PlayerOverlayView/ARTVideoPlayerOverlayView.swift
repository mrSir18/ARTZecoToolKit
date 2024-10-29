//
//  ARTVideoPlayerOverlayView.swift
//  Pods
//
//  Created by mrSir18 on 2024/10/19.
//

/// 协议方法
///
/// - NOTE: 可继承该协议方法
public protocol ARTVideoPlayerOverlayViewDelegate: AnyObject {
    
}

open class ARTVideoPlayerOverlayView: ARTPassThroughView {
    
    /// 代理对象
    public weak var delegate: ARTVideoPlayerOverlayViewDelegate?
    
    
    // MARK: - Initialization
    
    public init(_ delegate: ARTVideoPlayerOverlayViewDelegate? = nil) {
        super.init(frame: .zero)
        self.delegate = delegate
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Override Super Methods
    
    /// 重写父类方法，设置子视图
    open override func setupViews() {

    }
}
