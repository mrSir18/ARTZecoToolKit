//
//  ARTPhotoBrowserNavigationBar.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/7/15.
//

public class ARTPhotoBrowserNavigationBar: UIView {
    
    /// 默认配置
    public let configuration = ARTPhotoBrowserStyleConfiguration.default()
    
    /// 关闭回调闭包，用于关闭控制器
    public var closeControllerCallback: (() -> Void)?
    
    
    // MARK: - Life Cycle
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = configuration.topBarUserInteractionEnabled
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
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
            backButton.imageSize    = ARTAdaptedSize(width: 18.0, height: 18.0)
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
        closeControllerCallback?()
    }
}
