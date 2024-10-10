//
//  ARTAlertViewStyleConfiguration+Chaining.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/7/1.
//

public extension ARTAlertViewStyleConfiguration {
    @discardableResult
    func containerWidth(_ width: CGFloat) -> ARTAlertViewStyleConfiguration {
        containerWidth = width
        return self
    }
    
    @discardableResult
    func containerBackgroundColor(_ color: UIColor) -> ARTAlertViewStyleConfiguration {
        containerBackgroundColor = color
        return self
    }
    
    @discardableResult
    func cornerRadius(_ radius: CGFloat) -> ARTAlertViewStyleConfiguration {
        cornerRadius = radius
        return self
    }
    
    @discardableResult
    func titleTextAlignment(_ alignment: NSTextAlignment) -> ARTAlertViewStyleConfiguration {
        titleTextAlignment = alignment
        return self
    }
    
    @discardableResult
    func titleTopSpacing(_ spacing: CGFloat) -> ARTAlertViewStyleConfiguration {
        titleTopSpacing = spacing
        return self
    }
    
    @discardableResult
    func titleFont(_ font: UIFont) -> ARTAlertViewStyleConfiguration {
        titleFont = font
        return self
    }
    
    @discardableResult
    func titleColor(_ color: UIColor) -> ARTAlertViewStyleConfiguration {
        titleColor = color
        return self
    }
    
    @discardableResult
    func descTextAlignment(_ alignment: NSTextAlignment) -> ARTAlertViewStyleConfiguration {
        descTextAlignment = alignment
        return self
    }
    
    @discardableResult
    func descTopSpacing(_ spacing: CGFloat) -> ARTAlertViewStyleConfiguration {
        descTopSpacing = spacing
        return self
    }
    
    @discardableResult
    func descFont(_ font: UIFont) -> ARTAlertViewStyleConfiguration {
        descFont = font
        return self
    }
    
    @discardableResult
    func descColor(_ color: UIColor) -> ARTAlertViewStyleConfiguration {
        descColor = color
        return self
    }
    
    @discardableResult
    func textHorizontalMargin(_ margin: CGFloat) -> ARTAlertViewStyleConfiguration {
        textHorizontalMargin = margin
        return self
    }
    
    @discardableResult
    func buttonTopSpacingToDescription(_ spacing: CGFloat) -> ARTAlertViewStyleConfiguration {
        buttonTopSpacingToDescription = spacing
        return self
    }
    
    @discardableResult
    func buttonTitles(_ titles: [String]) -> ARTAlertViewStyleConfiguration {
        buttonTitles = titles
        return self
    }
    
    @discardableResult
    func buttonTitleFonts(_ fonts: [UIFont]) -> ARTAlertViewStyleConfiguration {
        buttonTitleFonts = fonts
        return self
    }
    
    @discardableResult
    func buttonTitleColors(_ colors: [UIColor]) -> ARTAlertViewStyleConfiguration {
        buttonTitleColors = colors
        return self
    }
    
    @discardableResult
    func buttonBackgroundColors(_ colors: [UIColor]) -> ARTAlertViewStyleConfiguration {
        buttonBackgroundColors = colors
        return self
    }
    
    @discardableResult
    func buttonBorderColors(_ colors: [UIColor]) -> ARTAlertViewStyleConfiguration {
        buttonBorderColors = colors
        return self
    }
    
    @discardableResult
    func buttonBorderWidth(_ width: CGFloat) -> ARTAlertViewStyleConfiguration {
        buttonBorderWidth = width
        return self
    }
    
    @discardableResult
    func buttonRadius(_ radius: CGFloat) -> ARTAlertViewStyleConfiguration {
        buttonRadius = radius
        return self
    }
    
    @discardableResult
    func buttonBottomSpacing(_ spacing: CGFloat) -> ARTAlertViewStyleConfiguration {
        buttonBottomSpacing = spacing
        return self
    }
    
    @discardableResult
    func buttonSize(_ size: CGSize) -> ARTAlertViewStyleConfiguration {
        buttonSize = size
        return self
    }
    
    @discardableResult
    func buttonHorizontalMargin(_ spacing: CGFloat) -> ARTAlertViewStyleConfiguration {
        buttonHorizontalMargin = spacing
        return self
    }
}
