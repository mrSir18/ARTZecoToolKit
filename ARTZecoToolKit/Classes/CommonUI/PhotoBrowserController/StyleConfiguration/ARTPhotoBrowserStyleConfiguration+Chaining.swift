//
//  ARTPhotoBrowserStyleConfiguration+Chaining.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/7/15.
//

public extension ARTPhotoBrowserStyleConfiguration {
    @discardableResult
    func modalPresentationStyle(_ style: UIModalPresentationStyle) -> ARTPhotoBrowserStyleConfiguration {
        modalPresentationStyle = style
        return self
    }
    
    @discardableResult
    func modalTransitionStyle(_ style: UIModalTransitionStyle) -> ARTPhotoBrowserStyleConfiguration {
        modalTransitionStyle = style
        return self
    }
    
    @discardableResult
    func controllerFadeOutAnimatorDuration(_ duration: CGFloat) -> ARTPhotoBrowserStyleConfiguration {
        controllerFadeOutAnimatorDuration = duration
        return self
    }
    
    @discardableResult
    func enableTopBarUserInteraction(_ enable: Bool) -> ARTPhotoBrowserStyleConfiguration {
        enableTopBarUserInteraction = enable
        return self
    }
    
    @discardableResult
    func enableBottomBarUserInteraction(_ enable: Bool) -> ARTPhotoBrowserStyleConfiguration {
        enableBottomBarUserInteraction = enable
        return self
    }
    
    @discardableResult
    func enableTopBottomFadeOutAnimator(_ enable: Bool) -> ARTPhotoBrowserStyleConfiguration {
        enableTopBottomFadeOutAnimator = enable
        return self
    }
    
    @discardableResult
    func topBottomFadeOutAnimatorDuration(_ duration: CGFloat) -> ARTPhotoBrowserStyleConfiguration {
        topBottomFadeOutAnimatorDuration = duration
        return self
    }
    
    @discardableResult
    func topBottomTransitionAnimatorDuration(_ duration: CGFloat) -> ARTPhotoBrowserStyleConfiguration {
        topBottomTransitionAnimatorDuration = duration
        return self
    }
    
    @discardableResult
    func controllerBackgroundColor(_ color: UIColor) -> ARTPhotoBrowserStyleConfiguration {
        controllerBackgroundColor = color
        return self
    }
    
    @discardableResult
    func enableBackgroundBlurEffect(_ enable: Bool) -> ARTPhotoBrowserStyleConfiguration {
        enableBackgroundBlurEffect = enable
        return self
    }
    
    @discardableResult
    func enableSingleTapDismissGesture(_ enable: Bool) -> ARTPhotoBrowserStyleConfiguration {
        enableSingleTapDismissGesture = enable
        return self
    }
    
    @discardableResult
    func enableDoubleTapZoomGesture(_ enable: Bool) -> ARTPhotoBrowserStyleConfiguration {
        enableDoubleTapZoomGesture = enable
        return self
    }
    
    @discardableResult
    func enableSwipeToDismissGesture(_ enable: Bool) -> ARTPhotoBrowserStyleConfiguration {
        enableSwipeToDismissGesture = enable
        return self
    }
    
    @discardableResult
    func enableLongPressSaveImageGesture(_ enable: Bool) -> ARTPhotoBrowserStyleConfiguration {
        enableLongPressSaveImageGesture = enable
        return self
    }
    
    @discardableResult
    func maximumZoomScale(_ scale: CGFloat) -> ARTPhotoBrowserStyleConfiguration {
        maximumZoomScale = scale
        return self
    }
    
    @discardableResult
    func minimumZoomScale(_ scale: CGFloat) -> ARTPhotoBrowserStyleConfiguration {
        minimumZoomScale = scale
        return self
    }
    
    @discardableResult
    func customBackButtonImageName(_ imageName: String) -> ARTPhotoBrowserStyleConfiguration {
        customBackButtonImageName = imageName
        return self
    }
}
