//
//  ARTFadeOutAnimator.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/7/15.
//

class ARTFadeOutAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    /// 返回动画持续时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.15  /// 动画持续时间设定为0.15秒
    }
    
    /// 执行过渡动画
    ///
    /// - Parameter transitionContext: 过渡上下
    /// - Note: 通过 transitionContext 获取 from
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) else {
            transitionContext.completeTransition(false) /// 若未找到 fromView，则标记过渡失败
            return
        }
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, animations: {
            fromView.alpha = 0.0 /// 渐隐动画：将 fromView 的透明度渐变为 0
        }, completion: { _ in
            transitionContext.completeTransition(true) /// 完成过渡动画并标记为成功
        })
    }
}

