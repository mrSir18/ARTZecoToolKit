//
//  ARTViewController_AlertController.swift
//  ARTZecoToolKit_Example
//
//  Created by mrSir18 on 2024/5/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import ARTZecoToolKit

class ARTViewController_AlertController: ARTBaseViewController {
    
    /// Alert按钮
    private lazy var alertButton: ARTAlignmentButton = {
        let button = ARTAlignmentButton(type: .custom)
        button.titleLabel?.font = .art_regular(16.0)
        button.backgroundColor  = .art_randomColor()
        button.setTitle("这是Alert", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(alertButtonAction), for: .touchUpInside)
        return button
    }()
    
    /// ActionSheet按钮
    private lazy var actionSheetButton: ARTAlignmentButton = {
        let button = ARTAlignmentButton(type: .custom)
        button.titleLabel?.font = .art_regular(16.0)
        button.backgroundColor  = .art_randomColor()
        button.setTitle("这是ActionSheet", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(actionSheetButtonAction), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Alert按钮
        view.addSubview(alertButton)
        alertButton.snp.makeConstraints { make in
            make.size.equalTo(ARTAdaptedSize(width: 200.0, height: 200.0))
            make.right.equalTo(view.snp.centerX).offset(-10.0)
            make.centerY.equalToSuperview()
        }
        
        // ActionSheet按钮
        view.addSubview(actionSheetButton)
        actionSheetButton.snp.makeConstraints { make in
            make.size.equalTo(alertButton)
            make.left.equalTo(view.snp.centerX).offset(10.0)
            make.centerY.equalToSuperview()
        }
    }
    
    @objc private func alertButtonAction () {

        ARTAlertController.showAlertController(title: "提示", 
                                               message: "这是一个警告提示框",
                                               preferredStyle: .alert,
                                               buttonTitles: ["确定", "取消"],
                                               buttonStyles: [.default, .cancel], in: self) { mode in
            switch mode {
            case .first:
                print("First mode selected")
                // 处理第一种模式的逻辑
            case .second:
                print("Second mode selected")
                // 处理第二种模式的逻辑
            case .custom(let index):
                print("Custom mode selected with index \(index)")
                // 处理超出定义的情况，比如记录日志或其他操作
            default:
                break
            }
        }
    }
    
    @objc private func actionSheetButtonAction () {

        ARTAlertController.showAlertController(title: "提示",
                                               message: "这是一个警告提示框",
                                               preferredStyle: .actionSheet,
                                               buttonTitles: ["确定", "取消"],
                                               buttonStyles: [.default, .cancel], in: self) { mode in
            print("点击了\(mode)按钮")
        }
    }
}
