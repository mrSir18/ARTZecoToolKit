//
//  ARTViewController_AlertView.swift
//  ARTZecoToolKit_Example
//
//  Created by mrSir18 on 2024/7/1.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import ARTZecoToolKit

class ARTViewController_AlertView: ARTBaseViewController {
    
    /// 按钮
    private lazy var alertViewButton: ARTAlignmentButton = {
        let button = ARTAlignmentButton(type: .custom)
        button.titleLabel?.font = .art_regular(16.0)
        button.backgroundColor  = .art_randomColor()
        button.setTitle("这是自定义AlertView", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(alertViewButtonAction), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(alertViewButton)
        alertViewButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 200.0, height: 200.0))
            make.center.equalToSuperview()
        }
    }
    
    @objc private func alertViewButtonAction () {
        
        /*
         设置AlertView示例
         
         ARTAlertViewStyleConfiguration.default()
         .descTopSpacing(0)
         .containerWidth(300)
         .buttonBottomSpacing(30)
         .buttonHorizontalMargin(30)
         */
        
        /// 创建AlertView弹框
        let alertView = ARTAlertView()
        alertView.title("提示")
        alertView.desc("这是一个自定义的AlertView，你可以自己设置AlertView的样式")
        alertView.buttonTappedCallback = { buttonIndex in
            switch buttonIndex {
            case .first:
                print("First mode selected")
                // 处理第一种模式的逻辑
            case .second:
                print("Second mode selected")
                // 处理第二种模式的逻辑
            default:
                break
            }
        }
        alertView.show()
    }
}

