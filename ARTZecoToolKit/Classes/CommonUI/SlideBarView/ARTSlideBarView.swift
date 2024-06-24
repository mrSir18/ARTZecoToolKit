//
//  ARTSliderBarView.swift
//  Alamofire
//
//  Created by mrSir18 on 2024/5/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

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
    
    /// 基准下标
    private let baseIndex: Int = 1000
    
    /// 滑动块
    private var lineView: UIView!
    
    /// 首次索引下标
    public var previousIndex: Int = 1000
    
    /// 标题容器视图
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator   = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    // MARK: - 更新索引下标
    public func updateSelectedIndex(_ index: Int) {
        moveLine(index + baseIndex) // 将当前下标加上基准值
        scrollToVisibleButton(at: index + baseIndex) // 将当前下标加上基准值
    }
    
    public convenience init(_ delegate: ARTSliderBarViewProtocol) {
        self.init()
        self.backgroundColor = ARTSliderBarStyleConfiguration.default().backgroundColor
        self.delegate        = delegate
        setupViews()
    }
    
    private func setupViews() {
        // 创建标题滚动视图
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let configuration = ARTSliderBarStyleConfiguration.default()
        DispatchQueue.main.async {
            let screenWidth = self.frame.size.width
            let insets      = configuration.titleEdgeInsets.left + configuration.titleEdgeInsets.right
            let titleCount  = CGFloat(configuration.titleAverageTypeCount)
            let spacing     = configuration.titleSpacing * CGFloat(titleCount - 1)
            let buttonWidth = (screenWidth - insets - spacing) / titleCount
            
            var lastButton: ARTAlignmentButton?
            for (index, title) in configuration.titles.enumerated() {
                let textSize = (title as NSString).size(withAttributes: [.font: configuration.titleSelectedFont])
                let isSelected = index + self.baseIndex == self.previousIndex
                
                let button = ARTAlignmentButton(type: .custom)
                button.tag              = self.baseIndex + index
                button.titleLabel?.font = isSelected ? configuration.titleSelectedFont : configuration.titleFont
                button.setTitle(title, for: .normal)
                button.setTitleColor(isSelected ? configuration.titleSelectedColor : configuration.titleColor, for: .normal)
                button.addTarget(self, action: #selector(self.clickSliderBarButtonTapped(sender:)), for: .touchUpInside)
                self.scrollView.addSubview(button)
                button.snp.makeConstraints { make in
                    make.top.equalToSuperview()
                    make.height.equalToSuperview()
                    if let lastButton = lastButton {
                        make.left.equalTo(lastButton.snp.right).offset(configuration.titleSpacing)
                    } else {
                        make.left.equalTo(configuration.titleEdgeInsets.left)
                    }
                    switch configuration.titleAverageType {
                    case .average:
                        make.width.equalTo(buttonWidth)
                    case .fixed:
                        make.width.equalTo(configuration.titleFixedWidth)
                    case .content:
                        make.width.equalTo(textSize.width)
                    }
                }
                lastButton = button
            }
            self.layoutIfNeeded()
            guard let lastButton = lastButton else { return }
            self.scrollView.contentSize = CGSize(width: lastButton.frame.maxX + configuration.titleEdgeInsets.right, height: self.scrollView.frame.height)

            // 更新父视图的宽度
            if self.scrollView.contentSize.width < self.frame.size.width {
                self.scrollView.snp.remakeConstraints { make in
                    make.left.top.bottom.equalToSuperview()
                    make.width.equalTo(self.scrollView.contentSize.width)
                }
                
                if self.hasWidthConstraint() {
                    self.snp.updateConstraints { make in
                        make.width.equalTo(self.scrollView.contentSize.width)
                    }
                } else {
                    self.snp.remakeConstraints { make in
                        make.left.equalTo(self.frame.origin.x)
                        make.top.equalTo(self.frame.origin.y)
                        make.height.equalTo(self.frame.size.height)
                        make.right.equalTo(lastButton.frame.maxX + configuration.titleEdgeInsets.right)
                    }
                }
            }
            
            // 滑动块
            self.lineView = UIView()
            self.lineView.isHidden = configuration.lineHidden
            self.lineView.backgroundColor = configuration.lineColor
            self.lineView.layer.cornerRadius = configuration.lineSize.height / 2.0
            if let gradientLayer = configuration.lineGradientLayer {
                self.lineView.layer.masksToBounds = configuration.lineClipsToBounds
                gradientLayer.frame = CGRect(x: 0.0, y: 0.0, width: configuration.lineSize.width, height: configuration.lineSize.height)
                self.lineView.layer.addSublayer(gradientLayer)
            }
            self.addSubview(self.lineView)
            if let firstButton = self.viewWithTag(self.previousIndex) as? UIButton {
                self.lineView.snp.makeConstraints { make in
                    make.size.equalTo(configuration.lineSize)
                    make.bottom.equalTo(-configuration.lineBottomSpacing)
                    make.centerX.equalTo(firstButton.snp.centerX)
                }
            }
        }
    }
    
    // MARK: - Private UIButton Methods
    
    @objc private func clickSliderBarButtonTapped(sender: UIButton) {
        moveLine(sender.tag)
        delegate?.slideBarView?(self, didSelectItemAt: sender.tag - baseIndex)
    }
    
    // MARK: - Private Method
    
    private func moveLine(_ index: Int) {
        let configuration = ARTSliderBarStyleConfiguration.default()
        if let previousButton = viewWithTag(previousIndex) as? UIButton {
            previousButton.titleLabel?.font = configuration.titleFont
            previousButton.setTitleColor(configuration.titleColor, for: .normal)
        }
        
        previousIndex = index
        if let nextButton = viewWithTag(previousIndex) as? UIButton {
            nextButton.titleLabel?.font = configuration.titleSelectedFont
            nextButton.setTitleColor(configuration.titleSelectedColor, for: .normal)
        }
        
        if let lastButton = viewWithTag(previousIndex) as? UIButton {
            UIView.animate(withDuration: 0.3) {
                self.lineView.snp.remakeConstraints { make in
                    make.size.equalTo(configuration.lineSize)
                    make.bottom.equalTo(-configuration.lineBottomSpacing)
                    make.centerX.equalTo(lastButton.snp.centerX)
                }
                self.layoutIfNeeded()
            }
        }
    }
    
    private func scrollToVisibleButton(at index: Int) {
        guard let button = viewWithTag(index) as? UIButton else { return }
        let buttonFrame = button.frame
        let visibleRect = scrollView.bounds
        let targetRect  = buttonFrame.intersection(visibleRect)
        var offsetX     = scrollView.contentOffset.x
        
        // 计算按钮中心点在可见区域中的位置
        let buttonCenterX  = targetRect.midX - scrollView.contentInset.left
        let visibleCenterX = visibleRect.midX
        let centerOffsetX  = buttonCenterX - visibleCenterX
        // 调整偏移量以将按钮居中
        offsetX += centerOffsetX
        // 限制偏移量在可滚动范围内
        offsetX = min(max(offsetX, 0.0), scrollView.contentSize.width - visibleRect.width)
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0.0), animated: true)
    }
}

extension ARTSliderBarView {
    
    func hasWidthConstraint() -> Bool {
        for constraint in self.constraints {
            if (constraint.firstAttribute == .width && constraint.firstItem as? UIView == self) ||
                (constraint.secondAttribute == .width && constraint.secondItem as? UIView == self) {
                return true
            }
        }
        return false
    }
}
