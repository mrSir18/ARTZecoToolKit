//
//  ARTVideoPlayerPortraitDanmakuView.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/11/7.
//

open class ARTVideoPlayerPortraitDanmakuView: ARTVideoPlayerPortraitSlidingView {

    /// 分享视图
    public var shareView: ARTVideoPlayerPortraitShareView!
    
    /// 弹幕视图
    public var danmakuView: ARTVideoPlayerPortraitBarrageView!
    
    
    // MARK: - Override Super Methods
    
    open override func setupViews() {
        super.setupViews()
        setupShareView()
        setupDanmakuView()
    }
}

// MARK: - Setup Initializer

extension ARTVideoPlayerPortraitDanmakuView {
    
    /// 创建分享视图
    private func setupShareView() {
        shareView = ARTVideoPlayerPortraitShareView()
        shareView.shareCallback = { [weak self] type in
            self?.hideExtensionsView({
                print("分享选项类型：\(type)")
            })
        }
        containerView.addSubview(shareView)
        shareView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(ARTAdaptedValue(148.0))
        }
    }
    
    /// 创建弹幕视图
    private func setupDanmakuView() {
        danmakuView = ARTVideoPlayerPortraitBarrageView()
        containerView.addSubview(danmakuView)
        danmakuView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(shareView.snp.bottom)
            make.bottom.equalTo(-art_safeAreaBottom())
        }
    }
}
