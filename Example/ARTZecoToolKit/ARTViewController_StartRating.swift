//
//  ARTViewController_StartRating.swift
//  ARTZecoToolKit_Example
//
//  Created by mrSir18 on 2024/7/3.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import ARTZecoToolKit

class ARTViewController_StartRating: ARTBaseViewController {

    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
            示例 默认星星左对齐
        ARTStarRatingStyleConfiguration.default()
            .backgroundColor(.clear)
            .starAlignment(.left)
            .starSize(ARTAdaptedSize(width: 24.0, height: 24.0))
            .starSpacing(ARTAdaptedValue(12.0))
            .starCount(5)
            .starNormalImageName("order_review_star")
            .starSelectedImageName("order_review_star_fill")
         */
        
        // 创建星级评分视图
        let starRatingView = ARTStarRatingView()
        starRatingView.backgroundColor = .art_randomColor()
        starRatingView.ratingCallback = { rating in
            print("User rated \(rating) stars.") // 输出用户评分
        }
        view.addSubview(starRatingView)
        starRatingView.snp.makeConstraints { make in
            make.size.equalTo(ARTAdaptedSize(width: 300.0, height: 100.0))
            make.centerX.centerY.equalToSuperview()
        }
    }
}
