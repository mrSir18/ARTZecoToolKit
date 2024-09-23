//
//  ARTQuantityControlView.swift
//  Alamofire
//
//  Created by mrSir18 on 2024/5/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

/// 比较类型
enum ComparisonType {
    case greaterThan
    case lessThan
}

public class ARTQuantityControlView: UIView {
    
    /// 默认配置
    let configuration = ARTQuantityStyleConfiguration.default()
    
    /// 减少按钮
    private var decreaseButton: ARTAlignmentButton!
    
    /// 数量输入框
    private var quantityTextField: UITextField!

    /// 增加按钮
    private var increaseButton: ARTAlignmentButton!
    
    // 当前数量，默认为1
    public var quantity: Int = 1 {
        didSet {
            // 确保数量在 minimumQuantity 到 maximumQuantity 之间
            quantity = min(max(quantity, configuration.minimumQuantity), configuration.maximumQuantity)
            quantityTextField.text = "\(quantity)"
            decreaseButton.alpha = buttonAlpha(for: quantity, second: configuration.minimumQuantity, comparison: .greaterThan)
            increaseButton.alpha = buttonAlpha(for: quantity, second: configuration.maximumQuantity, comparison: .lessThan)
        }
    }
    
    // 回调闭包，当数量发生变化时调用
    public var quantityChanged: ((Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        // 创建容器视图
        let containerView = UIView()
        containerView.backgroundColor       = configuration.containerBackgroundColor
        containerView.layer.cornerRadius    = configuration.cornerRadius
        containerView.layer.maskedCorners   = configuration.maskedCorners
        containerView.layer.borderColor     = configuration.borderColor.cgColor
        containerView.layer.borderWidth     = configuration.borderWidth
        containerView.clipsToBounds         = configuration.clipsToBounds
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        // 创建减少按钮
        decreaseButton = ARTAlignmentButton(type: .custom)
        decreaseButton.alpha                = buttonAlpha(for: quantity, second: configuration.minimumQuantity, comparison: .greaterThan)
        decreaseButton.backgroundColor      = configuration.buttonBackgroundColor
        decreaseButton.imageSize            = configuration.imageSize
        decreaseButton.setImage(UIImage(named: configuration.decreaseImageName ?? ""), for: .normal)
        decreaseButton.addTarget(self, action: #selector(decreaseQuantity), for: .touchUpInside)
        containerView.addSubview(decreaseButton)
        decreaseButton.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(configuration.buttonWidth)
        }

        // 创建增加按钮
        increaseButton = ARTAlignmentButton(type: .custom)
        increaseButton.alpha                = buttonAlpha(for: quantity, second: configuration.maximumQuantity, comparison: .lessThan)
        increaseButton.backgroundColor      = configuration.buttonBackgroundColor
        increaseButton.imageSize            = configuration.imageSize
        increaseButton.setImage(UIImage(named: configuration.increaseImageName ?? ""), for: .normal)
        increaseButton.addTarget(self, action: #selector(increaseQuantity), for: .touchUpInside)
        containerView.addSubview(increaseButton)
        increaseButton.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(configuration.buttonWidth)
        }
        
        // 创建数量文本框
        quantityTextField = UITextField()
        quantityTextField.delegate          = self
        quantityTextField.text              = "\(quantity)"
        quantityTextField.textAlignment     = .center
        quantityTextField.keyboardType      = .numberPad
        quantityTextField.font              = configuration.textFieldFont
        quantityTextField.textColor         = configuration.textFieldTextColor
        quantityTextField.backgroundColor   = configuration.textFieldBackgroundColor
        containerView.addSubview(quantityTextField)
        quantityTextField.snp.makeConstraints { make in
            make.left.equalTo(decreaseButton.snp.right)
            make.top.bottom.equalToSuperview()
            make.right.equalTo(increaseButton.snp.left)
        }
        
        // 创建左侧分割线
        let leftSeparator = UIView()
        leftSeparator.isHidden          = configuration.hideSeparator
        leftSeparator.backgroundColor   = configuration.borderColor
        containerView.addSubview(leftSeparator)
        leftSeparator.snp.makeConstraints { make in
            make.left.equalTo(decreaseButton.snp.right)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(configuration.borderWidth)
        }
        
        // 创建右侧分割线
        let rightSeparator = UIView()
        rightSeparator.isHidden         = configuration.hideSeparator
        rightSeparator.backgroundColor  = configuration.borderColor
        containerView.addSubview(rightSeparator)
        rightSeparator.snp.makeConstraints { make in
            make.right.equalTo(increaseButton.snp.left)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(configuration.borderWidth)
        }
    }
    
    @objc private func decreaseQuantity() {
        if quantity > configuration.minimumQuantity {
            quantity -= 1
            quantityChanged?(quantity)
        }
    }

    @objc private func increaseQuantity() {
        if quantity < configuration.maximumQuantity {
            quantity += 1
            quantityTextField.text = "\(quantity)"
            quantityChanged?(quantity)
        }
    }
    
    private func buttonAlpha(for first: Int, second: Int, comparison: ComparisonType) -> CGFloat {
        switch comparison {
        case .greaterThan:
            return first > second ? 1.0 : 0.25
        case .lessThan:
            return first < second ? 1.0 : 0.25
        }
    }
}

extension ARTQuantityControlView: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 如果是删除操作，允许删除。
        if string.isEmpty {
            return true
        }
        
        // 检查是否是有效的数字。
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    public func textFieldDidChangeSelection(_ textField: UITextField) {
        // 获取当前文本。
        guard let currentText = textField.text else {
            return
        }
        
        // 保存用户输入的数字
        var newValue: Int?
        
        if !currentText.isEmpty {
            // 转换为整数。如果失败，则保持nil。
            newValue = Int(currentText)
        }
        
        // 限制文本框显示的值不超过configuration.maximumQuantity
        if let newValue = newValue {
            textField.text = "\(min(newValue, configuration.maximumQuantity))"
        }
        
        // 更新按钮的状态。
        decreaseButton.alpha = buttonAlpha(for: newValue ?? configuration.minimumQuantity, second: configuration.minimumQuantity, comparison: .greaterThan)
        increaseButton.alpha = buttonAlpha(for: newValue ?? configuration.minimumQuantity, second: configuration.maximumQuantity, comparison: .lessThan)
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        // 获取当前文本。
        guard let currentText = textField.text else {
            // 如果文本为空，则设置数量为1。
            quantity = configuration.minimumQuantity
            return
        }
        
        if currentText.isEmpty {
            // 如果文本为空且键盘收起，则设置数量为1。
            quantity = configuration.minimumQuantity
        } else {
            // 转换为整数。如果失败，则设置数量为1。
            guard var newValue = Int(currentText) else {
                quantity = configuration.minimumQuantity
                return
            }
            
            // 确保数量在1到configuration.maximumQuantity之间。
            newValue = min(max(newValue, configuration.minimumQuantity), configuration.maximumQuantity)
            
            // 更新文本框中的值
            textField.text = "\(newValue)"
            
            // 更新按钮的状态。
            decreaseButton.alpha = buttonAlpha(for: newValue, second: configuration.minimumQuantity, comparison: .greaterThan)
            increaseButton.alpha = buttonAlpha(for: newValue, second: configuration.maximumQuantity, comparison: .lessThan)
            
            // 更新数量值
            quantity = newValue
        }
        quantityChanged?(quantity)
    }
}







