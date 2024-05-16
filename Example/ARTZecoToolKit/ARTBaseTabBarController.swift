//
//  ARTBaseTabBarController.swift
//  ARTZecoToolKit_Example
//
//  Created by mrSir18 on 2024/5/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

class ARTBaseTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.isHidden = true
        
        let viewController = ARTViewController_Debug()
        self.viewControllers = [viewController]
        self.selectedIndex = 0
    }
}

