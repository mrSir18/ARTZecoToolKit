//
//  ARTVideoPlayerDanmakuView.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/11/4.
//

/// 协议方法
///
/// - NOTE: 可继承该协议方法
public protocol ARTVideoPlayerDanmakuViewDelegate: ARTVideoPlayerSlidingOverlayViewDelegate {

}

open class ARTVideoPlayerDanmakuView: ARTVideoPlayerSlidingOverlayView {
    
    /// 代理对象
    public weak var subclassDelegate: ARTVideoPlayerDanmakuViewDelegate?
    
    
    // MARK: - Initializatio
    
    public init(_ subclassDelegate: ARTVideoPlayerDanmakuViewDelegate? = nil) {
        self.subclassDelegate = subclassDelegate
        super.init(subclassDelegate)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Super Methods
    
    open override func setupViews() {
        super.setupViews()

    }
}
