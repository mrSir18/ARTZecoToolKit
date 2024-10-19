//
//  MRVideoFullscreenManager.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/10/19.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

/// 视频全屏管理器，用于处理视频播放的全屏切换与动画
open class MRVideoFullscreenManager: NSObject {
    
    /// 弱引用播放器视图，避免强引用循环
    private weak var videoWrapperView: MRVideoPlayerWrapperView!
    
    /// 全屏控制器
    private var fullScreenController: MRFullScreenController!
    
    /// 动画转场对象
    private var animationTransitioning: MRAnimationTransitioning!
    
    
    // MARK: - Initialization
    
    /// 初始化方法
    ///
    /// - Parameter videoWrapperView: 传入的视频播放器视图
    public init(videoWrapperView: MRVideoPlayerWrapperView) {
        self.videoWrapperView = videoWrapperView
    }
    
    /// 关闭全屏视频播放
    open func dismiss() {
        executeOnMainThread { [weak self] in
            guard let self = self, let controller = self.fullScreenController else { return }
            controller.dismiss(animated: true) {
                self.fullScreenController = nil
                UIViewController.attemptRotationToDeviceOrientation()
            }
        }
    }
    
    /// 展示全屏视频播放
    open func presentFullscreenWithRotation() {
        executeOnMainThread { [weak self] in
            guard let self = self, let videoWrapperView = self.videoWrapperView, videoWrapperView.superview != nil,
                  self.fullScreenController == nil,
                  let rootViewController = self.getRootViewController() else { return }
            
            // 初始化动画转场对象和全屏控制器
            self.animationTransitioning = MRAnimationTransitioning(videoWrapperView)
            self.fullScreenController = MRFullScreenController()
            self.fullScreenController.transitioningDelegate = self
            self.fullScreenController.modalPresentationStyle = .fullScreen
            rootViewController.present(self.fullScreenController!, animated: true) {
                UIViewController.attemptRotationToDeviceOrientation()
            }
        }
    }
    
    /// 在主线程上执行指定的操作
    /// - Parameter block: 要执行的操作
    private func executeOnMainThread(_ block: @escaping () -> Void) {
        DispatchQueue.main.async(execute: block)
    }
    
    /// 获取当前活动的根视图控制器
    /// - Returns: 当前活动的根视图控制器，若无则返回 nil
    private func getRootViewController() -> UIViewController? {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = scene.windows.first?.rootViewController else {
            return nil
        }
        return rootViewController
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension MRVideoFullscreenManager: UIViewControllerTransitioningDelegate {
    
    /// 返回呈现时的动画控制器
    /// - Parameters:
    ///   - presented: 被呈现的视图控制器
    ///   - presenting: 呈现的视图控制器
    ///   - source: 源视图控制器
    /// - Returns: 动画控制器
    open func animationController(forPresented _: UIViewController, presenting _: UIViewController, source _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animationTransitioning.transitionType = .presentation
        return animationTransitioning
    }
    
    /// 返回消失时的动画控制器
    /// - Parameter _: 被消失的视图控制器
    /// - Returns: 动画控制器
    open func animationController(forDismissed _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animationTransitioning.transitionType = .dismissal
        return animationTransitioning
    }
}
