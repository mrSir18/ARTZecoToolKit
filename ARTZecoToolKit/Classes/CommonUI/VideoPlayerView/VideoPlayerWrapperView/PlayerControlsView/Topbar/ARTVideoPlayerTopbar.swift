//
//  ARTVideoPlayerTopbar.swift
//  Pods
//
//  Created by mrSir18 on 2024/10/15.
//

/// 协议方法
///
/// - NOTE: 可继承该协议方法
public protocol ARTVideoPlayerTopbarDelegate: AnyObject {
    
    /// 点击返回按钮
    ///
    /// - Note: 子类实现该方法处理返回操作
    func videoPlayerTopbarDidTapBack(for topbar: ARTVideoPlayerTopbar)
    
    /// 点击收藏按钮
    ///
    /// - Parameters:
    ///   - topbar: 当前的 `ARTVideoPlayerTopbar` 实例
    ///   - isFavorited: `true` 表示添加收藏，`false` 表示取消收藏
    /// - Note: 子类实现该方法处理收藏状态的改变
    func videoPlayerTopbarDidTapFavorite(for topbar: ARTVideoPlayerTopbar, isFavorited: Bool)
    
    /// 点击分享按钮
    ///
    /// - Note: 子类实现该方法处理分享操作
    func videoPlayerTopbarDidTapShare(for topbar: ARTVideoPlayerTopbar)
}

open class ARTVideoPlayerTopbar: UIView {
    
    /// 代理对象
    public weak var delegate: ARTVideoPlayerTopbarDelegate?
    
    /// 当前收藏状态
    private var isFavorited: Bool = false
    
    
    // MARK: - Initialization
    
    public init(_ delegate: ARTVideoPlayerTopbarDelegate? = nil) {
        super.init(frame: .zero)
        self.delegate = delegate
        self.backgroundColor = .clear
        setupViews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Super Methods
    
    /// 重写父类方法，设置子视图
    ///
    /// - Note: 由于子类需要自定义视图，所以需要重写该方法
    open func setupViews() {
        
    }
    
    // MARK: - Button Actions
    
    /// 点击返回按钮
    ///
    /// - Note: 子类实现该方法处理返回操作
    @objc public func didTapBackButton() {
        delegate?.videoPlayerTopbarDidTapBack(for: self)
    }
    
    /// 点击收藏按钮
    ///
    /// - Note: 子类实现该方法处理收藏状态的改变
    @objc public func didTapFavoriteButton() {
        isFavorited.toggle()
        updateFavoriteState(isFavorited: isFavorited)
        delegate?.videoPlayerTopbarDidTapFavorite(for: self, isFavorited: isFavorited)
    }
    
    /// 点击分享按钮
    ///
    /// - Note: 子类实现该方法处理分享
    @objc public func didTapShareButton() {
        delegate?.videoPlayerTopbarDidTapShare(for: self)
    }
    
    // MARK: - Public Methods
    
    /// 更新收藏状态
    ///
    /// - Parameter isFavorited: `true` 表示已收藏，`false` 表示未收藏
    public func updateFavoriteState(isFavorited: Bool) {
        self.isFavorited = isFavorited
    }
}
