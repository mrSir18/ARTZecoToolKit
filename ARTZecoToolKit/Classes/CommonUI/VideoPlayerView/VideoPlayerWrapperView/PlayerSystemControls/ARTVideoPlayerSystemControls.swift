//
//  ARTVideoPlayerSystemControls.swift
//  Pods
//
//  Created by mrSir18 on 2024/10/21.
//

import AVFoundation

/// 协议方法
///
/// - NOTE: 可继承该协议方法
public protocol ARTVideoPlayerSystemControlsDelegate: AnyObject {
    
}

open class ARTVideoPlayerSystemControls: UIView {
    
    /// 代理对象
    public weak var delegate: ARTVideoPlayerSystemControlsDelegate?
    
    /// 视频播放显示视图
    private var playerDisplayView: ARTVideoPlayerDisplayView!
    
    
    // MARK: - Initialization
    
    public init(_ delegate: ARTVideoPlayerSystemControlsDelegate? = nil) {
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
        setupVideoPlayerDisplay()
    }
    
    // MARK: - Public Methods
    
    /// 更新预览图片
    ///
    /// - Parameters:
    ///  - previewImage: 视频预览图片
    ///  - Note: 子类重写该方法更新预览图片
    open func updatePreviewImageInSystemControls(previewImage: UIImage?) {
        playerDisplayView.updatePreviewImage(previewImage: previewImage)
    }
    
    /// 更新当前播放时间和总时长
    ///
    /// - Parameters:
    ///   - currentTime: 当前播放时间
    ///   - duration: 视频总时长
    /// - Note: 重写父类方法，更新播放器当前播放时间
    open func updateTimeInSystemControls(with currentTime: CMTime, duration: CMTime) {
        playerDisplayView.updatePlaybackTime(currentTime: currentTime, duration: duration)
    }
    
    /// 隐藏视频帧视图
    ///
    /// - Note: 重写父类方法，隐藏视频帧视图
    open func hideVideoPlayerDisplay() {
        playerDisplayView.isHidden = true
    }
}

// MARK: - Setup Initializer

extension ARTVideoPlayerSystemControls {

    /// 设置视频帧图片视图
    @objc open func setupVideoPlayerDisplay() {
        playerDisplayView = ARTVideoPlayerDisplayView()
        addSubview(playerDisplayView)
        playerDisplayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}