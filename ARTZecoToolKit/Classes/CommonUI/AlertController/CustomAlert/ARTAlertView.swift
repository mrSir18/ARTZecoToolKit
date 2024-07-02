//
//  ARTAlertView.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/7/1.
//

import SnapKit

open class ARTAlertView: UIView {
    
    /// 默认配置
    public let configuration = ARTAlertViewStyleConfiguration.default()
    
    /// 标题标签
    private var titleLabel: UILabel!
    
    /// 描述标签
    private var descLabel: UILabel!
    
    /// 取消按钮
    private var cancelButton: ARTCustomButton!
    
    /// 确认按钮
    private var confirmButton: ARTCustomButton!
    
    /// 按钮点击回调
    public var buttonTappedCallback: ((ARTAlertControllerMode) -> Void)?
    
    
    // MARK: - Life Cycle
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        setupViews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        // 创建遮罩视图
        let overlayView = UIView(frame: UIScreen.main.bounds)
        overlayView.backgroundColor = .art_color(withHEXValue: 0x000000, alpha: 0.2)
        addSubview(overlayView)
        
        // 创建背景容器
        let superContainerView = UIView()
        superContainerView.backgroundColor = .clear
        superContainerView.isUserInteractionEnabled = false
        addSubview(superContainerView)
        superContainerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(art_navigationFullHeight())
            make.bottom.equalTo(-art_tabBarFullHeight())
        }
        
        // 创建容器视图
        let containerView = UIView()
        containerView.backgroundColor     = configuration.containerBackgroundColor
        containerView.layer.cornerRadius  = configuration.cornerRadius
        containerView.layer.masksToBounds = true
        addSubview(containerView)
        
        // 创建标题标签
        titleLabel = UILabel()
        titleLabel.textAlignment        = .center
        titleLabel.font                 = configuration.titleFont
        titleLabel.textColor            = configuration.titleColor
        titleLabel.numberOfLines        = 0
        titleLabel.sizeToFit()
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(configuration.titleTopSpacing)
        }
        
        // 创建描述标签
        descLabel = UILabel()
        descLabel.textAlignment         = .center
        descLabel.font                  = configuration.descFont
        descLabel.textColor             = configuration.descColor
        descLabel.numberOfLines         = 0
        containerView.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.left.equalTo(configuration.textHorizontalMargin)
            make.top.equalTo(titleLabel.snp.bottom).offset(configuration.descTopSpacing)
            make.right.equalTo(-configuration.textHorizontalMargin)
        }
        
        containerView.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(superContainerView)
            make.width.equalTo(configuration.containerWidth)
            make.bottom.equalTo(descLabel.snp.bottom).offset(configuration.buttonBottomSpacing)
        }
        
        // 创建按钮之前检查数组长度是否一致
        let buttonPropertiesCounts = [
            configuration.buttonTitles.count,
            configuration.buttonBackgroundColors.count,
            configuration.buttonTitleFonts.count,
            configuration.buttonBorderColors.count,
            configuration.buttonTitleColors.count
        ]
        guard Set(buttonPropertiesCounts).count == 1 else {
            print("Error: Inconsistent array lengths for button configuration.")
            return
        }
        
        // 创建按钮
        var previousButton: ARTCustomButton?
        let buttonCount = configuration.buttonTitles.count
        configuration.buttonTitles.enumerated().forEach { index, title in
            let button = ARTCustomButton(type: .custom)
            button.tag                      = index
            button.customBackgroundColor    = configuration.buttonBackgroundColors[index]
            button.titleLabel?.font         = configuration.buttonTitleFonts[index]
            button.borderWidth              = configuration.buttonBorderWidth
            button.cornerRadius             = configuration.buttonRadius
            button.borderColor              = configuration.buttonBorderColors[index]
            button.setTitle(title, for: .normal)
            button.setTitleColor(configuration.buttonTitleColors[index], for: .normal)
            button.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
            containerView.addSubview(button)
            button.snp.makeConstraints { make in
                make.size.equalTo(configuration.buttonSize)
                switch buttonCount {
                case 1:
                    make.top.equalTo(descLabel.snp.bottom).offset(configuration.buttonTopSpacingToDescription)
                    make.centerX.equalToSuperview()
                case 2:
                    make.top.equalTo(descLabel.snp.bottom).offset(configuration.buttonTopSpacingToDescription)
                    if index == 0 {
                        make.left.equalTo(configuration.buttonHorizontalMargin)
                    } else {
                        make.right.equalTo(-configuration.buttonHorizontalMargin)
                    }
                default:
                    make.top.equalTo(index == 0 ? descLabel.snp.bottom : previousButton!.snp.bottom).offset(configuration.buttonTopSpacingToDescription)
                    make.centerX.equalToSuperview()
                }
            }
            previousButton = button
        }
        if let previousButton = previousButton {
            containerView.snp.remakeConstraints { make in
                make.centerX.centerY.equalTo(superContainerView)
                make.width.equalTo(configuration.containerWidth)
                make.bottom.equalTo(previousButton.snp.bottom).offset(configuration.buttonBottomSpacing)
            }
        }
    }
    
    // MARK: - Private Button Actions
    
    @objc private func buttonTapped(sender: UIButton) {
        let tag = sender.tag
        let mode = tag < ARTAlertControllerMode.allCases.count ? ARTAlertControllerMode.allCases[tag] : .custom(tag + 1)
        buttonTappedCallback?(mode)
        removeFromSuperview()
    }
    
    // MARK: - Public Method
    
    // 设置标题
    open func title(_ title: String) {
        titleLabel.text = title
    }
    
    // 设置描述
    open func desc(_ desc: String) {
        descLabel.text = desc
    }
    
    /// 展示AlertView
    open func show() {
        keyWindow.addSubview(self)
        self.snp.makeConstraints { make in
            make.size.equalTo(CGSizeMake(UIScreen.art_currentScreenWidth,
                                         UIScreen.art_currentScreenHeight))
            make.left.top.equalToSuperview()
        }
    }
}
