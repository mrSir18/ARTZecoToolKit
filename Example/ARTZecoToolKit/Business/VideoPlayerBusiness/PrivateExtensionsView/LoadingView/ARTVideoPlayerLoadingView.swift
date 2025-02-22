//
//  ARTVideoPlayerLoadingView.swift
//  ARTZecoToolKit_Example
//
//  Created by mrSir18 on 2024/12/12.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import ARTZecoToolKit

/// 协议方法
///
/// - NOTE: 可继承该协议方法
@objc public protocol ARTVideoPlayerLoadingViewDelegate: AnyObject {
    
}

open class ARTVideoPlayerLoadingView: UIView {
    
    /// 代理对象
    public weak var delegate: ARTVideoPlayerLoadingViewDelegate?

    /// 动画视图
    private var loadingView: ARTPagView!
    
    
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
        /// 创建动画视图
        loadingView = ARTPagView()
        addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(ARTAdaptedSize(width: 150.0, height: 150.0))
        }
    }
}

// MARK: - Public Methods

extension ARTVideoPlayerLoadingView {
    
    /// 开始动画
    @objc open func startLoading() {
        self.isHidden = false
        loadingView.playAnimation(_withFileName: "loading", repeatCount: 0)
    }
    
    /// 停止动画
    @objc open func stopLoading() {
        self.isHidden = true
        if loadingView.isPlaying() { loadingView.stop() }
    }
}
