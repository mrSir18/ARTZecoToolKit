//
//  ARTControllerBottomBar.swift
//  ARTZecoToolKit_Example
//
//  Created by mrSir18 on 2024/7/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import ARTZecoToolKit

protocol ARTControllerBottomBarDelegate: ARTPhotoBrowserBottomBarDelegate {
    
    /// 分享图片
    /// - Parameters:
    ///  - bottomBar: 自定义底部栏视图
    /// - Note: 根据个人需求实现,决定是否继承自ARTPhotoBrowserBottomBarDelegate协议
    func bottomBarDidShare(_ bottomBar: ARTControllerBottomBar)
}

class ARTControllerBottomBar: ARTPhotoBrowserBottomBar {
    
    // MARK: - Properties
    
    private var bottomBarDelegate: ARTControllerBottomBarDelegate? {
        return delegate as? ARTControllerBottomBarDelegate
    }
    
    
    // MARK: - Life Cycle
    
    // 该方法不实现则默认执行父类的方法
    init(_ delegate: ARTControllerBottomBarDelegate? = nil) {
        super.init(delegate)
        self.backgroundColor = .art_randomColor()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func setupViews() { // 重写父类方法，设置子视图
        let shareButton = UIButton(type: .custom)
        shareButton.backgroundColor  = .art_randomColor()
        shareButton.titleLabel?.font = .art_medium(ARTAdaptedValue(16.0))
        shareButton.setTitle("分享", for: .normal)
        shareButton.setTitleColor(.white, for: .normal)
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        addSubview(shareButton)
        shareButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalTo(-art_safeAreaBottom())
            make.centerX.equalToSuperview()
            make.width.equalTo(ARTAdaptedValue(120.0))
        }
    }
    
    // MARK: - Private Button Actions
    
    @objc private func shareButtonTapped(sender: UIButton) {
        bottomBarDelegate?.bottomBarDidShare(self)
    }
}
