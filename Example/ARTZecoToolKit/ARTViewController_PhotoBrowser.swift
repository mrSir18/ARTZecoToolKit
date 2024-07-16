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
            make.size.equalTo(CGSize(width: 200.0, height: 200.0))
            make.center.equalToSuperview()
        }
    }
    
    @objc private func photoBrowserButtonAction () {
        ARTPhotoBrowserStyleConfiguration.default().customBackButtonImageName("back_white_left")
        
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
//        photoBrowserViewController.showPhotoBrowser()
        navigationController?.pushViewController(photoBrowserViewController, animated: true)
    }
}

// MARK: - ARTPhotoBrowserViewControllerDelegate

extension ARTViewController_PhotoBrowser: ARTPhotoBrowserViewControllerDelegate {

    func customNavigationBar(for viewController: ARTPhotoBrowserViewController) -> ARTPhotoBrowserNavigationBar? {
        let navigationBar = ARTNavigationBar()
        navigationBar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 150)
        navigationBar.backgroundColor = .art_randomColor()
        return navigationBar
    }
    
    func dismissPhotoBrowser(for viewController: ARTPhotoBrowserViewController, animated: Bool, completion: (() -> Void)?) {
        completion?()
        navigationController?.popToViewController(self, animated: true)
    }
    
    func photoBrowserViewController(_ viewController: ARTPhotoBrowserViewController, didChangedIndex index: Int) {
        print("代理模式：当前显示的照片索引为：\(index)")
    }
}




class ARTNavigationBar: ARTPhotoBrowserNavigationBar {

    
    // MARK: - Life Cycle
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupViews() {
        let backButton = UIButton(type: .custom)
        backButton.backgroundColor = .art_randomColor()
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        backButton.setTitle("关闭", for: .normal)
        backButton.setTitleColor(.white, for: .normal)
        backButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.size.equalTo(ARTAdaptedSize(width: 100, height: 60))
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    
    // MARK: - Private Button Actions
    
    @objc private func closeButtonTapped(sender: UIButton) {
        print("关闭按钮被点击")
    }
}
