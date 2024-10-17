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
    
    var isStatusBarHidden = false {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayerView()
    }

    private func setupPlayerView() { // 创建播放器视图
        playerView = ARTVideoPlayerView(self)
        playerView.frame = CGRectMake(0, ARTAdaptedValue(200.0), self.view.frame.size.width, ARTAdaptedValue(208))
        playerView.onOrientationChange = { [weak self] in
            self?.isStatusBarHidden = true
         }
        view.addSubview(playerView)
        
        let config = ARTVideoPlayerConfig()
        config.url = URL(string: "https://media.w3.org/2010/05/sintel/trailer.mp4")
        playerView.playVideo(with: config)
    }
}

extension ARTViewController_VideoPlayer: ARTVideoPlayerViewProtocol {
    
    func customPlayerMode(for playerView: ARTVideoPlayerView) -> ARTVideoPlayerView.VideoPlayerMode {
        return .window
    }


    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }

}
