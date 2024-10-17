//
//  ARTBaseNavigationController.swift
//  ARTZecoToolKit_Example
//
//  Created by mrSir18 on 2024/5/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

class ARTBaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationBar.isHidden = true
        self.navigationBar.isTranslucent = true
    }
}

extension UINavigationController { // 隐藏状态栏
    open override var prefersStatusBarHidden: Bool {
        return topViewController?.prefersStatusBarHidden ?? true
    }
}
