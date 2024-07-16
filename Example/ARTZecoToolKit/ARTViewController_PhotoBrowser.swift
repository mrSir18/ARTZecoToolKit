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
        
        /// 自定义UI样式配置
        ///
        /// - Note: 更多配置请查看ARTPhotoBrowserStyleConfiguration.swift文件
        ARTPhotoBrowserStyleConfiguration.default().customBackButtonImageName("back_white_left") // 自定义返回按钮
        //        ARTPhotoBrowserStyleConfiguration.resetConfiguration() // 重置默认配置
        
        
        /// 图片资源
        ///
        /// - Note: 支持URL、UIImage、String、PHAsset资源文件、资源图片名称类型
        let photos: [Any] = [
            URL(string: "https://img2.baidu.com/it/u=1623302349,1771329113&fm=253&fmt=auto&app=120&f=JPEG?w=800&h=800")!,
            URL(string: "https://p3.itc.cn/q_70/images01/20231108/c665b01b1a9743d598e27e926ff83f15.png")!,
            URL(string: "https://img2.baidu.com/it/u=2053498362,2953193322&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=1062")!,
            "https://pic.rmb.bdstatic.com/bjh/events/d709f3e4e2721baba01a537f96289a6f4297.jpeg@h_1280",
            "1",
            "https://b0.bdstatic.com/ugc/B7pv_c36BMDAo9J4hD4Rwge89aa51c1283c7b47a86000a3dd017bd.jpg@h_1280"
        ]
        
        /// 类方法初始化
        ///
        /// - Note: 默认配置 第三种方式
        /// - Parameters:
        ///  - photos: 图片资源
        ///  - startIndex: 起始索引
        ///  - delegate: 代理
        ///  - currentIndexCallback: 当前索引回调 与代理方法二选一 didChangedIndex即可
        ///
        ///  - Note: 第一种: 示例代码
        ///  - Code: ARTPhotoBrowserViewController.showPhotoBrowser(withPhotos: photos, startIndex: 2, delegate: self, currentIndexCallback: { index in print("当前显示的照片索引为：\(index)") })
        ///
        ///  - Note: 第二种: 示例代码
        ///  - Code: ARTPhotoBrowserViewController.showPhotoBrowser(withPhotos: photos, startIndex: 2, delegate: self)
        ///
        ///  - Note: 第三种: 示例代码
        ///  - Code: ARTPhotoBrowserViewController.showPhotoBrowser(withPhotos: photos, startIndex: 2)
        ARTPhotoBrowserViewController.showPhotoBrowser(withPhotos: photos, startIndex: 2)
        
        
        /// 实例方法初始化
        ///
        /// - Note: 默认配置 第三种方式
        /// - Parameters:
        ///  - photos: 图片资源
        ///  - startIndex: 起始索引
        ///  - delegate: 代理
        ///  - currentIndexCallback: 当前索引回调 与代理方法二选一 didChangedIndex即可
        ///
        ///  - Note: 第一种: 示例代码
        ///  - Code: ARTPhotoBrowserViewController(photos: photos, startIndex: 2, delegate: self, currentIndexCallback: { index in print("当前显示的照片索引为：\(index)") })
        ///
        ///  - Note: 第二种: 示例代码
        ///  - Code: ARTPhotoBrowserViewController(photos: photos, startIndex: 2, delegate: self)
        ///
        ///  - Note: 第三种: 示例代码
        ///  - Code: ARTPhotoBrowserViewController(photos: photos, startIndex: 2)
        ///
        /*
         
         1: 也可以通过实例方法初始化, 通过实例方法初始化时，不会自动显示图片浏览器，需要手动调用showPhotoBrowser()方法显示图片浏览器
         2: 转场效果，可以通过设置ARTPhotoBrowserStyleConfiguration.default().modalPresentationStyle 与 ARTPhotoBrowserStyleConfiguration.default().modalTransitionStyle 来设置
         3: push转场时需要通过代理方法dismissPhotoBrowser(for viewController: ARTPhotoBrowserViewController, animated: Bool, completion: (() -> Void)?) 来修改pop跳转
         4: 默认转场为present与dismiss
         
         let photoBrowserViewController = ARTPhotoBrowserViewController(photos: photos, startIndex: 2)
         photoBrowserViewController.delegate = self
         photoBrowserViewController.currentIndexCallback = { index in
         print("当前显示的照片索引为：\(index)")
         }
         photoBrowserViewController.showPhotoBrowser()
         */
    }
}

// MARK: - ARTPhotoBrowserViewControllerDelegate

/// 可根据实际需要来实现特定的代理方法
///
/// - Note: 代理方法是可选的，若不实现，则使用默认配置
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
        /// 退出照片浏览器完成后的回调
        completion?()
        
        /// 返回到指定控制器
        ///
        /// - Note: 跳转模式不同，Push、Pop、Present、Dismiss需要根据实际情况选择
        /// - Note: 默认是Dismiss模式
        navigationController?.dismiss(animated: true)
    }
}

// MARK: - ARTControllerNavigationBarDelegate

/// 自定义导航栏代理方法
///
/// - Note: 代理方法是可选的，若不实现，则使用默认配置
extension ARTViewController_PhotoBrowser: ARTControllerNavigationBarDelegate {
    
    func navigationBarDidClose(_ navigationBar: ARTControllerNavigationBar) {
        navigationController?.dismiss(animated: true)
    }
}

// MARK: - ARTControllerBottomBarDelegate

/// 自定义底部工具栏代理方法
///
/// - Note: 代理方法是可选的，若不实现，则使用默认配置
extension ARTViewController_PhotoBrowser: ARTControllerBottomBarDelegate {
    
    func bottomBarDidShare(_ bottomBar: ARTControllerBottomBar) {
        print("点击了分享按钮")
    }
}
