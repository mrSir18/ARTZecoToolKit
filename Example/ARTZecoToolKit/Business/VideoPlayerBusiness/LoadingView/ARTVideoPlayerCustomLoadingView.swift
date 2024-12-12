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
    private var loadingView: ARTPagView!
    
    
    // MARK: - Override Super Methods
    
    open override func setupViews() {
        
        /// 创建动画视图
        loadingView = ARTPagView()
        addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(ARTAdaptedSize(width: 200.0, height: 200.0))
        }
    }
    
    override func startLoading() { // 开始动画
        super.startLoading()
        loadingView.playAnimation(_withFileName: "loading", repeatCount: 0)
    }
    
    override func stopLoading() { // 停止动画
        super.stopLoading()
        if loadingView.isPlaying() { loadingView.stop() } // 停止动画
    }
}
