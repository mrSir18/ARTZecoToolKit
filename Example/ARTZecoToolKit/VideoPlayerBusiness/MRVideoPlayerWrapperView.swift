//
//  MRVideoPlayerWrapperView.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/10/19.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import AVFoundation

/// 视频播放器包装视图，管理视频播放和全屏功能
open class MRVideoPlayerWrapperView: UIView {
    
    /// 视频播放器
    public var player: AVPlayer!
    
    /// 播放器的状态
    public var playerItem: AVPlayerItem!
    
    /// 全屏管理器
    private var fullscreenManager: MRVideoFullscreenManager!
    
    
    // MARK: - Initialization
    
    public init() {
        super.init(frame: .zero)
        self.backgroundColor = .black
        fullscreenManager = MRVideoFullscreenManager(videoWrapperView: self)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Test Methods
    
    /// 播放指定URL的视频
    ///
    /// - Parameter url: 视频URL
    open func playVideo(with url: URL) {
        playerItem = AVPlayerItem(asset: AVAsset(url: url))
        player = AVPlayer(playerItem: playerItem)
        
        if let playerLayer = layer as? AVPlayerLayer {
            playerLayer.player = player
            playerLayer.videoGravity = .resizeAspect
        }
        
        player.play()
        setupFullscreenButton()
    }

    private func setupFullscreenButton() {
        let fullscreenButton = UIButton(type: .custom)
        fullscreenButton.setTitle("全屏", for: .normal)
        fullscreenButton.setTitleColor(.white, for: .normal)
        fullscreenButton.backgroundColor = .art_randomColor()
        fullscreenButton.addTarget(self, action: #selector(toggleFullscreen(_:)), for: .touchUpInside)
        addSubview(fullscreenButton)
        fullscreenButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 100, height: 60))
        }
    }
    
    @objc private func toggleFullscreen(_ sender: UIButton) {
        sender.isSelected.toggle()
        sender.setTitle(sender.isSelected ? "退出全屏" : "全屏", for: .normal)
        sender.isSelected ? fullscreenManager.presentFullscreenWithRotation() : fullscreenManager.dismiss()
    }
}

// MARK: - Layer Class

extension MRVideoPlayerWrapperView {
    open override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
}
