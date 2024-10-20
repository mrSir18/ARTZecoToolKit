//
//  ARTVideoPlayerBottombar.swift
//  Pods
//
//  Created by mrSir18 on 2024/10/15.
//

/// 协议方法
///
/// - NOTE: 可继承该协议方法
public protocol ARTVideoPlayerBottombarDelegate: AnyObject {
    
}

open class ARTVideoPlayerBottombar: UIView {
    
    /// 代理对象
    public weak var delegate: ARTVideoPlayerBottombarDelegate?
    
    /// 缓冲进度视图
    public var progressView: UIProgressView!
    
    /// 滑块视图
    public var sliderView: ARTVideoPlayerSlider!
    
    
    // MARK: - Initialization
    
    public init(_ delegate: ARTVideoPlayerBottombarDelegate? = nil) {
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
}

extension ARTVideoPlayerBottombar {
    
    /// 更新底部工具栏的当前播放时间和总时长
    ///
    /// - Parameters:
    ///   - currentTime: 当前播放时间字符串
    ///   - duration: 视频总时长字符串
    /// - Note: 重写此方法以更新底部工具栏的当前播放时间和总时长
    @objc open func updatePlaybackTime(currentTime: String, duration: String) {
        print("当前播放时间: \(currentTime)，总时长: \(duration)")
    }
}

