//
//  ARTSlidePopupStyleConfiguration+Chaining.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/5/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

public extension ARTSlidePopupStyleConfiguration {

    @discardableResult
    func containerHeight(_ height: CGFloat) -> ARTSlidePopupStyleConfiguration {
        containerHeight = height
        return self
    }
    
    @discardableResult
    func containerBackgroundColor(_ color: UIColor) -> ARTSlidePopupStyleConfiguration {
        containerBackgroundColor = color
        return self
    }
    
    @discardableResult
    func cornerRadius(_ radius: CGFloat) -> ARTSlidePopupStyleConfiguration {
        cornerRadius = radius
        return self
    }
    
    @discardableResult
    func headerHeight(_ height: CGFloat) -> ARTSlidePopupStyleConfiguration {
        headerHeight = height
        return self
    }
}
