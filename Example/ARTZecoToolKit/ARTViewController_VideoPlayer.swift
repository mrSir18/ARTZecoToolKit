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
    
    /// 弹幕视图
    private var danmakuView: ARTDanmakuView!
    
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayerView()
//        setupSupportedAVPlayerFileExtensions()
    }
    
    // MARK: - Setup Methods

    private func setupPlayerView() { // 创建播放器视图
        let aspectRatio: CGFloat = 16.0 / 9.0
        let videoPlayerView = ARTVideoPlayerView(self)
        view.addSubview(videoPlayerView)
        videoPlayerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(view.bounds.width / aspectRatio)
        }
        
        // MARK: - Test Methods
        
        var config = ARTVideoPlayerConfig()
//        config.url = URL(string: "https://www.apple.com/105/media/cn/mac/family/2018/46c4b917_abfd_45a3_9b51_4e3054191797/films/bruce/mac-bruce-tpl-cn-2018_1280x720h.mp4")
        config.url = URL(fileURLWithPath: Bundle.main.path(forResource: "video", ofType: "MP4")!)
//        https://media.w3.org/2010/05/sintel/trailer.mp4
//        https://www.apple.com/105/media/cn/mac/family/2018/46c4b917_abfd_45a3_9b51_4e3054191797/films/bruce/mac-bruce-tpl-cn-2018_1280x720h.mp4
        videoPlayerView.startVideoPlayback(with: config)
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
    
    /*
     func customScreenOrientation(for playerView: ARTVideoPlayerView) -> ScreenOrientation { // 自定义播放模式
     
     }
     
     func customTopBar(for playerView: ARTVideoPlayerView, screenOrientation: ScreenOrientation) -> ARTVideoPlayerTopbar? { // 自定义顶部工具栏视图
     
     }
     
     func customBottomBar(for playerView: ARTVideoPlayerView, screenOrientation: ScreenOrientation) -> ARTVideoPlayerBottombar? { // 自定义底部工具
     
     }
     */
    
    
// MARK: - 弹幕视图 - 公共方法
    
    func playerViewDidCreateDanmakuCell(for playerView: ARTVideoPlayerView) -> ARTDanmakuCell { // 创建弹幕
        let cell = ARTCustomDanmakuCell()
        return cell
    }
    
    func playerViewDidTapDanmakuCell(for playerView: ARTVideoPlayerView, danmakuCell: ARTDanmakuCell) { // 点击弹幕
        guard let danmakuCell = danmakuCell as? ARTCustomDanmakuCell else { return }
        print("点击了弹幕：\(danmakuCell.danmakuLabel.text ?? "")")
    }
    
    func playerViewWillDisplayDanmakuCell(for playerView: ARTVideoPlayerView, danmakuCell: ARTDanmakuCell) { // 弹幕开始显示
//        print("弹幕开始显示")
    }
    
    func playerViewDidEndDisplayDanmakuCell(for playerView: ARTVideoPlayerView, danmakuCell: ARTDanmakuCell) { // 弹幕结束显示
//        print("弹幕结束显示")
    }
    
    func playerViewDidEndDisplayAllDanmaku(for playerView: ARTVideoPlayerView) {
        print("所有弹幕显示完毕")
    }
    
// MARK: - 顶部工具栏 - 公共方法
    
    func playerViewDidTapBack(for playerView: ARTVideoPlayerView) { // 点击返回按钮
        print("点击返回按钮")
    }
    
    func playerViewDidTapFavorite(for playerView: ARTVideoPlayerView, isFavorited: Bool) { // 点击收藏按钮
        print("点击收藏按钮")
    }
    
    func playerViewDidTapShare(for playerView: ARTVideoPlayerView) { // 点击分享按钮
        print("点击分享按钮")
    }
    
    
// MARK: - 底部工具栏 - 公共方法
    
    func playerViewDidBeginTouch(for playerView: ARTVideoPlayerView, slider: ARTVideoPlayerSlider) { // 暂停播放 (开始拖动滑块)
        print("暂停播放")
    }
    
    func playerViewDidChangeValue(for playerView: ARTVideoPlayerView, slider: ARTVideoPlayerSlider) { // 快进/快退 (拖动滑块)
        
    }
    
    func playerViewDidEndTouch(for playerView: ARTVideoPlayerView, slider: ARTVideoPlayerSlider) { // 恢复播放 (结束拖动滑块)
        print("恢复播放")
    }
    
    func playerViewDidTap(for playerView: ARTVideoPlayerView, slider: ARTVideoPlayerSlider) { // 指定播放时间 (点击滑块)
        print("指定播放时间")
    }
    
    func playerViewDidTapPause(for playerView: ARTVideoPlayerView, isPlaying: Bool) { // 暂停播放 (点击暂停按钮)
        print("播放状态 \(isPlaying ? "暂停" : "播放")")
    }
    
    func playerViewDidTapDanmakuToggle(for playerView: ARTVideoPlayerView) { // 弹幕开关 (点击弹幕开关按钮)
        print("弹幕开关")
    }
    
    func playerViewDidTapDanmakuSettings(for playerView: ARTVideoPlayerView) { // 弹幕设置 (点击弹幕设置按钮)
        print("弹幕设置")
    }
    
    func playerViewDidTapDanmakuSend(for playerView: ARTVideoPlayerView, text: String) { // 发送弹幕 (点击发送弹幕按钮)
        print("发送弹幕")
    }
    
    
// MARK: - 窗口模式 - 底部工具栏
    
    func playerViewDidTransitionToFullscreen(for playerView: ARTVideoPlayerView, orientation: ScreenOrientation) { // 点击全屏按钮
        print("点击全屏按钮")
    }
    
    
// MARK: - 横屏模式 - 底部工具栏
    
    func playerViewDidTapNext(for playerView: ARTVideoPlayerView) { // 点击下一个按钮
        print("点击下一个按钮")
    }
    
    func playerViewDidTapSpeed(for playerView: ARTVideoPlayerView) { // 点击倍速按钮
        print("点击倍速按钮")
    }
    
    func playerViewDidTapCollection(for playerView: ARTVideoPlayerView) { // 点击目录按钮
        print("点击目录按钮")
    }
    
    
// MARK: - 竖屏模式 - 底部工具栏
    
    func playerViewDidTapComment(for playerView: ARTVideoPlayerView) { // 点击评论按钮
        print("点击评论按钮")
    }
}
