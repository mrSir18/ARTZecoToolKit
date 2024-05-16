//
//  ARTSlidePopupHeaderView.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/5/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import SnapKit

public protocol ARTSlidePopupHeaderViewProtocol: AnyObject {

    /// 点击收起按钮
    ///
    /// - Parameters:
    /// - commentListHeader: 头部视图
    /// - Returns: void
    func didTapPackUpButton(_ headerView: ARTSlidePopupHeaderView)
    
    /// 获取标题名称
    ///
    /// - Parameters:
    /// - headerView: 头部视图
    /// - Returns: 标题名称
    func titleName(with headerView: ARTSlidePopupHeaderView) -> String
}

open class ARTSlidePopupHeaderView: UIView {
    
    /// 代理对象
    weak var delegate: ARTSlidePopupHeaderViewProtocol?
    
    convenience init(_ delegate: ARTSlidePopupHeaderViewProtocol) {
        self.init()
        self.backgroundColor = .clear
        self.delegate = delegate
        setupViews()
    }
    
    private func setupViews() {
        
        // 创建标题栏标签
        let titleLabel = UILabel()
        titleLabel.text             = delegate?.titleName(with: self)
        titleLabel.textColor        = .art_color(withHEXValue: 0x000000)
        titleLabel.textAlignment    = .left
        titleLabel.font             = .art_medium(16.0)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(13.0)
            make.centerY.equalToSuperview()
            make.right.equalTo(-13.0)
        }
        
        // 创建箭头图标
        let fileName = art_resourcePath(file: "slider_header_arrow_down.png", object: self)
        let arrowImageView = UIImageView()
        arrowImageView.image = UIImage(contentsOfFile: fileName)
        addSubview(arrowImageView)
        arrowImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 30.0, height: 30.0))
            make.right.equalTo(-13.0)
            make.centerY.equalToSuperview()
        }
        
        // 创建收起按钮
        let packUpButton = UIButton(type: .custom)
        packUpButton.addTarget(self, action: #selector(clickPackUpButtonTapped(sender:)), for: .touchUpInside)
        addSubview(packUpButton)
        packUpButton.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(80.0)
        }
        
        // 创建分割线视图
        let separateLine = UIView()
        separateLine.backgroundColor = .art_color(withHEXValue: 0xF3F3F3)
        addSubview(separateLine)
        separateLine.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(1.0)
        }
    }
    
    // MARK: - Button Event Method
    @objc private func clickPackUpButtonTapped(sender: UIButton) {
        delegate?.didTapPackUpButton(self)
    }
}
