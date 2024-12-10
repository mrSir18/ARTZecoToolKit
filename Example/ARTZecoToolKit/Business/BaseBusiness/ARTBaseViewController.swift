//
//  ARTBaseViewController.swift
//  ARTZecoToolKit_Example
//
//  Created by mrSir18 on 2024/5/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import ARTZecoToolKit

class ARTBaseViewController: UIViewController {
    
    ///导航容器视图
    public var baseContainerView: UIView!
    
    /// 返回按钮
    private var backButton: ARTAlignmentButton!
    
    /// 返回按钮是否隐藏
    public var backButtonHidden: Bool = false {
        didSet {
            backButton.isHidden = backButtonHidden
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        baseContainerView = UIView()
        baseContainerView.backgroundColor = .white
        view.addSubview(baseContainerView)
        baseContainerView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(art_navigationFullHeight())
        }
        
        // 容器视图
        let containerView = UIView()
        baseContainerView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalTo(art_statusBarHeight())
            make.left.bottom.right.equalToSuperview()
        }
        
        // 创建返回按钮
        backButton = ARTAlignmentButton(type: .custom)
        backButton.imageAlignment       = .left
        backButton.titleAlignment       = .left
        backButton.contentInset         = 12.0
        backButton.imageSize            = CGSize(width: 20.0, height: 20.0)
        backButton.setImage(UIImage(named: "navigation_back_black"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        containerView.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(70.0)
        }
        
        // 创建标题标签
        let titleLabel = UILabel()
        titleLabel.text             = "成长智库"
        titleLabel.textAlignment    = .center
        titleLabel.font             = .art_semibold(17.0)
        titleLabel.textColor        = .black
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalTo(0.0)
            make.centerX.equalToSuperview()
            make.right.equalTo(-art_navigationBarHeight())
        }
        
        // 创建分割线
        let separateLine = UIView()
        separateLine.backgroundColor = .gray
        containerView.addSubview(separateLine)
        separateLine.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(containerView.snp.bottom)
            make.height.equalTo(0.5)
        }
    }
    
    // MARK: - Button Event Method
    @objc private func backButtonTapped(sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}


extension ARTBaseViewController {
    
    /// 是否支持自动旋转
    override var shouldAutorotate: Bool {
        return false
    }
    
    /// 支持哪些屏幕方向
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    /// 默认的屏幕方向
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    /// 状态栏样式
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    /// 是否隐藏状态栏
    override var prefersStatusBarHidden: Bool {
        return false
    }
}
