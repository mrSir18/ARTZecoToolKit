//
//  ARTViewController_VideoPlayer.swift
//  ARTZecoToolKit_Example
//
//  Created by mrSir18 on 2024/5/20.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import ARTZecoToolKit

/*
 - Note: 1、视频播放器全屏时需要设置如下代码,以保证状态栏隐藏
         2、实现代理：func refreshStatusBarAppearance(for playerView: ARTVideoPlayerView, isStatusBarHidden: Bool)
         3、Plist 文件中设置View controller-based status bar appearance 为 YES
         4、在需要隐藏状态栏的 ViewController 中重写 prefersStatusBar
 
 extension UINavigationController {
     open override var prefersStatusBarHidden: Bool {
         return topViewController?.prefersStatusBarHidden ?? true
     }
 }
 */

class ARTViewController_VideoPlayer: ARTBaseViewController {
    
    /// 播放器视图
    private var playerView: ARTVideoPlayerView!
    
    /// 是否隐藏状态栏
    private var isStatusBarHidden: Bool = false
    
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayerView()
    }

    private func setupPlayerView() { // 创建播放器视图
        playerView = ARTVideoPlayerView(self)
        playerView.frame = CGRectMake(0.0, ARTAdaptedValue(200.0), self.view.frame.size.width, ARTAdaptedValue(208))
        view.addSubview(playerView)
        
        let config = ARTVideoPlayerConfig()
        config.url = URL(string: "https://media.w3.org/2010/05/sintel/trailer.mp4")
        playerView.playVideo(with: config)
    }
    
    override var prefersStatusBarHidden: Bool { // 状态栏是否隐藏
         return isStatusBarHidden
    }
}

extension ARTViewController_VideoPlayer: ARTVideoPlayerViewProtocol {
    
    func customScreenOrientation(for playerView: ARTVideoPlayerView) -> ARTVideoPlayerView.ScreenOrientation { // 自定义屏幕方向
        return .window
    }
    
    func refreshStatusBarAppearance(for playerView: ARTVideoPlayerView, isStatusBarHidden: Bool) { // 刷新状态栏显示
        self.isStatusBarHidden = isStatusBarHidden
        setNeedsStatusBarAppearanceUpdate()
    }
}
