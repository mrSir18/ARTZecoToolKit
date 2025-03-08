//
//  ARTVideoPlayerLoadingView.swift
//  ARTZeco
//
//  Created by mrSir18 on 2024/12/12.
//

import ARTZecoToolKit

class ARTVideoPlayerLoadingView: UIView {

    /// 动画视图
    private var loadingView: ARTPagView!
    
    
    // MARK: - Initialization
    
    init() {
        super.init(frame: .zero)
        self.isHidden = true
        self.backgroundColor = .black
        setupViews()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        setupLoadingView()
    }
}

// MARK: - Public Methods

extension ARTVideoPlayerLoadingView {
    
    /// 开始动画
    func startLoading() {
        self.isHidden = false
        loadingView.playAnimation(_withFileName: "video_loading", repeatCount: 0)
        loadingView.play()
    }
    
    /// 停止动画
    func stopLoading() {
        self.isHidden = true
        if loadingView.isPlaying() { loadingView.stop() }
    }
}

// MARK: - Setup Initializer

extension ARTVideoPlayerLoadingView {
    
    /// 设置加载视图
    private func setupLoadingView() {
        loadingView = ARTPagView()
        addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(ARTAdaptedSize(width: 82.0, height: 82.0))
        }
    }
}
