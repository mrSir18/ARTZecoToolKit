//
//  ARTViewController_ActionSheet.swift
//  ARTZecoToolKit_Example
//
//  Created by mrSir18 on 2024/7/2.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import ARTZecoToolKit

class ARTViewController_ActionSheet: ARTBaseViewController {
    
    /// 按钮
    private lazy var actionSheetButton: ARTAlignmentButton = {
        let button = ARTAlignmentButton(type: .custom)
        button.titleLabel?.font = .art_regular(16.0)
        button.backgroundColor  = .art_randomColor()
        button.setTitle("这是自定义ActionSheet", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(actionSheetButtonAction), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(actionSheetButton)
        actionSheetButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 200.0, height: 200.0))
            make.center.equalToSuperview()
        }
    }
    
    @objc private func actionSheetButtonAction () {
        
        ARTActionSheetStyleConfiguration.resetConfiguration()
        //设置actionSheet示例
        
        /// 创建actionSheet弹框
        let actionSheet = ARTActionSheet()
        actionSheet.didSelectItemCallback = { index in
            print("点击了第\(index)个按钮")
        }
        actionSheet.show()
    }
}
