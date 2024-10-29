//
//  ARTVideoPlayerTopbar.swift
//  Pods
//
//  Created by mrSir18 on 2024/10/15.
//

/// 协议方法
///
/// - NOTE: 可继承该协议方法
@objc public protocol ARTVideoPlayerTopbarDelegate: AnyObject {
    
    /// 当返回按钮被点击时调用
    @objc optional func topbarDidTapBack(for topbar: ARTVideoPlayerTopbar)
    
    /// 当收藏按钮被点击时调用
    ///
    /// - Parameters:
    ///   - topbar: 当前的 `ARTVideoPlayerTopbar` 实例
    ///   - isFavorited: 是否已收藏
    @objc optional func topbarDidTapFavorite(for topbar: ARTVideoPlayerTopbar, isFavorited: Bool)
    
    /// 当分享按钮被点击时调用
    @objc optional func topbarDidTapShare(for topbar: ARTVideoPlayerTopbar)
}

open class ARTVideoPlayerTopbar: UIView {
    
    /// 代理对象
    public weak var delegate: ARTVideoPlayerTopbarDelegate?
    
    /// 容器视图
    public var containerView: UIView!
    
    /// 返回按钮
    public var backButton: ARTAlignmentButton!
    
    /// 收藏按钮
    public var favoriteButton: ARTAlignmentButton!
    
    /// 分享按钮
    public var shareButton: ARTAlignmentButton!
    
    /// 当前收藏状态
    public var isFavorited: Bool = false
    
    
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
    open func setupViews() {
        
    }
    
    // MARK: - Button Actions
    
    /// 点击返回按钮
    @objc public func didTapBackButton() {
        delegate?.topbarDidTapBack?(for: self)
    }

    /// 点击收藏按钮
    @objc public func didTapFavoriteButton() {
        isFavorited.toggle()
        updateFavoriteState(isFavorited: isFavorited)
        delegate?.topbarDidTapFavorite?(for: self, isFavorited: isFavorited)
    }

    /// 点击分享按钮
    @objc public func didTapShareButton() {
        delegate?.topbarDidTapShare?(for: self)
    }

    // MARK: - Public Methods

    /// 更新收藏状态
    ///
    /// - Parameter isFavorited: 是否已收藏
    public func updateFavoriteState(isFavorited: Bool) {
        self.isFavorited = isFavorited
    }
}
