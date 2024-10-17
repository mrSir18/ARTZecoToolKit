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
    
    /// 播放器容器视图
    private var containerView: UIView!
    
    /// 是否隐藏状态栏
    private var isStatusBarHidden: Bool = false
    
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContainerView()
        setupPlayerView()
    }
    
    // MARK: - Setup Methods
    
    private func setupContainerView() { // 创建容器视图
        containerView = UIView()
        containerView.backgroundColor = .white
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(art_statusBarHeight())
        }
    }
    
    private func setupPlayerView() { // 创建播放器视图
        let playerView = ARTVideoPlayerView(self)
        playerView.frame.origin = CGPoint(x: 0.0, y: art_statusBarHeight())
        playerView.frame.size = CGSize(width: UIScreen.art_currentScreenWidth,
                                       height: ARTAdaptedValue(208))
        view.addSubview(playerView)
        
        let config = ARTVideoPlayerConfig()
        config.url = URL(string: "https://media.w3.org/2010/05/sintel/trailer.mp4")
//        config.url = URL(fileURLWithPath: Bundle.main.path(forResource: "video", ofType: "MOV")!)
//        https://www.w3school.com.cn/example/html5/mov_bbb.mp4
//        http://vjs.zencdn.net/v/oceans.mp4
        playerView.playVideo(with: config)
    }
    
    // MARK: Override Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .black
        baseContainerView.isHidden = true
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
