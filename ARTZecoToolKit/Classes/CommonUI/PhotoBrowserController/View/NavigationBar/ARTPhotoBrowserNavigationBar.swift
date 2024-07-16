//
//  ARTPhotoBrowserNavigationBar.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/7/15.
//

public protocol ARTPhotoBrowserNavigationBarDelegate: AnyObject {
    /// 协议方法
    ///
    /// - NOTE: 可继承该协议方法
}

open class ARTPhotoBrowserNavigationBar: UIView {
    
    /// 代理对象
    public weak var delegate: ARTPhotoBrowserNavigationBarDelegate?
    
    /// 默认配置
    private let configuration = ARTPhotoBrowserStyleConfiguration.default()
    
    /// 关闭控制器,图片浏览器回调
    public var dismissPhotoBrowserCallback: (() -> Void)?
    
    
    // MARK: - Life Cycle
    
    public init(_ delegate: ARTPhotoBrowserNavigationBarDelegate? = nil) {
        super.init(frame: .zero)
        self.delegate = delegate
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = configuration.enableTopBarUserInteraction
        setupViews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 重写父类方法，设置子视图
    ///
    /// - Note: 由于子类需要自定义视图，所以需要重写该方法
    open func setupViews() {
        
        // 创建容器视图
        let containerView = UIView()
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalTo(art_statusBarHeight())
            make.left.bottom.right.equalToSuperview()
        }
        
        // 创建返回按钮
        let backButton = ARTAlignmentButton(type: .custom)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        backButton.imageAlignment   = .left
        backButton.titleAlignment   = .right
        backButton.contentInset     = ARTAdaptedValue(12.0)
        if let customBackButtonImageName = configuration.customBackButtonImageName, !customBackButtonImageName.isEmpty {
            backButton.imageSize    = ARTAdaptedSize(width: 28.0, height: 28.0)
            backButton.setImage(UIImage(named: customBackButtonImageName), for: .normal)
        } else {
            backButton.setTitle("关闭", for: .normal)
            backButton.setTitleColor(.white, for: .normal)
        }
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        containerView.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(ARTAdaptedValue(65.0))
        }
    }
    
    // MARK: - Private Button Actions
    
    @objc private func backButtonTapped(sender: UIButton) {
        dismissPhotoBrowserCallback?()
    }
}
