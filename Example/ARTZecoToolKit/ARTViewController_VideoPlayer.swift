//
//  ARTViewController_VideoPlayer.swift
//  ARTZecoToolKit_Example
//
//  Created by mrSir18 on 2024/5/20.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import ARTZecoToolKit
import AVFoundation

class ARTViewController_VideoPlayer: ARTBaseViewController {
    
    /// 按钮
    private lazy var playerButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = .art_regular(16.0)
        button.backgroundColor  = .art_randomColor()
        button.setTitle("播放视频", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(videoPlayerButtonAction), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        view.addSubview(playerButton)
        playerButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 150.0, height: 150.0))
            make.center.equalToSuperview()
        }
    }
    
    @objc private func videoPlayerButtonAction () {
        
        // 创建播放器
        guard let videoURL = Bundle.main.url(forResource: "video", withExtension: "MOV") else {
            fatalError("视频文件不存在")
        }
        let player = AVPlayer(url: videoURL)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = UIScreen.main.bounds
        playerLayer.videoGravity = .resizeAspectFill
        keyWindow.layer.addSublayer(playerLayer)
        player.play()
    }
}
