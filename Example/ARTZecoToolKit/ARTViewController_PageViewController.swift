//
//  ARTViewController_PageViewController.swift
//  ARTZecoToolKit_Example
//
//  Created by mrSir18 on 2024/5/27.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import ARTZecoToolKit

class ARTViewController_PageViewController: ARTBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// 添加 ARTPageViewController 控制器
        let pageViewController = ARTPageViewController.addToParent(self)
        pageViewController.view.snp.makeConstraints { make in
            make.top.equalTo(baseContainerView.snp.bottom)
            make.left.bottom.right.equalToSuperview()
        }
        
        // 指定跳转到第N个视图控制器
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            pageViewController.goToPage(index: 1, animated: true)
        }
    }
}

extension ARTViewController_PageViewController: ARTPageViewControllerProtocol {
    
    func viewControllers(_ pageViewController: ARTPageViewController) -> [UIViewController] {
        let firstVC = UIViewController()
        firstVC.view.backgroundColor = .red
        let secondVC = UIViewController()
        secondVC.view.backgroundColor = .green
        let thirdVC = UIViewController()
        thirdVC.view.backgroundColor = .blue
        return [firstVC, secondVC, thirdVC]
    }
    
    func pageViewController(_ pageViewController: ARTPageViewController, didUpdatePageIndex index: Int) {
        print("当前视图控制器的索引: \(index)")
    }
}
