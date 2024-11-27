//
//  ARTDanmakuView.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/11/27.
//

// 协议方法
//
// - NOTE: 可继承该协议方法，实现自定义的弹幕视图
@objc public protocol ARTDanmakuViewDelegate: AnyObject {
    
    /// 创建弹幕回调
    @objc optional func danmakuViewCreateCell(_ danmakuView: ARTDanmakuView) -> ARTDanmakuCell
    
    /// 点击弹幕事件回调
    @objc optional func danmakuView(_ danmakuView: ARTDanmakuView, didClickDanmakuCell danmakuCell: ARTDanmakuCell)
    
    /// 弹幕即将显示回调
    @objc optional func danmakuView(_ danmakuView: ARTDanmakuView, willDisplayDanmakuCell danmakuCell: ARTDanmakuCell)
    
    /// 弹幕显示完成回调
    @objc optional func danmakuView(_ danmakuView: ARTDanmakuView, didEndDisplayDanmakuCell danmakuCell: ARTDanmakuCell)
    
    /// 所有弹幕显示完成回调
    @objc optional func danmakuViewDidEndDisplayAllDanmaku(_ danmakuView: ARTDanmakuView)
}

// MARK: - Enum & Class

extension ARTDanmakuView {
    
    /// 弹幕状态枚举
    public enum DanmakuState {
        case idle      // 未启动
        case running   // 正在运行
        case paused    // 暂停中
        case stopped   // 已停止
    }
    
    /// 弹幕速度等级枚举
    public enum SpeedLevel: Int, CaseIterable {
        case extremelyFast      = 1 // 极快
        case fast               = 2 // 快速
        case moderate           = 3 // 适中
        case slow               = 4 // 慢速
        case extremelySlow      = 5 // 极慢
        
        func randomDuration() -> CGFloat {
            switch self {
            case .extremelyFast:
                return CGFloat.random(in: 4...6)
            case .fast:
                return CGFloat.random(in: 6...8)
            case .moderate:
                return CGFloat.random(in: 8...10)
            case .slow:
                return CGFloat.random(in: 10...12)
            case .extremelySlow:
                return CGFloat.random(in: 12...15)
            }
        }
    }
}

// MARK: - ARTDanmakuView

/// 标识弹幕动画 key
private let kDanmakuAnimationKey = "danmakuAnimation"

/// 关联的弹幕单元 key
private let kAssociatedDanmakuCellKey = "associatedDanmakuCell"

public class ARTDanmakuView: UIView {
    
    /// 代理对象
    public weak var delegate: ARTDanmakuViewDelegate?
    
    /// 弹幕轨道数量 默认4
    public var danmakuTrackCount: Int = 4
    
    /// 弹幕透明度 默认1.0
    public var danmakuAlpha: CGFloat = 1.0
    
    /// 弹幕移动速度 默认适中
    public var danmakuSpeed: SpeedLevel = .moderate
    
    /// 弹幕轨道高度 默认30.0
    public var danmakuTrackHeight: CGFloat = 30.0
    
    /// 弹幕轨道间距 默认12.0
    public var danmakuTrackSpacing: CGFloat = 12.0
    
    /// 存储弹幕轨道坐标
    public var danmakuTrackYs: [CGFloat] = []
    
    /// 存储弹幕最近使用时间
    public var danmakuLastTimes: [TimeInterval] = []
    
    /// 生成弹幕间隔时间
    public var danmakuTimer: Timer?
    
    /// 弹幕延迟启动定时器
    public var danmakuDelayTimer: Timer?
    
    /// 弹幕延迟启动时间 默认0.0
    public var danmakuDelayTime: TimeInterval = 0.0
    
    /// 弹幕延迟退出时间 默认0.0
    public var danmakuDuration: TimeInterval = 0.0
    
    /// 弹幕最小间隔时间 默认0.1
    public var danmakuMinimumInterval: TimeInterval = 0.1
    
    /// 弹幕安全间隔 默认12.0
    public var danmakuSafeSpacing: CGFloat = 12.0
    
    /// 当前弹幕状态
    public var danmakuState: DanmakuState = .idle
    
    /// 弹幕锁 用于线程安全 保证弹幕不会重叠
    public var danmakuLock = DispatchSemaphore(value: 1)
    
    
    // MARK: - Initialization
    
    public init(_ delegate: ARTDanmakuViewDelegate? = nil) {
        super.init(frame: .zero)
        self.clipsToBounds = true
        self.delegate = delegate
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Super Methods
    
    override public func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if newWindow == nil { stopDanmaku() } // 离开当前窗口时停止弹幕
    }
    
    open func setupViews() {
        /// 子类重写: 设置视图
    }
}

// MARK: 创建弹幕

extension ARTDanmakuView {
    
    /// 创建弹幕
    private func createDanmaku() {
        danmakuLock.wait()
        defer { danmakuLock.signal() } // 释放信号量
        
        // 调用代理方法获取弹幕单元
        guard let danmakuCell = delegate?.danmakuViewCreateCell?(self) else { return }
        
        let randomDuration = danmakuSpeed.randomDuration()
        guard let (startY, trackIndex) = findAvailableTrack(for: danmakuCell, duration: randomDuration) else { return } // 查找可用轨道
        
        // 配置弹幕单元
        configureDanmakuCell(danmakuCell, at: startY, on: trackIndex, duration: randomDuration)
        animateDanmaku(danmakuCell, duration: randomDuration)
    }
    
    /// 配置弹幕单元的初始属性
    ///
    /// - Parameters:
    ///  - cell: 弹幕单元
    ///  - y: 弹幕轨道的起始位置
    ///  - trackIndex: 弹幕轨道编号
    ///  - duration: 弹幕持续时间
    private func configureDanmakuCell(_ cell: ARTDanmakuCell, at y: CGFloat, on trackIndex: Int, duration: CGFloat) {
        cell.frame = CGRect(x: bounds.width, y: y, width: cell.danmakuSize.width, height: cell.danmakuSize.height)
        cell.alpha = danmakuAlpha // 设置透明度
        cell.tag   = trackIndex // 标记轨道编号
        addSubview(cell)
        danmakuLastTimes[trackIndex] = Date().timeIntervalSince1970
    }
    
    /// 为弹幕单元添加动画
    private func animateDanmaku(_ cell: ARTDanmakuCell, duration: CGFloat) {
        let animation = CABasicAnimation(keyPath: "position.x")
        animation.delegate              = self
        animation.fromValue             = bounds.width + cell.danmakuSize.width // 从右侧屏幕外开始
        animation.toValue               = -cell.danmakuSize.width // 移动到左侧屏幕外
        animation.duration              = duration // 使用随机持续时间
        animation.timingFunction        = CAMediaTimingFunction(name: .linear) // 线性动画
        animation.isRemovedOnCompletion = true // 动画完成后移除
        animation.setValue(cell, forKey: kAssociatedDanmakuCellKey) // 绑定弹幕单元
        cell.layer.add(animation, forKey: kDanmakuAnimationKey) // 添加动画到弹幕单元的 layer
    }
    
    // MARK: 轨道相关方法
    
    /// 查找可用轨道
    private func findAvailableTrack(for cell: ARTDanmakuCell, duration: CGFloat) -> (CGFloat, Int)? {
        let currentTime = Date().timeIntervalSince1970
        for (index, lastUsedTime) in danmakuLastTimes.enumerated() {
            guard currentTime - lastUsedTime >= danmakuMinimumInterval,
                  isTrackSuitable(for: cell, on: index, duration: duration) else {
                continue
            }
            return (danmakuTrackYs[index], index)
        }
        return nil
    }
    
    /// 判断轨道是否适合
    ///
    /// - Parameters:
    ///  - cell: 弹幕单元
    ///  - index: 轨道编号
    ///  - duration: 弹幕持续时间
    private func isTrackSuitable(for cell: ARTDanmakuCell, on index: Int, duration: CGFloat) -> Bool {
        return isNoCollisionInTrack(for: cell, on: index, duration: duration)
    }
    
    /// 判断轨道中是否没有碰撞
    private func isNoCollisionInTrack(for cell: ARTDanmakuCell, on trackIndex: Int, duration: CGFloat) -> Bool {
        guard let lastDanmakuCell = findLastDanmakuInTrack(trackIndex) else { return true } // 当前轨道没有弹幕，直接适合
        
        let lastFrame = lastDanmakuCell.layer.presentation()?.frame ?? lastDanmakuCell.frame
        let lastAnimationDuration = lastDanmakuCell.layer.animation(forKey: kDanmakuAnimationKey)?.duration ?? 1.0
        
        let lastRemainingTime = calculateRemainingTime(for: lastFrame, animationDuration: lastAnimationDuration) // 计算剩余时间
        let distance = bounds.width - lastFrame.maxX - danmakuSafeSpacing // 距离加一个安全间隔
        guard distance >= 0 else { return false } // 距离小于 0，说明前一个弹幕刚刚发送
        
        let relativeSpeed = calculateRelativeSpeed(newWidth: cell.danmakuSize.width, duration: duration, lastWidth: lastFrame.width, lastDuration: lastAnimationDuration) // 计算相对速度
        return !willCollide(relativeSpeed: relativeSpeed, remainingDistance: distance, remainingTime: lastRemainingTime) // 判断是否会碰撞
    }
    
    /// 找到轨道中的最后一个弹幕
    private func findLastDanmakuInTrack(_ trackIndex: Int) -> ARTDanmakuCell? {
        subviews
            .compactMap { $0 as? ARTDanmakuCell }
            .filter { $0.tag == trackIndex }
            .last
    }
    
    /// 计算弹幕剩余时间
    private func calculateRemainingTime(for frame: CGRect, animationDuration: CGFloat) -> CGFloat {
        let remainingRatio = max(frame.maxX, 0) / (bounds.width + frame.width)
        return animationDuration * remainingRatio
    }
    
    /// 计算相对速度
    private func calculateRelativeSpeed(newWidth: CGFloat, duration: CGFloat, lastWidth: CGFloat, lastDuration: CGFloat) -> CGFloat {
        let newSpeed = (bounds.width + newWidth) / duration
        let lastSpeed = (bounds.width + lastWidth) / lastDuration
        return newSpeed - lastSpeed
    }
    
    /// 判断是否会碰撞
    private func willCollide(relativeSpeed: CGFloat, remainingDistance: CGFloat, remainingTime: CGFloat) -> Bool {
        guard relativeSpeed > 0 else { return false } // 如果新弹幕速度更慢，不会追上
        let catchUpTime = remainingDistance / relativeSpeed
        return catchUpTime < remainingTime
    }
}

// MARK: - Private Methods

extension ARTDanmakuView {
    
    /// 配置弹幕轨道
    private func configureDanmakuTracks() {
        danmakuTrackYs = (0..<danmakuTrackCount).map { // 重新生成轨道起始位置
            CGFloat($0) * (danmakuTrackHeight + danmakuTrackSpacing)
        }
        
        danmakuLastTimes = (0..<danmakuTrackCount).map { index in // 调整最近使用时间数组的大小
            index < danmakuLastTimes.count ? danmakuLastTimes[index] : 0
        }
    }
    
    /// 开启主弹幕定时器
    private func startMainDanmakuTimer() {
        danmakuTimer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { [weak self] _ in
            self?.createDanmaku()
        }
        if let danmakuTimer = danmakuTimer { RunLoop.current.add(danmakuTimer, forMode: .common) }
    }
    
    /// 更新状态
    ///
    /// - Parameters:
    ///   - newState: 新状态
    ///   - allowedCurrentStates: 允许的当前状态
    /// - Returns: 是否成功更新状态
    private func attemptStateTransition(to newState: DanmakuState, from allowedCurrentStates: [DanmakuState]) -> Bool {
        guard allowedCurrentStates.contains(danmakuState) else { return false }
        danmakuState = newState
        return true
    }
    
    /// 清理无效的弹幕
    ///
    /// 该方法会移除所有超出当前轨道数量的弹幕，并停止它们的动画。
    private func clearOutdatedDanmaku() {
        clearDanmaku { $0.tag >= self.danmakuTrackCount } // 过滤出不再有效的弹幕
    }
    
    /// 清理所有弹幕单元
    private func clearAllDanmaku() {
        clearDanmaku()
    }
    
    /// 清理指定条件的弹幕单元
    private func clearDanmaku(where condition: ((ARTDanmakuCell) -> Bool)? = nil) {
        subviews
            .compactMap { $0 as? ARTDanmakuCell }
            .filter { condition?($0) ?? true } // 若无条件，则清理所有
            .forEach {
                $0.layer.removeAllAnimations()
                $0.removeFromSuperview()
            }
    }

    /// 重置CACurrentMediaTime
    private func resetAnimationLayer(beginTime: TimeInterval = 0.0)  {
        layer.beginTime = beginTime
        layer.timeOffset = 0.0
        layer.speed = 1.0
    }
}

// MARK: - Public Methods

extension ARTDanmakuView {
    
    /// 开始弹幕
    @objc open func startDanmaku() {
        guard attemptStateTransition(to: .running, from: [.idle, .stopped]), danmakuTimer == nil else { return } // 仅允许在空闲或停止状态下启动
        configureDanmakuTracks() // 配置弹幕轨道
        danmakuDelayTimer = Timer.scheduledTimer(withTimeInterval: danmakuDelayTime, repeats: false) { [weak self] _ in // 延迟启动
            self?.startMainDanmakuTimer()
        }
        if let danmakuDelayTimer = danmakuDelayTimer { RunLoop.current.add(danmakuDelayTimer, forMode: .common) }
    }
    
    /// 暂停弹幕
    @objc open func pauseDanmaku() {
        guard attemptStateTransition(to: .paused, from: [.running]), layer.speed != 0 else { return } // 仅允许在运行状态下暂停
        layer.timeOffset = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
    }
    
    /// 恢复弹幕
    @objc open func resumeDanmaku() {
        guard attemptStateTransition(to: .running, from: [.paused]), layer.speed == 0 else { return } // 仅允许在暂停状态下恢复
        resetAnimationLayer(beginTime: CACurrentMediaTime() - layer.timeOffset)
    }
    
    /// 停止弹幕
    @objc open func stopDanmaku() {
        guard attemptStateTransition(to: .stopped, from: [.running, .paused]) else { return } // 仅允许在运行或暂停状态下停止
        danmakuDelayTimer?.invalidate()
        danmakuDelayTimer = nil
        danmakuTimer?.invalidate()
        danmakuTimer = nil
        resetAnimationLayer() // 重置动画
        clearAllDanmaku() // 清理所有弹幕
        danmakuTrackYs = [] // 清空轨道坐标
        danmakuLastTimes = [] // 清空最近使用时间
    }
    
    /// 更新弹幕轨道数量
    /// - Parameter count: 弹幕轨道的数量
    /// - NOTE: 轨道数量必须大于等于 0
    public func updateDanmakuTrackCount(_ count: Int) {
        danmakuTrackCount = max(0, count) // 确保轨道数量非负
        configureDanmakuTracks() // 重新配置轨道
        clearOutdatedDanmaku() // 清理多余的弹幕
    }
    
    /// 更新弹幕透明度
    /// - Parameter alpha: 弹幕透明度
    /// - NOTE: 透明度限制在 0 到 1 之间
    public func updateDanmakuAlpha(_ alpha: CGFloat) {
        danmakuAlpha = max(0.0, min(1.0, alpha)) // 限制在 0 到 1 之间
        for case let cell as ARTDanmakuCell in subviews { cell.alpha = alpha } // 更新当前显示的弹幕透明度
    }
    
    /// 更新弹幕速度
    /// - Parameter speed: 弹幕速度等级
    /// - NOTE: 速度等级越小，速度越快
    public func updateDanmakuSpeed(_ level: SpeedLevel) {
        danmakuSpeed = level
    }
    
    /// 更新弹幕大小
    /// - Parameter size: 弹幕大小比例
    /// - NOTE: 1.0 为原始大小
    public func updateDanmakuSize(_ size: CGFloat) {
        for case let cell as ARTDanmakuCell in subviews {
            cell.danmakuSize = cell.danmakuSize.applying(CGAffineTransform(scaleX: size, y: size))
        }
    }
}

// MARK: - CAAnimationDelegate

extension ARTDanmakuView: CAAnimationDelegate {
    
    /// 动画开始回调
    public func animationDidStart(_ anim: CAAnimation) {
        guard let cell = anim.value(forKey: kAssociatedDanmakuCellKey) as? ARTDanmakuCell else { return }
        delegate?.danmakuView?(self, willDisplayDanmakuCell: cell)
    }
    
    /// 动画结束回调
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard flag else { return }
        guard let cell = anim.value(forKey: kAssociatedDanmakuCellKey) as? ARTDanmakuCell else { return }
        delegate?.danmakuView?(self, didEndDisplayDanmakuCell: cell)
        cell.layer.removeAllAnimations()
        cell.removeFromSuperview()
    }
}

// MARK: - Touch Events

extension ARTDanmakuView {
    
    /// 触摸结束事件
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchPoint = touches.first?.location(in: self) else { return } // 确保获取到触摸点
        for case let cell as ARTDanmakuCell in subviews { // 遍历所有子视图，找到触碰到的弹幕单元
            let cellFrame = cell.layer.presentation()?.frame ?? cell.frame
            if cellFrame.contains(touchPoint) {
                delegate?.danmakuView?(self, didClickDanmakuCell: cell)
                return // 触发事件后直接退出，避免重复处理
            }
        }
    }
}
