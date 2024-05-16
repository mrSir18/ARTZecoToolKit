//
//  ARTSliderBarStyleConfiguration+Chaining.swift
//  Alamofire
//
//  Created by mrSir18 on 2024/5/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

public extension ARTSliderBarStyleConfiguration {
    
    @discardableResult
    func titles(_ titles: [String]) -> ARTSliderBarStyleConfiguration {
        self.titles = titles
        return self
    }

    @discardableResult
    func backgroundColor(_ color: UIColor) -> ARTSliderBarStyleConfiguration {
        backgroundColor = color
        return self
    }

    @discardableResult
    func titleFont(_ font: UIFont) -> ARTSliderBarStyleConfiguration {
        titleFont = font
        return self
    }
    
    @discardableResult
    func titleSelectedFont(_ font: UIFont) -> ARTSliderBarStyleConfiguration {
        titleSelectedFont = font
        return self
    }
    
    @discardableResult
    func titleColor(_ color: UIColor) -> ARTSliderBarStyleConfiguration {
        titleColor = color
        return self
    }
    
    @discardableResult
    func titleSelectedColor(_ color: UIColor) -> ARTSliderBarStyleConfiguration {
        titleSelectedColor = color
        return self
    }
    
    @discardableResult
    func titleSpacing(_ spacing: CGFloat) -> ARTSliderBarStyleConfiguration {
        titleSpacing = spacing
        return self
    }
    
    @discardableResult
    func titleTopSpacing(_ spacing: CGFloat) -> ARTSliderBarStyleConfiguration {
        titleTopSpacing = spacing
        return self
    }
    
    @discardableResult
    func lineSize(_ size: CGSize) -> ARTSliderBarStyleConfiguration {
        lineSize = size
        return self
    }
    
    @discardableResult
    func lineBottomSpacing(_ spacing: CGFloat) -> ARTSliderBarStyleConfiguration {
        lineBottomSpacing = spacing
        return self
    }
    
    @discardableResult
    func lineCornerRadius(_ cornerRadius: CGFloat) -> ARTSliderBarStyleConfiguration {
        lineCornerRadius = cornerRadius
        return self
    }
    
    @discardableResult
    func lineClipsToBounds(_ clipsToBounds: Bool) -> ARTSliderBarStyleConfiguration {
        lineClipsToBounds = clipsToBounds
        return self
    }
    
    @discardableResult
    func lineColor(_ color: UIColor) -> ARTSliderBarStyleConfiguration {
        lineColor = color
        return self
    }
    
    @discardableResult
    func lineGradientLayer(_ gradientLayer: CAGradientLayer) -> ARTSliderBarStyleConfiguration {
        lineGradientLayer = gradientLayer
        return self
    }
    
    @discardableResult
    func lineHidden(_ hidden: Bool) -> ARTSliderBarStyleConfiguration {
        lineHidden = hidden
        return self
    }
}
