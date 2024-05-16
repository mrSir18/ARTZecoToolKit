//
//  ARTCityStyleConfiguration+Chaining.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/5/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation

public extension ARTCityStyleConfiguration {
    
    @discardableResult
    func maxLevels(_ count: Int) -> ARTCityStyleConfiguration {
        maxLevels = count
        return self
    }
    
    func containerHeight(_ height: CGFloat) -> ARTCityStyleConfiguration {
        containerHeight = height
        return self
    }
    
    @discardableResult
    func themeColor(_ color: UIColor) -> ARTCityStyleConfiguration {
        themeColor = color
        return self
    }
    
    @discardableResult
    func cornerRadius(_ radius: CGFloat) -> ARTCityStyleConfiguration {
        cornerRadius = radius
        return self
    }
    
    @discardableResult
    func maskedCorners(_ corners: CACornerMask) -> ARTCityStyleConfiguration {
        maskedCorners = corners
        return self
    }
    
    @discardableResult
    func clipToBounds(_ clip: Bool) -> ARTCityStyleConfiguration {
        clipsToBounds = clip
        return self
    }
    
    @discardableResult
    func isGradientLine(_ isGradient: Bool) -> ARTCityStyleConfiguration {
        isGradientLine = isGradient
        return self
    }
    
    @discardableResult
    func gradientLayer(_ layer: CAGradientLayer) -> ARTCityStyleConfiguration {
        gradientLayer = layer
        return self
    }
    
    @discardableResult
    func tickImage(_ image: UIImage?) -> ARTCityStyleConfiguration {
        tickImage = image
        return self
    }
}
