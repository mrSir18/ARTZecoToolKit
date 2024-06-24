//
//  ARTCitySelectorHotHeader.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/5/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

@objc protocol ARTCitySelectorHeaderProtocol: AnyObject {
    
    /// 视图的委托方法，点击关闭按钮时，收起城市选择器.
    ///
    /// - Parameters:
    ///   - headerView:  视图管理对象.
    @objc optional func didTapCloseCitySelector(_ headerView: ARTCitySelectorHeader)
    
    /// 视图的委托方法，点击城市标题.
    ///
    /// - Parameters:
    ///   - headerView:  视图管理对象.
    ///   - headerView:  视图管理对象.
    @objc optional func citySelectorElementKindHeader(_ headerView: ARTCitySelectorHeader, didSelectItemAt index: Int)
}

class ARTCitySelectorHeader: UIView {
    
    /// 遵循 ARTCitySelectorHeaderProtocol 协议的弱引用委托对象.
    weak var delegate: ARTCitySelectorHeaderProtocol?
    
    /// 标题滚动视图.
    private var titleScrollView: UIScrollView!
    
    /// 滑动块视图.
    private var sliderControlLine: UIView!
    
    /// 分割线.
    private var separatorLinee: UIView!
    
    /// 城市名称列表.
    private var cityNames: [String] = []

    convenience init(_ delegate: ARTCitySelectorHeaderProtocol) {
        self.init()
        self.backgroundColor = .white
        self.delegate        = delegate
        setupViews()
    }
    
    private func setupViews() {
        
        // 创建头部容器视图
        let headerContainerView = UIView()
        addSubview(headerContainerView)
        headerContainerView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(60.0)
        }
        
        let titleLabel = UILabel()
        titleLabel.text             = "所在地区"
        titleLabel.textAlignment    = .left
        titleLabel.font             = .art_medium(18.0)
        titleLabel.textColor        = .art_color(withHEXValue: 0x000000)
        headerContainerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(18.0)
            make.centerY.equalToSuperview()
        }

        let file = art_resourcePath(file: "city_selector_close.png", object: self)
        let closeButton = ARTAlignmentButton()
        closeButton.imageAlignment       = .right
        closeButton.titleAlignment       = .right
        closeButton.contentInset         = 18.0
        closeButton.imageSize            = CGSize(width: 28.0, height: 28.0)
        closeButton.setImage(UIImage(contentsOfFile: file), for: .normal)
        closeButton.addTarget(self, action: #selector(clickCloseButtonTapped(sender:)), for: .touchUpInside)
        headerContainerView.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(80.0)
        }
        
//        // 创建定位容器视图
//        let locationContainerView = UIView()
//        locationContainerView.backgroundColor     = .art_color(withHEXValue: 0xf6f6f6)
//        locationContainerView.layer.cornerRadius  = 4.0
//        locationContainerView.layer.masksToBounds = true
//        addSubview(locationContainerView)
//        locationContainerView.snp.makeConstraints { make in
//            make.left.equalTo(18.0)
//            make.centerY.equalToSuperview()
//            make.right.equalTo(-18.0)
//            make.height.equalTo(44.0)
//        }
//        
//        let locationTitleLabel = UILabel()
//        locationTitleLabel.text            = "当前定位"
//        locationTitleLabel.textColor       = .art_color(withHEXValue: 0x767676)
//        locationTitleLabel.font            = .art_regular(11.0)
//        locationTitleLabel.textAlignment   = .left
//        locationContainerView.addSubview(locationTitleLabel)
//        locationTitleLabel.snp.makeConstraints { make in
//            make.left.equalTo(10.0)
//            make.centerY.equalTo(locationContainerView)
//        }
//
//        let locationButton = ARTAlignmentButton()
//        locationButton.titleLabel?.font     = .art_regular(14.0)
//        locationButton.backgroundColor      = ARTCityStyleConfiguration.default().themeColor
//        locationButton.layer.cornerRadius   = 4.0
//        locationButton.layer.masksToBounds  = true
//        locationButton.setTitle("使用", for: .normal)
//        locationButton.setTitleColor(.white, for: .normal)
//        locationButton.addTarget(self, action: #selector(clickLocationButtonTapped(sender:)), for: .touchUpInside)
//        locationContainerView.addSubview(locationButton)
//        locationButton.snp.makeConstraints { make in
//            make.right.equalTo(-10.0)
//            make.centerY.equalTo(locationContainerView)
//            make.size.equalTo(CGSize(width: 65.0, height: 26.0))
//        }
//  
//        let locationContentLabel = UILabel()
//        locationContentLabel.text            = "北京市 北京市 东城区 东华门街道"
//        locationContentLabel.textColor       = .art_color(withHEXValue: 0x403f45)
//        locationContentLabel.font            = .art_regular(13.0)
//        locationContentLabel.textAlignment   = .left
//        locationContainerView.addSubview(locationContentLabel)
//        locationContentLabel.snp.makeConstraints { make in
//            make.left.equalTo(locationTitleLabel.snp.right).offset(6.0)
//            make.centerY.equalTo(locationContainerView)
//            make.right.lessThanOrEqualTo(locationButton.snp.left).offset(-10.0)
//            make.width.greaterThanOrEqualTo(locationTitleLabel.snp.width) // 确保内容不会超过标题的宽度
//        }
        
        // 创建选择标签容器视图
        titleScrollView = UIScrollView()
        titleScrollView.isPagingEnabled  = true
        titleScrollView.showsHorizontalScrollIndicator   = false
        titleScrollView.showsVerticalScrollIndicator     = false
        titleScrollView.contentInset    = UIEdgeInsets(top: 0.0, left: 18.0, bottom: 0.0, right: 18.0)
        addSubview(titleScrollView)
        titleScrollView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(headerContainerView.snp.bottom)
        }
        
        let selectorCityLabel = UILabel()
        selectorCityLabel.tag           = 1000
        selectorCityLabel.text          = "请选择"
        selectorCityLabel.textAlignment = .left
        selectorCityLabel.font          = .art_regular(14.0)
        selectorCityLabel.textColor     = ARTCityStyleConfiguration.default().themeColor
        titleScrollView.addSubview(selectorCityLabel)
        selectorCityLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        // 创建分割线
        separatorLinee = UIView()
        separatorLinee.backgroundColor = .art_color(withHEXValue: 0xe1e1e1)
        addSubview(separatorLinee)
        separatorLinee.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1.0)
        }
        
        sliderControlLine = UIView()
        sliderControlLine.tag = 2000
        sliderControlLine.backgroundColor = ARTCityStyleConfiguration.default().themeColor
        titleScrollView.addSubview(sliderControlLine)
        sliderControlLine.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 32.0, height: 2.0))
            make.centerX.equalTo(selectorCityLabel)
            make.bottom.equalTo(separatorLinee)
        }
        if ARTCityStyleConfiguration.default().isGradientLine {
            sliderControlLine.layer.cornerRadius  = 1.0
            sliderControlLine.layer.masksToBounds = true
        }
        if let gradientLayer = ARTCityStyleConfiguration.default().gradientLayer {
            gradientLayer.frame = CGRect(x: 0.0, y: 0.0, width: 32.0, height: 2.0)
            sliderControlLine.layer.addSublayer(gradientLayer)
        }
    }
    
    // MARK: - Private Button Actions
    
    @objc private func clickCloseButtonTapped(sender: UIButton) {
        delegate?.didTapCloseCitySelector?(self)
    }
    
    @objc private func clickLocationButtonTapped(sender: UIButton) {
        print("点击了定位按钮")
    }
    
    @objc private func clickTitleButtonTapped(sender: UIButton) {
        let selectedColor = ARTCityStyleConfiguration.default().themeColor
        let normalColor = UIColor.art_color(withHEXValue: 0x18171f)
        
        cityNames.enumerated().forEach { (index, title) in
            guard let button = sender.superview?.viewWithTag(index + 1000) as? UIButton else { return }

            if index + 1000 == sender.tag {
                button.setTitleColor(selectedColor, for: .normal)
                sliderControlLine.snp.remakeConstraints { make in
                    make.size.equalTo(CGSize(width: 32.0, height: 2.0))
                    make.centerX.equalTo(button)
                    make.bottom.equalTo(separatorLinee)
                }
                
                let buttonFrameInScrollView = button.convert(button.bounds, to: titleScrollView)
                let visibleRect = titleScrollView.bounds.inset(by: titleScrollView.contentInset)
                if !visibleRect.contains(buttonFrameInScrollView) {
                    titleScrollView.scrollRectToVisible(buttonFrameInScrollView, animated: true)
                }
            } else {
                button.setTitleColor(normalColor, for: .normal)
            }
        }
        delegate?.citySelectorElementKindHeader?(self, didSelectItemAt: sender.tag - 1000)
    }
}

// MARK: - Public Method

extension ARTCitySelectorHeader {
    
    /// 更新城市选择器的标题
    public func updateCitySelectorHeader(_ cityNames: [String]) {
        self.cityNames = cityNames
        // 过滤出是 UIButton 或 UILabel 类型的视图并移除
        let viewsToRemove = titleScrollView.subviews.filter { $0 is UIButton || $0 is UILabel }
        viewsToRemove.forEach { $0.removeFromSuperview() }
        
        var lastButton: ARTAlignmentButton?
        let selectedColor = ARTCityStyleConfiguration.default().themeColor
        let normalColor = UIColor.art_color(withHEXValue: 0x18171f)
        cityNames.enumerated().forEach { (index, title) in
            let titleButton = ARTAlignmentButton()
            titleButton.tag                         = index + 1000
            titleButton.titleLabel?.font            = .art_regular(14.0)
            titleButton.contentHorizontalAlignment  = .left
            titleButton.setTitleColor(index == cityNames.count - 1 ? selectedColor : normalColor, for: .normal)
            titleButton.setTitle(title, for: .normal)
            titleButton.addTarget(self, action: #selector(clickTitleButtonTapped(sender:)), for: .touchUpInside)
            titleScrollView.addSubview(titleButton)
            titleButton.snp.makeConstraints { make in
                if let lastButton = lastButton {
                    make.left.equalTo(lastButton.snp.right).offset(60.0)
                } else {
                    make.left.equalToSuperview()
                }
                make.centerY.equalToSuperview()
            }
            
            lastButton = titleButton
        }
        
        self.sliderControlLine.snp.remakeConstraints { make in
            make.size.equalTo(CGSize(width: 32.0, height: 2.0))
            make.centerX.equalTo(lastButton!)
            make.bottom.equalTo(self.separatorLinee)
        }
        
        titleScrollView.layoutIfNeeded()
        titleScrollView.contentSize = CGSize(width: lastButton!.frame.maxX, height: titleScrollView.bounds.height)
        
        // 检查内容是否超出屏幕
        if let lastButton = lastButton, lastButton.frame.maxX + titleScrollView.contentInset.right > titleScrollView.bounds.width {
            let offsetX = max(0, lastButton.frame.maxX - titleScrollView.bounds.width)
            titleScrollView.setContentOffset(CGPoint(x: offsetX + titleScrollView.contentInset.right, y: 0), animated: true)
        }
    }
}
