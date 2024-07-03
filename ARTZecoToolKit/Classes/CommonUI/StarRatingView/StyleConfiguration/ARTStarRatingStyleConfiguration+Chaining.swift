//
//  ARTStarRatingStyleConfiguration+Chaining.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/7/4.
//

public extension ARTStarRatingStyleConfiguration {
    @discardableResult
    func backgroundColor(_ color: UIColor) -> ARTStarRatingStyleConfiguration {
        backgroundColor = color
        return self
    }
    
    @discardableResult
    func starAlignment(_ alignment: ARTAlignment) -> ARTStarRatingStyleConfiguration {
        starAlignment = alignment
        return self
    }
    
    @discardableResult
    func starSize(_ size: CGSize) -> ARTStarRatingStyleConfiguration {
        starSize = size
        return self
    }
    
    @discardableResult
    func starCount(_ count: Int) -> ARTStarRatingStyleConfiguration {
        starCount = count
        return self
    }
    
    @discardableResult
    func starSpacing(_ spacing: CGFloat) -> ARTStarRatingStyleConfiguration {
        starSpacing = spacing
        return self
    }
    
    @discardableResult
    func starNormalImageName(_ imageName: String) -> ARTStarRatingStyleConfiguration {
        starNormalImageName = imageName
        return self
    }
    
    @discardableResult
    func starSelectedImageName(_ imageName: String) -> ARTStarRatingStyleConfiguration {
        starSelectedImageName = imageName
        return self
    }
}
