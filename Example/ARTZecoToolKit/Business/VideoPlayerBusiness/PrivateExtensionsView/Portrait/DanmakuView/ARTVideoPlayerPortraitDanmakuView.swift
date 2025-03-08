//
//  ARTVideoPlayerPortraitDanmakuView.swift
//  ARTZeco
//
//  Created by mrSir18 on 2024/11/7.
//

import ARTZecoToolKit

class ARTVideoPlayerPortraitDanmakuView: ARTVideoPlayerPortraitSlidingView {

    /// 分享视图
    private var shareView: ARTVideoPlayerPortraitShareView!
    
    /// 弹幕视图
    private var danmakuView: ARTVideoPlayerPortraitBarrageView!
    
    
    // MARK: - Override Super Methods
    
    override func setupViews() {
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
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSortingPanGesture(_:)))
        shareView.addGestureRecognizer(panGesture)
    }
    
    /// 创建弹幕视图
    private func setupDanmakuView() {
        danmakuView = ARTVideoPlayerPortraitBarrageView()
        danmakuView.sliderValueChangedCallback = { [weak self] option in
            guard let self = self else { return }
            self.delegate?.slidingViewDidSliderValueChanged(for: option) // 滑块值改变事件回调
        }
        danmakuView.restoreDanmakuCallback = { [weak self] danmakuEntity in
            guard let self = self else { return }
            self.delegate?.slidingViewDidTapRestoreButton(for: danmakuEntity) // 恢复弹幕设置事件回调
        }
        containerView.addSubview(danmakuView)
        danmakuView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(shareView.snp.bottom)
            make.bottom.equalTo(-art_safeAreaBottom())
        }
    }
}
