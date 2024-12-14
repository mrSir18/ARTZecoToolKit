//
//  ARTVideoPlayerLoadingView.swift
//  ARTZecoToolKit_Example
//
//  Created by mrSir18 on 2024/12/12.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

/// 协议方法
///
/// - NOTE: 可继承该协议方法
@objc public protocol ARTVideoPlayerLoadingViewDelegate: AnyObject {
    
}

open class ARTVideoPlayerLoadingView: UIView {
    
    /// 代理对象
    public weak var delegate: ARTVideoPlayerLoadingViewDelegate?


    // MARK: - Initialization
    
    public init(_ delegate: ARTVideoPlayerLoadingViewDelegate? = nil) {
        self.delegate = delegate
        super.init(frame: .zero)
        self.backgroundColor = .black
        setupViews()
    }
    
    required public init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Open Methods
    
    open func setupViews() {
        
    }
}

// MARK: - Public Methods

extension ARTVideoPlayerLoadingView {
    
    /// 开始加载动画
    @objc open func startLoading() {
        self.isHidden = false
    }
    
    /// 结束加载动画
    @objc open func stopLoading() {
        self.isHidden = true
    }
}
