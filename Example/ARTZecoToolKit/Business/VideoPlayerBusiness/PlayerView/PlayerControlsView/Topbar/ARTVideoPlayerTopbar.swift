//
//  ARTVideoPlayerTopbar.swift
//  ARTZeco
//
//  Created by mrSir18 on 2024/10/15.
//

import ARTZecoToolKit
import RxSwift
import RxCocoa

protocol ARTVideoPlayerTopbarDelegate: AnyObject {
    
    /// 用户点击顶部导航栏按钮
    /// - Parameter sender: 按钮对象
    func topbar(_ topbar: ARTVideoPlayerTopbar, didTapButton sender: UIButton)
}

class ARTVideoPlayerTopbar: UIView {
    
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
    
    /// 订阅管理对象
    public let disposeBag = DisposeBag()
    
    
    // MARK: - Initialization
    
    init(_ delegate: ARTVideoPlayerTopbarDelegate? = nil) {
        super.init(frame: .zero)
        self.delegate = delegate
        self.backgroundColor = .clear
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Super Methods
    
    /// 重写父类方法，设置子视图
    public func setupViews() {
        
    }
    
    // MARK: - Button Actions
    
    /// 处理按钮点击事件
    /// - Parameter button: 按钮对象
    public func handleButtonTap(_ sender: UIButton) {
        delegate?.topbar(self, didTapButton: sender)
    }
}

// MARK: - Public Methods

extension ARTVideoPlayerTopbar {
    
    /// 更新收藏按钮状态
    /// - Parameter isFavorited: 是否已收藏
    public func updateFavoriteButtonImage(isFavorited: Bool) {
        self.isFavorited = isFavorited
        // 根据 isFavorited 更新按钮图片的代码
    }
}
