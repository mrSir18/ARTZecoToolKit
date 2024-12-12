//
//  ARTVideoPlayerCustomLoadingView.swift
//  ARTZecoToolKit_Example
//
//  Created by mrSir18 on 2024/12/12.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import ARTZecoToolKit

class ARTVideoPlayerCustomLoadingView: ARTVideoPlayerLoadingView {
    
    /// 动画视图
    private var loadingView: UIView!
    
    
    // MARK: - Override Super Methods
    
    open override func setupViews() {
        /// 创建动画视图
        loadingView = UIView()
        loadingView.backgroundColor = .art_randomColor()
        addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(ARTAdaptedSize(width: 200.0, height: 200.0))
        }
    }
    
    override func startLoading() { // 开始动画
        super.startLoading()
    }
    
    override func stopLoading() { // 停止动画
        super.stopLoading()
    }
}
