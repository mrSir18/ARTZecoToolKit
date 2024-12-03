//
//  ARTWebToolbar.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/8/21.
//

/// `ARTWebToolbarProtocol` 协议用于提供 `ARTWebToolbar` 的配置。
@objc public protocol ARTWebToolbarProtocol: AnyObject {
    
    /// 当工具栏上的返回按钮被点击时调用。
    /// - Parameters:
    ///   - toolbar: 按钮所在的工具栏。
    ///   - button: 被点击的返回按钮。
    func toolbar(_ toolbar: ARTWebToolbar, didTapGoBackButton button: UIButton)
    
    /// 当工具栏上的前进按钮被点击时调用。
    /// - Parameters:
    ///   - toolbar: 按钮所在的工具栏。
    ///   - button: 被点击的前进按钮。
    func toolbar(_ toolbar: ARTWebToolbar, didTapGoForwardButton button: UIButton)
}

open class ARTWebToolbar: UIView {
    
    /// 代理对象
    private weak var delegate: ARTWebToolbarProtocol?
    
    /// 返回按钮
    private var goBackButton: ARTAlignmentButton!
    
    /// 前进按钮
    private var goForwardButton: ARTAlignmentButton!
    
    
    // MARK: - Initialization
    
    convenience init(_ delegate: ARTWebToolbarProtocol) {
        self.init()
        self.alpha = 0.0
        self.delegate = delegate
        setupViews()
    }
    
    open func setupViews() {
        // 子类继承: 重写此方法以自定义视图
        
        // 创建容器视图
        let containerView = UIView()
        containerView.backgroundColor       = .art_color(withHEXValue: 0xD9D9D9, alpha: 0.36)
        containerView.layer.cornerRadius    = ARTAdaptedValue(33.0)
        containerView.layer.masksToBounds   = true
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        let blurEffect = UIBlurEffect(style: .light)
        let visualView = UIVisualEffectView(effect: blurEffect)
        containerView.addSubview(visualView)
        visualView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 创建返回按钮
        goBackButton = ARTAlignmentButton(type: .custom)
        goBackButton.imageAlignment             = .left
        goBackButton.titleAlignment             = .right
        goBackButton.contentInset               = ARTAdaptedValue(4.0)
        goBackButton.imageSize                  = ARTAdaptedSize(width: 58.0, height: 58.0)
        goBackButton.setImage(UIImage(named: "web_go_back_normal"), for: .normal)
        goBackButton.setImage(UIImage(named: "web_go_back_selected"), for: .selected)
        goBackButton.addTarget(self, action: #selector(goBackButtonTapped), for: .touchUpInside)
        addSubview(goBackButton)
        goBackButton.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(ARTAdaptedValue(66.0))
        }
        
        // 创建返回按钮
        goForwardButton = ARTAlignmentButton(type: .custom)
        goForwardButton.imageAlignment          = .right
        goForwardButton.titleAlignment          = .left
        goForwardButton.contentInset            = ARTAdaptedValue(4.0)
        goForwardButton.imageSize               = ARTAdaptedSize(width: 58.0, height: 58.0)
        goForwardButton.setImage(UIImage(named: "web_go_forward_normal"), for: .normal)
        goForwardButton.setImage(UIImage(named: "web_go_forward_selected"), for: .selected)
        goForwardButton.addTarget(self, action: #selector(goForwardButtonTapped), for: .touchUpInside)
        addSubview(goForwardButton)
        goForwardButton.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(goBackButton)
        }
        updateToolButtonsState(canGoBack: false, canGoForward: false) // 默认不可点击
    }
    
    // MARK: - Private Methods
    
    @objc private func goBackButtonTapped(sender: UIButton) { /// 返回按钮点击事件
        delegate?.toolbar(self, didTapGoBackButton: sender)
    }
    
    @objc private func goForwardButtonTapped(sender: UIButton) { /// 前进按钮点击事件
        delegate?.toolbar(self, didTapGoForwardButton: sender)
    }
    
    // MARK: - Public Methods
    
    open func updateToolButtonsState(canGoBack: Bool, canGoForward: Bool) { /// 更新工具栏按钮状态
        goBackButton.isEnabled = canGoBack
        goBackButton.isSelected = canGoBack
        goForwardButton.isEnabled = canGoForward
        goForwardButton.isSelected = canGoForward
    }
}
