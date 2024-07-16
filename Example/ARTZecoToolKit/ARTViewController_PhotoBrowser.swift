//
//  ARTViewController_PhotoBrowser.swift
//  ARTZecoToolKit_Example
//
//  Created by mrSir18 on 2024/7/15.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import ARTZecoToolKit

class ARTViewController_PhotoBrowser: ARTBaseViewController {
    
    /// 按钮
    private lazy var photoBrowserButton: ARTAlignmentButton = {
        let button = ARTAlignmentButton(type: .custom)
        button.titleLabel?.font = .art_regular(16.0)
        button.backgroundColor  = .art_randomColor()
        button.setTitle("这是自定义PhotoBrowser", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(photoBrowserButtonAction), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(photoBrowserButton)
        photoBrowserButton.snp.makeConstraints { make in
            make.size.equalTo(ARTAdaptedSize(width: 200.0, height: 200.0))
            make.center.equalToSuperview()
        }
    }
    
    @objc private func photoBrowserButtonAction () {
        ARTPhotoBrowserStyleConfiguration.default().customBackButtonImageName("back_white_left").enableTopBottomFadeOutAnimator(true).enableSingleTapDismissGesture(true)
        ARTPhotoBrowserStyleConfiguration.resetConfiguration()
        let imageUrls: [Any] = [
            URL(string: "https://img2.baidu.com/it/u=1623302349,1771329113&fm=253&fmt=auto&app=120&f=JPEG?w=800&h=800")!,
            URL(string: "https://p3.itc.cn/q_70/images01/20231108/c665b01b1a9743d598e27e926ff83f15.png")!,
            URL(string: "https://img2.baidu.com/it/u=2053498362,2953193322&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=1062")!,
            "https://pic.rmb.bdstatic.com/bjh/events/d709f3e4e2721baba01a537f96289a6f4297.jpeg@h_1280",
            "1",
            "https://b0.bdstatic.com/ugc/B7pv_c36BMDAo9J4hD4Rwge89aa51c1283c7b47a86000a3dd017bd.jpg@h_1280"
        ]
//        ARTPhotoBrowserViewController.showPhotoBrowser(withPhotos: imageUrls, startIndex: 1) { index in
//            print("当前显示的照片索引为：\(index)")
//        }
        
        let photoBrowserViewController = ARTPhotoBrowserViewController(photos: imageUrls, startIndex: 2)
        photoBrowserViewController.delegate = self
        photoBrowserViewController.currentIndexCallback = { index in
            print("当前显示的照片索引为：\(index)")
        }
        photoBrowserViewController.showPhotoBrowser()
//        navigationController?.pushViewController(photoBrowserViewController, animated: true)
    }
}

// MARK: - ARTPhotoBrowserViewControllerDelegate

extension ARTViewController_PhotoBrowser: ARTPhotoBrowserViewControllerDelegate {

    func photoBrowserViewController(_ viewController: ARTPhotoBrowserViewController, didChangedIndex index: Int) { // 照片索引改变
        print("代理模式：当前显示的照片索引为：\(index)")
    }
    
    func customNavigationBar(for viewController: ARTPhotoBrowserViewController) -> ARTPhotoBrowserNavigationBar? { // 自定义导航栏
        let navigationBar = ARTControllerNavigationBar(self)
        viewController.view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(art_navigationFullHeight())
        }
        return navigationBar
    }
    
    func customBottomBar(for viewController: ARTPhotoBrowserViewController) -> ARTPhotoBrowserBottomBar? { // 自定义底部工具栏
        let bottomBar = ARTControllerBottomBar(self)
        viewController.view.addSubview(bottomBar)
        bottomBar.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(art_tabBarFullHeight())
        }
        return bottomBar
    }
    
    func dismissPhotoBrowser(for viewController: ARTPhotoBrowserViewController, animated: Bool, completion: (() -> Void)?) { // 退出照片浏览器
        completion?()
//        navigationController?.popToViewController(self, animated: true)
        navigationController?.dismiss(animated: true)
    }
}

// MARK: - ARTControllerNavigationBarDelegate

extension ARTViewController_PhotoBrowser: ARTControllerNavigationBarDelegate {
    
    func navigationBarDidClose(_ navigationBar: ARTControllerNavigationBar) {
        navigationController?.dismiss(animated: true)
    }
}

// MARK: - ARTControllerBottomBarDelegate

extension ARTViewController_PhotoBrowser: ARTControllerBottomBarDelegate {
    
    func bottomBarDidShare(_ bottomBar: ARTControllerBottomBar) {
        print("点击了分享按钮")
    }
}
