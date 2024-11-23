//
//  ARTVideoPlayerDanmakuCell.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/11/9.
//

open class ARTVideoPlayerDanmakuCell: UIView {

    // MARK: - Public Properties
    
    /// 弹幕尺寸
    public var danmakuSize: CGSize = .zero
    
    /// 弹幕轨道数 默认4
    public var danmakuTrack: Int = 4
    
    /// 弹幕速度
    public var danmakuSpeed: CGFloat = 3.0
    
    /// 弹幕轨道间距 默认12
    public var danmakuTrackSpacing: CGFloat = 12.0
    
    /// 弹幕延迟启动时间
    public var danmakuDelayTime: TimeInterval = 0.0
    
    /// 弹幕延迟退出时间
    public var danmakuDuration: TimeInterval = 0.0
    
    
    // MARK: Private Properties
    
    /// 弹幕计时器
    private var danmakuTimer: Timer?
    
    /// 弹幕是否延迟退出
    private var isDelayExit: Bool = false
    
    
    // MARK: - Initializer
    
    public init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Super Methods
    
    open func setupViews() {
        
    }
}

// MARK: - Public Methods

extension ARTVideoPlayerDanmakuCell {
    
    /// 开始弹幕动画
    ///
    /// - Parameters:
    ///  - animations: 动画
    ///  - completion: 完成回调
    @objc open func startDanmakuAnimation(animations: (() -> Void)?, completion: ((Bool) -> Void)?) {
        startDanmaku()
        UIView.animate(withDuration: danmakuSpeed, delay: danmakuDelayTime, options: [.curveLinear, .allowUserInteraction] , animations: {
            animations?()
        }) { (finished) in
            completion?(finished)
            self.stopDanmaku()
        }
    }
    
    /// 弹幕计时器事件
    @objc open func danmakuTimerAction() {
        guard let presentationLayer = self.layer.presentation() else { return }
        let rangeLimit: CGFloat = 0.5
        let danmakuX = presentationLayer.frame.origin.x
        let danmakuWidth = frame.size.width
        let superWidth = superview?.frame.size.width ?? 0
        let speed = (danmakuWidth + superWidth) / danmakuSpeed
        let beginTime = danmakuWidth / speed
        let isBarrageXInRange = (-rangeLimit..<rangeLimit).contains(danmakuX)
        if isBarrageXInRange && !isDelayExit {
            isDelayExit = true
            pauseDanmaku()
            perform(#selector(resumeDanmaku), with: nil, afterDelay: danmakuDuration)
        }
    }
    
    /// 开始弹幕
    @objc open func startDanmaku() {
        guard danmakuDuration > 0, danmakuTimer == nil else { return }
        danmakuTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.danmakuTimerAction()
        }
        RunLoop.current.add(danmakuTimer!, forMode: .common)
    }
    
    /// 暂停弹幕
    @objc open func pauseDanmaku() {
        guard layer.speed != 0 else { return } // 确保当前未暂停
        layer.timeOffset = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
    }
    
    /// 恢复弹幕
    @objc open func resumeDanmaku() {
        guard layer.speed == 0 else { return } // 确保当前已暂停
        layer.beginTime = CACurrentMediaTime() - layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
    }
    
    /// 停止弹幕
    @objc open func stopDanmaku() {
        danmakuTimer?.invalidate()
        danmakuTimer = nil
    }
}
