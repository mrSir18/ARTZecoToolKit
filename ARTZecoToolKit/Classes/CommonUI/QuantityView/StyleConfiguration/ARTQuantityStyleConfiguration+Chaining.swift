//
//  ARTQuantityStyleConfiguration+Chaining.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/5/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation

public extension ARTQuantityStyleConfiguration {
    
    @discardableResult
    func minimumQuantity(_ quantity: Int) -> ARTQuantityStyleConfiguration {
        minimumQuantity = quantity
        return self
    }
    
    @discardableResult
    func maximumQuantity(_ quantity: Int) -> ARTQuantityStyleConfiguration {
        maximumQuantity = quantity
        return self
    }

    @discardableResult
    func containerBackgroundColor(_ color: UIColor) -> ARTQuantityStyleConfiguration {
        containerBackgroundColor = color
        return self
    }
    
    @discardableResult
    func cornerRadius(_ radius: CGFloat) -> ARTQuantityStyleConfiguration {
        cornerRadius = radius
        return self
    }
    
    @discardableResult
    func maskedCorners(_ corners: CACornerMask) -> ARTQuantityStyleConfiguration {
        maskedCorners = corners
        return self
    }
    
    @discardableResult
    func borderColor(_ color: UIColor) -> ARTQuantityStyleConfiguration {
        borderColor = color
        return self
    }
    
    @discardableResult
    func borderWidth(_ width: CGFloat) -> ARTQuantityStyleConfiguration {
        borderWidth = width
        return self
    }
    
    @discardableResult
    func clipToBounds(_ clip: Bool) -> ARTQuantityStyleConfiguration {
        clipsToBounds = clip
        return self
    }
    
    @discardableResult
    func buttonBackgroundColor(_ color: UIColor) -> ARTQuantityStyleConfiguration {
        buttonBackgroundColor = color
        return self
    }
    
    @discardableResult
    func decreaseImageName(_ name: String) ->ARTQuantityStyleConfiguration {
        decreaseImageName = name
        return self
    }
    
    @discardableResult
    func increaseImageName(_ name: String) -> ARTQuantityStyleConfiguration {
        increaseImageName = name
        return self
    }
    
    @discardableResult
    func imageEdgeInsets(_ insets: UIEdgeInsets) -> ARTQuantityStyleConfiguration {
        imageEdgeInsets = insets
        return self
    }
    
    @discardableResult
    func buttonWidth(_ width: CGFloat) -> ARTQuantityStyleConfiguration {
        buttonWidth = width
        return self
    }
    
    @discardableResult
    func textFieldBackgroundColor(_ color: UIColor) -> ARTQuantityStyleConfiguration {
        textFieldBackgroundColor = color
        return self
    }
    
    @discardableResult
    func textFieldFont(_ font: UIFont) -> ARTQuantityStyleConfiguration {
        textFieldFont = font
        return self
    }
    
    @discardableResult
    func textFieldTextColor(_ color: UIColor) -> ARTQuantityStyleConfiguration {
        textFieldTextColor = color
        return self
    }
    
    @discardableResult
    func hideSeparator(_ hide: Bool) -> ARTQuantityStyleConfiguration {
        hideSeparator = hide
        return self
    }
}
