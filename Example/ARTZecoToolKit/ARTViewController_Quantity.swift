//
//  ARTViewController_Quantity.swift
//  ARTZecoToolKit_Example
//
//  Created by mrSir18 on 2024/5/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import ARTZecoToolKit

class ARTViewController_Quantity: ARTBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // 默认配置
        ARTQuantityStyleConfiguration.default()
            .imageEdgeInsets(UIEdgeInsets(top: 4.0, left: 4.0, bottom: 4.0, right: 4.0))
        
        // 创建数量控制视图
        let quantityControlView = ARTQuantityControlView()
        quantityControlView.quantityChanged = { newQuantity in
            print("Quantity changed to \(newQuantity)")
            // 更新其他视图或模型
        }
        view.addSubview(quantityControlView)
        quantityControlView.snp.makeConstraints { make in
            make.size.equalTo(CGSizeMake(102.0, 28.0))
            make.center.equalToSuperview()
        }
        
        // 添加手势，点击空白处隐藏键盘
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

