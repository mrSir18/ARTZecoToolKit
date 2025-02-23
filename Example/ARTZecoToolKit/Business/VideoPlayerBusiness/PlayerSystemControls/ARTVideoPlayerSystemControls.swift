//
//  ARTVideoPlayerSystemControls.swift
//  Pods
//
//  Created by mrSir18 on 2024/10/21.
//

import AVFoundation
import ARTZecoToolKit

/// 协议方法
///
/// - NOTE: 可继承该协议方法
protocol ARTVideoPlayerSystemControlsDelegate: AnyObject {
    
}

class ARTVideoPlayerSystemControls: ARTPassThroughView {
    
    /// 代理对象
    weak var delegate: ARTVideoPlayerSystemControlsDelegate?
    
    /// 视频播放显示视图
    private var playerDisplayView: ARTVideoPlayerDisplayView!
    
    
    // MARK: - Initialization
    
    init(_ delegate: ARTVideoPlayerSystemControlsDelegate? = nil) {
        super.init(frame: .zero)
        self.delegate = delegate
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 子类重写: 设置视图
    func setupViews() {
        setupVideoPlayerDisplay()
    }
}

// MARK: - Public Methods

extension ARTVideoPlayerSystemControls {
    
    /// 更新屏幕方向
    /// - Parameter screenOrientation: 新的屏幕方向
    public func updateScreenOrientationInSystemControls(screenOrientation: ScreenOrientation) {
        playerDisplayView.updateScreenOrientation(screenOrientation: screenOrientation)
    }
    
    /// 更新预览图片
    /// - Parameter previewImage: 视频预览图片
    public func updatePreviewImageInSystemControls(previewImage: UIImage?) {
        playerDisplayView.updatePreviewImage(previewImage: previewImage)
    }
    
    /// 更新当前播放时间和总时长
    /// - Parameters:
    ///   - currentTime: 当前播放时间
    ///   - duration: 视频总时长
    public func updateTimeInSystemControls(with currentTime: CMTime, duration: CMTime) {
        playerDisplayView.updatePlaybackTime(currentTime: currentTime, duration: duration)
    }
    
    /// 隐藏视频帧视图
    public func hideVideoPlayerDisplay() {
        playerDisplayView.isHidden = true
    }
    
    /// 更新内容模式
    /// - Parameter isLandscape: 是否横屏
    public func updateContentModeInSystemControls(isLandscape: Bool) {
        playerDisplayView.updateContentMode(isLandscape: isLandscape)
    }
}

// MARK: - Setup Initializer

extension ARTVideoPlayerSystemControls {
    
    /// 设置视频帧图片视图
    private func setupVideoPlayerDisplay() {
        playerDisplayView = ARTVideoPlayerDisplayView()
        addSubview(playerDisplayView)
        playerDisplayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
