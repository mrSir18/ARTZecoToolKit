//
//  ARTViewController_VideoPlayer.swift
//  ARTZecoToolKit_Example
//
//  Created by mrSir18 on 2024/5/20.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import AVFoundation
import MobileCoreServices
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

class ARTViewController_VideoPlayer: ARTBaseViewController {
    
    /// 播放器视图
    public var playerView: ARTVideoPlayerView!

    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayerView()
//        setupSupportedAVPlayerFileExtensions()
    }
    
    // MARK: - Setup Methods

    private func setupPlayerView() { // 创建播放器视图
        let aspectRatio: CGFloat = 16.0 / 9.0
        playerView = ARTVideoPlayerView(self)
        playerView.backgroundColor = .art_randomColor()
        view.addSubview(playerView)
        playerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(view.bounds.width / aspectRatio)
        }
    
        // MARK: - Test Methods
        
        let url = URL(string: "https://media.w3.org/2010/05/sintel/trailer.mp4")
//        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "video", ofType: "MP4")!)
//        let url = URL(string: "https://www.apple.com/105/media/cn/mac/family/2018/46c4b917_abfd_45a3_9b51_4e3054191797/films/bruce/mac-bruce-tpl-cn-2018_1280x720h.mp4")
        playerView.startVideoPlayback(with: url)
    }
    
    /// 设置支持的 AVPlayer 文件扩展名
    private func setupSupportedAVPlayerFileExtensions() {
        print("\n\n本框架基于 AVPlayer 封装，支持格式：\n\n【\(supportedAVPlayerFileExtensions())】\n")
    }
}

// MARK: - Supported AVPlayer File Extensions

extension ARTViewController_VideoPlayer {
    
    /// 获取支持的 AVPlayer 文件扩展名
    ///
    /// - Returns: 支持的 AVPlayer 文件扩展名
    private func supportedAVPlayerFileExtensions() -> String {
        return AVURLAsset.audiovisualTypes().compactMap {
            UTTypeCopyPreferredTagWithClass($0 as CFString, kUTTagClassFilenameExtension)?.takeRetainedValue() as String?
        }.joined(separator: ", ")
    }
}

// MARK: - ARTVideoPlayerViewDelegate

extension ARTViewController_VideoPlayer: ARTVideoPlayerViewDelegate {
    
    func playerViewWrapper(for playerView: ARTVideoPlayerView) -> ARTVideoPlayerWrapperView? { // 获取播放器基类
        return ARTVideoPlayerCustomWrapperView(self)
    }
}

// MARK: - ARTVideoPlayerWrapperViewDelegate

extension ARTViewController_VideoPlayer: ARTVideoPlayerWrapperViewDelegate {
    
    func wrapperViewOverlay(for wrapperView: ARTVideoPlayerWrapperView) -> UIView? { // 获取播放器图层（最底层：用于显示弹幕、广告等）
        return nil
    }
    
    func wrapperViewSystemControls(for wrapperView: ARTVideoPlayerWrapperView) -> UIView? { // 获取播放器系统控制层（中间层：系统控制）
        return nil
    }
    
    func wrapperViewControls(for wrapperView: ARTVideoPlayerWrapperView) -> UIView? { // 获取播放器控制层（最顶层：顶部栏、侧边栏等）
        return ARTVideoPlayerControlsView(self)
    }
    
    func wrapperViewLoading(for wrapperView: ARTVideoPlayerWrapperView) -> UIView? { // 获取播放器的加载动画视图，用于显示加载动画
        return nil
    }
}

// MARK: - ARTVideoPlayerControlsViewDelegate

extension ARTViewController_VideoPlayer: ARTVideoPlayerControlsViewDelegate {
    
}
