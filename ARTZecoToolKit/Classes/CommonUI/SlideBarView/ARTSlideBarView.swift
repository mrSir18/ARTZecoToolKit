//
//  ARTSliderBarView.swift
//  Alamofire
//
//  Created by mrSir18 on 2024/5/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import SnapKit

@objc public protocol ARTSliderBarViewProtocol: AnyObject {
    
    /// 滑动块菜单栏
    ///
    /// - Parameters:
    ///   - slideBarView: 菜单栏视图。
    ///   - index: 内容的下标
    @objc optional func slideBarView(_ slideBarView: ARTSliderBarView, didSelectItemAt index: Int)
}

public class ARTSliderBarView: UIView {
    
    /// 遵循 ARTSliderBarViewProtocol 协议的弱引用委托对象.
    weak var delegate: ARTSliderBarViewProtocol?
    
    /// 滑动块
    private var lineView: UIView!
    
    /// 首次索引下标
    public var previousIndex: Int = 1000
    
    // MARK: - 更新索引下标
    public func updateSelectedIndex(_ index: Int) {
        moveLine(index)
    }
    
    public convenience init(_ delegate: ARTSliderBarViewProtocol) {
        self.init()
        self.backgroundColor = ARTSliderBarStyleConfiguration.default().backgroundColor
        self.delegate        = delegate
        setupViews()
    }
    
    private func setupViews() {
        let configuration = ARTSliderBarStyleConfiguration.default()
        var lastButton: UIButton?
        for (index, title) in configuration.titles.enumerated() {
            let textSize = (title as NSString).size(withAttributes: [.font: configuration.titleFont])
            let isSelected = index + 1000 == previousIndex
            
            let label = UILabel()
            label.tag           = 1000+index
            label.text          = title
            label.textAlignment = .left
            label.font          = isSelected ? configuration.titleSelectedFont : configuration.titleFont
            label.textColor     = isSelected ? configuration.titleSelectedColor : configuration.titleColor
            addSubview(label)
            label.snp.makeConstraints { make in
                if configuration.titleTopSpacing > 0 {
                    make.top.equalTo(configuration.titleTopSpacing)
                } else {
                    make.centerY.equalToSuperview()
                }
                if let lastButton = lastButton {
                    make.left.equalTo(lastButton.snp.right).offset(configuration.titleSpacing)
                } else {
                    make.left.equalToSuperview()
                }
                make.height.equalTo(textSize.height)
            }
            
            let button = UIButton(type: .system)
            button.tag = index
            button.addTarget(self, action: #selector(clickSliderBarButtonTapped(sender:)), for: .touchUpInside)
            addSubview(button)
            button.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                if let lastButton = lastButton {
                    make.left.equalTo(lastButton.snp.right).offset(configuration.titleSpacing)
                } else {
                    make.left.equalToSuperview()
                }
                make.right.equalTo(label)
            }
            lastButton = button
        }
        guard let lastButton = lastButton else { return }
        self.snp.updateConstraints { make in
            make.right.equalTo(lastButton.snp.right)
        }
        
        // 滑动块
        lineView = UIView()
        lineView.isHidden = configuration.lineHidden
        lineView.backgroundColor = configuration.lineColor
        lineView.layer.cornerRadius = configuration.lineSize.height / 2.0
        if let gradientLayer = configuration.lineGradientLayer {
            lineView.layer.masksToBounds = configuration.lineClipsToBounds
            gradientLayer.frame = CGRect(x: 0.0, y: 0.0, width: configuration.lineSize.width, height: configuration.lineSize.height)
            lineView.layer.addSublayer(gradientLayer)
        }
        addSubview(lineView)
        if let firstLabel = viewWithTag(previousIndex) as? UILabel {
            lineView.snp.makeConstraints { make in
                make.size.equalTo(configuration.lineSize)
                make.bottom.equalTo(-configuration.lineBottomSpacing)
                make.centerX.equalTo(firstLabel.snp.centerX)
            }
        }
    }
    
    // MARK: - Private Click UIButton Method
    @objc private func clickSliderBarButtonTapped(sender: UIButton) {
        moveLine(sender.tag)
        delegate?.slideBarView?(self, didSelectItemAt: sender.tag)
    }
    
    // MARK: - Private Method
    private func moveLine(_ index: Int) {
        let configuration = ARTSliderBarStyleConfiguration.default()
        if let previousLabel = viewWithTag(previousIndex) as? UILabel {
            previousLabel.font = configuration.titleFont
            previousLabel.textColor = configuration.titleColor
        }
        
        previousIndex = 1000+index
        if let nextLabel = viewWithTag(previousIndex) as? UILabel {
            nextLabel.font = configuration.titleSelectedFont
            nextLabel.textColor = configuration.titleSelectedColor
        }
        
        if let lastLabel = viewWithTag(previousIndex) as? UILabel {
            UIView.animate(withDuration: 0.3) {
                self.lineView.snp.remakeConstraints { make in
                    make.size.equalTo(configuration.lineSize)
                    make.bottom.equalTo(-configuration.lineBottomSpacing)
                    make.centerX.equalTo(lastLabel.snp.centerX)
                }
                self.layoutIfNeeded()
            }
        }
    }
}
