//
//  ARTVideoPlayerBottombar.swift
//  Pods
//
//  Created by mrSir18 on 2024/10/15.
//

public protocol ARTVideoPlayerBottombarDelegate: AnyObject {
    /// 协议方法
    ///
    /// - NOTE: 可继承该协议方法
}

open class ARTVideoPlayerBottombar: UIView {

    /// 代理对象
    public weak var delegate: ARTVideoPlayerBottombarDelegate?
    
    
    // MARK: - Initialization

    public init(_ delegate: ARTVideoPlayerBottombarDelegate? = nil) {
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
    ///
    /// - Note: 由于子类需要自定义视图，所以需要重写该方法
    open func setupViews() {
        
    }
}
