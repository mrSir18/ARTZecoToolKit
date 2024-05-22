//
//  ARTViewController_SlideBar.swift
//  ARTZecoToolKit_Example
//
//  Created by mrSir18 on 2024/5/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import ARTZecoToolKit

class ARTViewController_SlideBar: ARTBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ARTSliderBarStyleConfiguration.default()
            .titles(["商品", "详情", "推荐"])

        // 创建滑动块菜单栏
        let slideBarView = ARTSliderBarView(self)
        view.addSubview(slideBarView)
        slideBarView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.equalTo(art_navigationBarHeight())
        }
    
        /* 更新索引下标
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            slideBarView.updateSelectedIndex(1)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
            slideBarView.updateSelectedIndex(2)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 9.0) {
            slideBarView.updateSelectedIndex(0)
        }
         */
    }
}

// MARK: - ARTSliderBarViewProtocol

extension ARTViewController_SlideBar: ARTSliderBarViewProtocol {
    
    func slideBarView(_ slideBarView: ARTSliderBarView, didSelectItemAt index: Int) {
        print("选择了第 \(index) 个")
    }
}
