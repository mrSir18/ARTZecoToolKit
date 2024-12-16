//
//  ARTAnimationTransitioning.swift
//  Pods
//
//  Created by mrSir18 on 2024/10/19.
//

import UIKit

/// 动画过渡类型
extension ARTAnimationTransitioning {
    public enum TransitionType {
        case presentation  // 呈现动画
        case dismissal     // 消失动画
    }
}

/// 动画过渡处理类
open class ARTAnimationTransitioning: NSObject {
    
    /// 当前动画类型，默认为呈现动画
    public var transitionType: TransitionType = .presentation
    
    /// 动画持续时间
    public var duration: TimeInterval = 0.35
    
    /// 视频播放器视图
    private weak var wrapperView: ARTVideoPlayerWrapperView!
    
    /// 基类堆栈视图
    private weak var parentStackView: UIStackView!
    
    /// 初始中心点
    private var initialCenterPoint: CGPoint = .zero
    
    /// 最终中心点
    private var finalCenterPoint: CGPoint = .zero
    
    /// 初始边界矩形
    private var initialBoundsRect: CGRect = .zero
    
    
    // MARK: - Initialization
    
    /// 初始化动画过渡处理类
    ///
    /// - Parameter wrapperView: 视频播放器视图
    public init(_ wrapperView: ARTVideoPlayerWrapperView) {
        self.wrapperView = wrapperView
        parentStackView = wrapperView.superview as? UIStackView
        initialBoundsRect = wrapperView.bounds
        initialCenterPoint = wrapperView.center
        finalCenterPoint = wrapperView.convert(initialCenterPoint, to: nil) // 转换为全局坐标
    }
}

// MARK: - UIViewControllerAnimatedTransitioning

extension ARTAnimationTransitioning: UIViewControllerAnimatedTransitioning {
    
    /// 获取动画持续时间
    ///
    /// - Parameter transitionContext: 过渡上下文
    /// - Returns: 动画持续时间
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration // 返回设定的动画持续时间
    }
    
    /// 执行动画过渡
    ///
    /// - Parameter transitionContext: 过渡上下文
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let wrapperView = wrapperView else { return }
        
        // 判断当前动画类型是否为呈现
        if transitionType == .presentation {
            guard let destinationView = transitionContext.view(forKey: .to),
                  let destinationController = transitionContext.viewController(forKey: .to) as? ARTFullScreenController else { return }
            
            // 获取起始中心点
            let startCenter = transitionContext.containerView.convert(initialCenterPoint, from: wrapperView)
            transitionContext.containerView.addSubview(destinationView) // 将目标视图添加到容器视图
            destinationController.contentStackView.addArrangedSubview(wrapperView) // 将视频播放器视图添加到目标控制器的堆栈视图
            destinationView.bounds = initialBoundsRect  // 设置目标视图的初始边界
            destinationView.center = startCenter  // 设置目标视图的初始中心
            if wrapperView.isLandscape { // 判断是否横屏
                destinationView.transform = .init(rotationAngle: .pi * -0.5) // 设置横屏展示旋转动画
            }
            
            // 执行动画
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: [.curveEaseInOut, .layoutSubviews], animations: {
                destinationView.transform = .identity
                destinationView.bounds = transitionContext.containerView.bounds
                destinationView.center = transitionContext.containerView.center
            }) { _ in
                transitionContext.completeTransition(true)
                UIViewController.attemptRotationToDeviceOrientation()
            }
            
        } else {
            // 当前动画类型为消失
            guard let parentStackView = parentStackView,
                  let presentingView = transitionContext.view(forKey: .from),
                  let dismissingView = transitionContext.view(forKey: .to) else { return }
            
            transitionContext.containerView.addSubview(dismissingView) // 将即将显示的视图添加到容器视图
            transitionContext.containerView.addSubview(presentingView) // 将正在消失的视图添加到容器视图
            dismissingView.frame = transitionContext.containerView.bounds // 设置即将显示视图的边界
            
            // 执行动画
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, options: [.curveEaseInOut, .layoutSubviews], animations: {
                presentingView.transform = .identity
                presentingView.center = self.finalCenterPoint
                presentingView.bounds = self.initialBoundsRect
            }) { _ in
                parentStackView.addArrangedSubview(wrapperView) // 将视频播放器视图添加回父堆栈视图
                presentingView.removeFromSuperview()
                transitionContext.completeTransition(true)
                UIViewController.attemptRotationToDeviceOrientation()
            }
        }
    }
}
