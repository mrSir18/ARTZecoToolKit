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
    var baseContainerView: UIView!
    
    ///
    private var backContainerView: UIView!
    
    /// 返回按钮是否隐藏
    var backButtonHidden: Bool = false {
        didSet {
            backContainerView.isHidden = backButtonHidden
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
        
        let navigationBarView = UIView()
        baseContainerView.addSubview(navigationBarView)
        navigationBarView.snp.makeConstraints { make in
            make.top.equalTo(art_statusBarHeight())
            make.left.bottom.right.equalToSuperview()
        }
        
        backContainerView = UIView()
        navigationBarView.addSubview(backContainerView)
        backContainerView.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(60.0)
        }
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "navigation_back_black")
        backContainerView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.left.equalTo(12.0)
            make.centerY.equalTo(navigationBarView)
            make.size.equalTo(CGSize(width: 20.0, height: 20.0))
        }
        
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(clickBackButtonTapped), for: .touchUpInside)
        backContainerView.addSubview(button)
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let titleLabel = UILabel()
        titleLabel.text             = self.title ?? "成长智库"
        titleLabel.textAlignment    = .center
        titleLabel.font             = .art_semibold(17.0)
        titleLabel.textColor        = .black
        navigationBarView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let separateLine = UIView()
        separateLine.backgroundColor = .gray
        navigationBarView.addSubview(separateLine)
        separateLine.snp.makeConstraints { make in
            make.left.right.equalTo(0.0)
            make.bottom.equalTo(navigationBarView.snp.bottom)
            make.height.equalTo(0.5)
        }
    }
    
    // MARK: - Button Event Method
    @objc private func clickBackButtonTapped(sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
