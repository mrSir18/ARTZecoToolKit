//
//  ARTWebNavigationBarView.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/8/20.
//

/// `ARTWebNavigationBarViewProtocol` 协议用于提供 `ARTWebNavigationBarView` 的配置。
/// 通过实现这个协议，可以定制导航栏的背景色、返回按钮图片、标题内容等属性等。
@objc public protocol ARTWebNavigationBarViewProtocol: AnyObject {
    
    /// 点击返回按钮时调用。
    ///
    /// - Parameter navigationBar: 导航栏视图。
    /// - Returns: 无。
    func navigationBarDidTapBackButton(_ navigationBar: ARTWebNavigationBarView)
    
    
    // MARK: - navigationBar Style
    
    
    /// 是否隐藏导航栏
    ///
    /// - Parameter navigationBar: 导航栏视图。
    /// - Returns: `true` 表示隐藏导航栏，`false` 表示显示导航栏。
    /// - Note: 默认为 `false`。
    func shouldHideNavigationBar(for navigationBar: ARTWebNavigationBarView) -> Bool
    
    /// 导航栏的背景色。
    ///
    /// - Parameter navigationBar: 导航栏视图。
    /// - Returns: 背景色。
    func navigationBarBackgroundColor(for navigationBar: ARTWebNavigationBarView) -> UIColor
    
    /// 导航栏的透明度。
    ///
    /// - Parameter navigationBar: 导航栏视图。
    /// - Returns: 透明度。
    func navigationBarAlpha(for navigationBar: ARTWebNavigationBarView) -> CGFloat
    
    /// 导航栏背景色自动透明度是否跟随滚动视图。
    ///
    /// - Parameter navigationBar: 导航栏视图。
    /// - Returns: `true` 表示跟随滚动视图，`false` 表示不跟随滚动视图。
    func shouldFollowScrollView(for navigationBar: ARTWebNavigationBarView) -> Bool
    
    /// 返回导航栏的返回按钮图片。
    ///
    /// - Parameter navigationBar: 导航栏视图。
    /// - Returns: 返回按钮图片名称。
    func backButtonImageName(for navigationBar: ARTWebNavigationBarView) -> String?
    
    /// 导航栏的返回按钮是否应隐藏。
    ///
    /// - Parameter navigationBar: 导航栏视图。
    /// - Returns: `true` 表示隐藏返回按钮，`false` 表示显示返回按钮。
    func shouldHideBackButton(for navigationBar: ARTWebNavigationBarView) -> Bool
    
    /// 返回导航栏标题的内容。
    ///
    /// - Parameter navigationBar: 导航栏视图。
    /// - Returns: 标题内容。
    func titleContent(for navigationBar: ARTWebNavigationBarView) -> String
    
    /// 返回导航栏标题的字体。
    ///
    /// - Parameter navigationBar: 导航栏视图。
    /// - Returns: 标题字体。
    func titleFont(for navigationBar: ARTWebNavigationBarView) -> UIFont
    
    /// 返回导航栏标题的颜色。
    ///
    /// - Parameter navigationBar: 导航栏视图。
    /// - Returns: 标题颜色。
    func titleColor(for navigationBar: ARTWebNavigationBarView) -> UIColor
    
    /// 返回导航栏右侧自定义视图。
    ///
    /// - Parameter navigationBar: 导航栏视图。
    /// - Returns: 自定义视图，如果没有返回 `nil`。
    func customRightView(for navigationBar: ARTWebNavigationBarView) -> UIView?
}

open class ARTWebNavigationBarView: UIView {
    
    /// 代理对象
    private weak var delegate: ARTWebNavigationBarViewProtocol?
    
    
    // MARK: - Life Cycle
    
    convenience init(_ delegate: ARTWebNavigationBarViewProtocol) {
        self.init()
        self.delegate = delegate
        self.isHidden = delegate_shouldHideNavigationBar() // 是否隐藏导航栏
        setupViews()
    }
    
    private func setupViews() {
        // 创建透明容器视图
        let containerBar = UIView()
        containerBar.backgroundColor = delegate_navigationBarBackgroundColor()
        containerBar.alpha = delegate_navigationBarAlpha()
        if delegate_shouldFollowScrollView() { containerBar.alpha = 0.0 } // 如果跟随滚动视图，初始透明度为0
        addSubview(containerBar)
        containerBar.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 创建容器视图
        let containerView = UIView()
        containerView.backgroundColor = .clear
        containerBar.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalTo(art_statusBarHeight())
            make.left.right.equalToSuperview()
            make.height.equalTo(art_navigationBarHeight())
        }
        
        // 创建返回按钮
        let backButton = ARTAlignmentButton(type: .custom)
        backButton.isHidden         = delegate_shouldHideBackButton()
        backButton.imageAlignment   = .left
        backButton.titleAlignment   = .left
        backButton.contentInset     = ARTAdaptedValue(12.0)
        backButton.imageSize        = ARTAdaptedSize(width: 18.0, height: 18.0)
        if let image = UIImage(named: delegate_backButtonImageName()) { backButton.setImage(image, for: .normal) } // 设置返回按钮图片
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.left.top.bottom.equalTo(containerView)
            make.width.equalTo(ARTAdaptedValue(60.0))
        }
        
        // 创建标题标签
        let titleLabel = UILabel()
        titleLabel.text             = delegate_titleContent()
        titleLabel.textAlignment    = .center
        titleLabel.font             = delegate_titleFont()
        titleLabel.textColor        = delegate_titleColor()
        containerView.addSubview(titleLabel)
        
        // 创建右侧自定义视图
        if let customRightView = delegate_customRightView() {
            containerView.addSubview(customRightView)
            customRightView.snp.makeConstraints { make in
                make.right.equalToSuperview()
                make.top.bottom.equalToSuperview()
                make.width.equalTo(ARTAdaptedValue(60.0))
            }
            
            titleLabel.snp.makeConstraints { make in
                make.left.equalTo(backButton.snp.right)
                make.top.bottom.equalToSuperview()
                make.right.equalTo(customRightView.snp.left)
            }
        } else {
            titleLabel.snp.makeConstraints { make in
                make.left.equalTo(backButton.snp.right)
                make.top.bottom.equalToSuperview()
                make.right.equalTo(-ARTAdaptedValue(60.0))
            }
        }
    }
    
    // MARK: - Private Button Actions
    
    @objc private func backButtonTapped(sender: UIButton) {
        delegate?.navigationBarDidTapBackButton(self)
    }
    
    // MARK: - Private Delegate Methods
    
    private func delegate_shouldHideNavigationBar() -> Bool { // 是否隐藏导航栏
        return delegate?.shouldHideNavigationBar(for: self) ?? false
    }
    
    private func delegate_navigationBarBackgroundColor() -> UIColor { // 导航栏背景色
        return delegate?.navigationBarBackgroundColor(for: self) ?? .white
    }
    
    private func delegate_navigationBarAlpha() -> CGFloat { // 导航栏透明度
        return delegate?.navigationBarAlpha(for: self) ?? 1.0
    }
    
    private func delegate_shouldFollowScrollView() -> Bool { // 背景色透明度是否跟随滚动视图
        return delegate?.shouldFollowScrollView(for: self) ?? false
    }
    
    private func delegate_backButtonImageName() -> String { // 返回按钮图片
        return delegate?.backButtonImageName(for: self) ?? ""
    }
    
    private func delegate_shouldHideBackButton() -> Bool { // 是否隐藏返回按钮
        return delegate?.shouldHideBackButton(for: self) ?? false
    }
    
    private func delegate_titleContent() -> String { // 标题内容
        return delegate?.titleContent(for: self) ?? ""
    }
    
    private func delegate_titleFont() -> UIFont { // 标题字体
        return delegate?.titleFont(for: self) ?? .art_medium(ARTAdaptedValue(17.0)) ?? .systemFont(ofSize: ARTAdaptedValue(17.0))
    }
    
    private func delegate_titleColor() -> UIColor { // 标题颜色
        return delegate?.titleColor(for: self) ?? .art_color(withHEXValue: 0x000000)
    }
    
    private func delegate_customRightView() -> UIView? { // 右侧自定义视图
        return delegate?.customRightView(for: self)
    }
}
