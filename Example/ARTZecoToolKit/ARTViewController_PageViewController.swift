//
//  ARTViewController_PageViewController.swift
//  ARTZecoToolKit_Example
//
//  Created by mrSir18 on 2024/5/27.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import ARTZecoToolKit

class ARTViewController_PageViewController: ARTBaseViewController {
    
    /// 菜单栏视图
    var slideBarView: ARTSliderBarView!
    
    /// 分页控制器
    var pageViewController: ARTPageViewController!
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// 创建菜单栏视图
        ARTSliderBarStyleConfiguration.default()
            .titles(["全部", "待付款", "待收货", "已完成", "已取消", "下单中", "购买中", "消费中"])
            .titleFont(.art_regular(15.0)!)
            .titleColor(.art_color(withHEXValue: 0x4f5158))
            .titleSelectedFont(.art_medium(20.0)!)
            .titleSelectedColor(.art_color(withHEXValue: 0x161822))
            .titleSpacing(0.0)
            .titleEdgeInsets(.zero)
            .titleAverageTypeCount(5)
            .titleFixedWidth(0.0)
            .titleAverageType(.average)
        
        slideBarView = ARTSliderBarView(self)
        view.addSubview(slideBarView)
        slideBarView.snp.makeConstraints { make in
            make.top.equalTo(art_navigationFullHeight())
            make.left.right.equalToSuperview()
            make.height.equalTo(art_navigationBarHeight())
        }
        
        /// 添加 ARTPageViewController 控制器
        pageViewController = ARTPageViewController.addToParent(self)
        pageViewController.view.snp.makeConstraints { make in
            make.top.equalTo(slideBarView.snp.bottom)
            make.left.bottom.right.equalToSuperview()
        }
        
        // 指定跳转到第N个视图控制器
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            pageViewController.goToPage(index: 1, animated: true)
//        }
    }
}


// MARK: - ARTSliderBarViewProtocol

extension ARTViewController_PageViewController: ARTSliderBarViewProtocol {
    
    func slideBarView(_ slideBarView: ARTSliderBarView, didSelectItemAt index: Int) {
        pageViewController.goToPage(index: index, animated: true)
    }
}

extension ARTViewController_PageViewController: ARTPageViewControllerProtocol {
    
    func viewControllers(_ pageViewController: ARTPageViewController) -> [UIViewController] {
        var viewControllers = [UIViewController]()
        for _ in 0..<ARTSliderBarStyleConfiguration.default().titles.count {
            let vc = UIViewController()
            vc.view.backgroundColor = .art_randomColor()
            viewControllers.append(vc)
        }
        return viewControllers
    }
    
    func pageViewController(_ pageViewController: ARTPageViewController, didUpdatePageIndex index: Int) {
        slideBarView.updateSelectedIndex(index)
        print("当前视图控制器的索引: \(index)")
    }
}
