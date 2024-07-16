//
//  ARTControllerNavigationBar.swift
//  ARTZecoToolKit_Example
//
//  Created by mrSir18 on 2024/7/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import ARTZecoToolKit

protocol ARTControllerNavigationBarDelegate: ARTPhotoBrowserNavigationBarDelegate {
    
    /// 关闭图片浏览器
    ///
    /// - Parameters:
    /// -  navigationBar: 自定义导航栏视图
    /// - Note: 根据个人需求实现,决定是否继承自ARTPhotoBrowserNavigationBarDelegate协议
    func navigationBarDidClose(_ navigationBar: ARTControllerNavigationBar)
}

class ARTControllerNavigationBar: ARTPhotoBrowserNavigationBar {
    
    // MARK: - Properties
    
    private var navigationBarDelegate: ARTControllerNavigationBarDelegate? {
        return delegate as? ARTControllerNavigationBarDelegate
    }
    
    
    // MARK: - Life Cycle
    
    // 该方法不实现则默认执行父类的方法
    init(_ delegate: ARTControllerNavigationBarDelegate? = nil) {
        super.init(delegate)
        self.backgroundColor = .art_randomColor()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func setupViews() { // 重写父类方法，设置子视图
        let backButton = UIButton(type: .custom)
        backButton.backgroundColor  = .art_randomColor()
        backButton.titleLabel?.font = .art_medium(ARTAdaptedValue(16.0))
        backButton.setTitle("关闭", for: .normal)
        backButton.setTitleColor(.white, for: .normal)
        backButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(art_statusBarHeight())
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(ARTAdaptedValue(120.0))
        }
    }
    
    // MARK: - Private Button Actions
    
    @objc private func closeButtonTapped(sender: UIButton) {
        navigationBarDelegate?.navigationBarDidClose(self)
    }
}
