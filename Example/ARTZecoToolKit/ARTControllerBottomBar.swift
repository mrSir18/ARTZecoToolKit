//
//  ARTControllerBottomBar.swift
//  ARTZecoToolKit_Example
//
//  Created by mrSir18 on 2024/7/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import ARTZecoToolKit

protocol ARTControllerBottomBarDelegate: ARTPhotoBrowserBottomBarDelegate {
    
    /// 拍照
    ///
    /// - Parameters:
    ///  - bottomBar: 自定义底部栏视图
    /// - Note: 根据个人需求实现,决定是否继承自ARTPhotoBrowserBottomBarDelegate协议
    func bottomBarDidTakePhoto(_ bottomBar: ARTControllerBottomBar)
    
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
        let takePhotoButton = UIButton(type: .custom)
        takePhotoButton.backgroundColor  = .art_randomColor()
        takePhotoButton.titleLabel?.font = .art_medium(ARTAdaptedValue(16.0))
        takePhotoButton.setTitle("拍照", for: .normal)
        takePhotoButton.setTitleColor(.white, for: .normal)
        takePhotoButton.addTarget(self, action: #selector(takePhotoButtonTapped), for: .touchUpInside)
        addSubview(takePhotoButton)
        takePhotoButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalTo(-art_safeAreaBottom())
            make.centerX.equalToSuperview()
            make.width.equalTo(ARTAdaptedValue(120.0))
        }
    }
    
    // MARK: - Private Button Actions
    
    @objc private func takePhotoButtonTapped(sender: UIButton) {
        bottomBarDelegate?.bottomBarDidTakePhoto(self)
    }
}
