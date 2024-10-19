//
//  ARTViewController_VideoPlayer.swift
//  ARTZecoToolKit_Example
//
//  Created by mrSir18 on 2024/5/20.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import ARTZecoToolKit

/*
 - Note: 1.0: AppDelegate 设置
         2.0: 基类视图控制器设置 - ARTBaseViewController
         2.1: 导航控制器设置 - ARTBaseNavigationController
         2.2: 标签控制器设置 - ARTBaseTabBarController
         3.0: 视频常用比例 - 16:9、4:3、1:1
 
 TODO: 1.0、AppDelegate 设置
 
 extension AppDelegate {
     func application(_: UIApplication, supportedInterfaceOrientationsFor _: UIWindow?) -> UIInterfaceOrientationMask { // 全局设置屏幕旋转 - 仅支持竖屏
         return .allButUpsideDown
     }
 }
 
 TODO: 2.0、视图控制器设置
 
 extension ARTBaseViewController {
     
     /// 是否支持自动旋转
     override var shouldAutorotate: Bool {
         return false
     }
     
     /// 支持哪些屏幕方向
     override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
         return .portrait
     }
     
     /// 默认的屏幕方向
     override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
         return .portrait
     }
     
     /// 状态栏样式
     override var preferredStatusBarStyle: UIStatusBarStyle {
         return .default
     }
     
     /// 是否隐藏状态栏
     override var prefersStatusBarHidden: Bool {
         return false
     }
 }
 
 TODO: 2.1、导航控制器设置
 
 extension ARTBaseNavigationController {
     
     /// 是否支持自动转屏
     override var shouldAutorotate: Bool {
         return topViewController?.shouldAutorotate ?? false
     }
     
     /// 支持哪些屏幕方向
     override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
         return topViewController?.supportedInterfaceOrientations ?? .portrait
     }
     
     /// 默认的屏幕方向
     override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
         return topViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
     }
     
     /// 状态栏样式
     override var preferredStatusBarStyle: UIStatusBarStyle {
         return topViewController?.preferredStatusBarStyle ?? .default
     }
     
     /// 是否隐藏状态栏
     override var prefersStatusBarHidden: Bool {
         return topViewController?.prefersStatusBarHidden ?? false
     }
 }
 
 TODO: 2.2、标签控制器设置
 
 extension ARTBaseTabBarController {
     
     /// 获取当前选中视图控制器的指定属性
     ///
     /// - Parameter keyPath: 属性路径
     /// - Returns: 属性值
     /// - Note: 如果当前选中的视图控制器是导航控制器，则返回其顶部视图控制器的对应属性
     private func getSelectedViewControllerProperty<T>(_ keyPath: KeyPath<UIViewController, T>) -> T? {
         guard let navigationController = selectedViewController as? UINavigationController else {
             return selectedViewController?[keyPath: keyPath] ?? nil
         }
         return navigationController.topViewController?[keyPath: keyPath] ?? nil
     }

     /// 是否支持自动转屏
     override var shouldAutorotate: Bool {
         return getSelectedViewControllerProperty(\.shouldAutorotate) ?? false
     }

     /// 支持哪些屏幕方向
     override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
         return getSelectedViewControllerProperty(\.supportedInterfaceOrientations) ?? .portrait
     }

     /// 默认的屏幕方向
     override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
         return getSelectedViewControllerProperty(\.preferredInterfaceOrientationForPresentation) ?? .portrait
     }

     /// 状态栏样式
     override var preferredStatusBarStyle: UIStatusBarStyle {
         return getSelectedViewControllerProperty(\.preferredStatusBarStyle) ?? .default
     }

     /// 是否隐藏状态栏
     override var prefersStatusBarHidden: Bool {
         return getSelectedViewControllerProperty(\.prefersStatusBarHidden) ?? false
     }
 }
 
 TODO: 3.0、视频常用比例
 
 let aspectRatio: CGFloat = 16.0 / 9.0 // 16:9 比例
 let aspectRatio: CGFloat = 4.0 / 3.0 // 4:3 比例
 let aspectRatio: CGFloat = 1.0 // 1:1 比例
 
 */

//class ARTViewController_VideoPlayer: ARTBaseViewController {
//    
//    /// 播放器容器视图
//    private var containerView: UIView!
//    
//    /// 是否隐藏状态栏
//    private var isStatusBarHidden: Bool = false
//    
//    
//    // MARK: - Initialization
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupContainerView()
//        setupPlayerView()
//    }
//    
//    // MARK: - Setup Methods
//    
//    private func setupContainerView() { // 创建容器视图
//        containerView = UIView()
//        containerView.backgroundColor = .white
//        view.addSubview(containerView)
//        containerView.snp.makeConstraints { make in
//            make.left.bottom.right.equalToSuperview()
//            make.top.equalTo(art_statusBarHeight())
//        }
//    }
//    
//    private func setupPlayerView() { // 创建播放器视图
//        let playerView = ARTVideoPlayerView(self)
//        playerView.frame.origin = CGPoint(x: 0.0, y: art_statusBarHeight())
//        playerView.frame.size = CGSize(width: UIScreen.art_currentScreenWidth,
//                                       height: ARTAdaptedValue(208))
//        view.addSubview(playerView)
//        
//        let config = ARTVideoPlayerConfig()
//        config.url = URL(string: "https://media.w3.org/2010/05/sintel/trailer.mp4")
////        config.url = URL(fileURLWithPath: Bundle.main.path(forResource: "video", ofType: "MOV")!)
////        https://www.w3school.com.cn/example/html5/mov_bbb.mp4
////        http://vjs.zencdn.net/v/oceans.mp4
//        playerView.playVideo(with: config)
//    }
//    
//    // MARK: Override Methods
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        view.backgroundColor = .black
//        baseContainerView.isHidden = true
//    }
//    
//    override var prefersStatusBarHidden: Bool { // 状态栏是否隐藏
//         return isStatusBarHidden
//    }
//}
//
//extension ARTViewController_VideoPlayer: ARTVideoPlayerViewProtocol {
//    
//    func customScreenOrientation(for playerView: ARTVideoPlayerView) -> ARTVideoPlayerView.ScreenOrientation { // 自定义屏幕方向
//        return .window
//    }
//    
//    func refreshStatusBarAppearance(for playerView: ARTVideoPlayerView, isStatusBarHidden: Bool) { // 刷新状态栏显示
//        self.isStatusBarHidden = isStatusBarHidden
//        setNeedsStatusBarAppearanceUpdate()
//    }
//}


// MARK: - Test Methods

class ARTViewController_VideoPlayer: ARTBaseViewController {

    // MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()
        setupContainerView()
    }

    // MARK: - Setup Methods

    private func setupContainerView() { // 创建容器视图
        let aspectRatio: CGFloat = 16.0 / 9.0
        let videoPlayerView = MRVideoPlayerView()
        view.addSubview(videoPlayerView)
        videoPlayerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(view.bounds.width / aspectRatio)
        }
    }
}
