//
//  ARTViewController_VideoPlayer.swift
//  ARTZecoToolKit_Example
//
//  Created by mrSir18 on 2024/5/20.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import AVFoundation
import ARTZecoToolKit

class ARTViewController_VideoPlayer: ARTBaseViewController {
    
    /// 播放器视图
    private var playerView: ARTVideoPlayerView!

    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayerView()
    }

    private func setupPlayerView() { // 创建播放器视图
        playerView = ARTVideoPlayerView(self)
        playerView.backgroundColor = .black
        view.addSubview(playerView)
        playerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(ARTAdaptedValue(208.0))
        }
    }
}

extension ARTViewController_VideoPlayer: ARTVideoPlayerViewProtocol {
    
    func customPlayerMode(for playerView: ARTVideoPlayerView) -> ARTVideoPlayerView.VideoPlayerMode {
        return .fullscreen
    }
}
