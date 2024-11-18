//
//  ARTVideoPlayerDanmakuView.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/11/8.
//

// 协议方法
//
// - NOTE: 可继承该协议方法，实现自定义的弹幕视图
@objc public protocol ARTVideoPlayerDanmakuViewDelegate: AnyObject {
    
    /// 点击弹幕事件回调
    @objc optional func danmakuView(_ danmakuView: ARTVideoPlayerDanmakuView, didClickDanmakuCell danmakuCell: ARTVideoPlayerDanmakuCell)
    
    /// 弹幕即将显示回调
    @objc optional func danmakuView(_ danmakuView: ARTVideoPlayerDanmakuView, willDisplayDanmakuCell danmakuCell: ARTVideoPlayerDanmakuCell)
    
    /// 弹幕显示完成回调
    @objc optional func danmakuView(_ danmakuView: ARTVideoPlayerDanmakuView, didEndDisplayDanmakuCell danmakuCell: ARTVideoPlayerDanmakuCell)
    
    /// 所有弹幕显示完成回调
    @objc optional func danmakuViewDidEndDisplayAllDanmaku(_ danmakuView: ARTVideoPlayerDanmakuView)
}

open class ARTVideoPlayerDanmakuView: UIView {
    
    /// 代理对象
    public weak var delegate: ARTVideoPlayerDanmakuViewDelegate?
    
    /// 弹幕数据源
    private var danmakuDataSource: [ARTVideoPlayerDanmakuCell] = []
    
    /// 正在展示的弹幕
    private var displayingDanmakuCells: [ARTVideoPlayerDanmakuCell?] = []
    
    /// 弹幕单元
    private var danmakuCells: [ARTVideoPlayerDanmakuCell?] = []
    
    /// 剩余未展示弹幕数量
    private var remainingDanmakuCount: Int = 0
    
    /// 弹幕轨道间距
    public var danmakuTrackSpacing: CGFloat = 0.0
    
    /// 弹幕轨道数 默认4
    public var danmakuTrack: Int = 4
    
    
    // MARK: - Initialization
    
    public init(_ delegate: ARTVideoPlayerDanmakuViewDelegate? = nil) {
        super.init(frame: .zero)
        self.backgroundColor = .art_randomColor()
        self.delegate = delegate
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Views
    
    /// 重写父类方法，设置子视图
    ///
    /// - Note: 由于子类需要自定义视图，所以需要重写该方法
    open func setupViews() {
        
    }
    
    /// 创建弹幕
    @objc open func createDanmaku() {
        // 递归调用，确保持续运行，间隔0.25秒
        defer { perform(#selector(createDanmaku), with: nil, afterDelay: 0.25) }
        
        // 确保数据源中有弹幕
        guard let danmakuCell = danmakuDataSource.first else { return }
        
        danmakuCell.frame = CGRect(x: self.frame.size.width,
                                   y:0.0,
                                   width: danmakuCell.danmakuSize.width,
                                   height: danmakuCell.danmakuSize.height)
        
        // 根据弹幕单元动态设置轨道间距和轨道数
        danmakuTrackSpacing = danmakuCell.danmakuTrackSpacing
        changeDanmakuTrack(danmakuCell.danmakuTrack)
        
        // 获取可用的轨道索引，并判断是否有效
        let trackIndex = findAvailableTrackForNextDanmaku(danmakuCell)
        guard trackIndex >= 0 else { return } // 无可用轨道，返回
        
        // 从数据源中移除当前弹幕
        danmakuDataSource.removeFirst()
        
        // 计算弹幕的初始位置，确定 Y 坐标
        let initialY = calculateDanmakuYPosition(for: trackIndex, with: danmakuCell)
        
        // 设置弹幕初始位置
        danmakuCell.frame = CGRect(x: self.bounds.width,
                                   y: initialY,
                                   width: danmakuCell.danmakuSize.width,
                                   height: danmakuCell.danmakuSize.height)
        
        // 添加弹幕到视图，并更新轨道信息
        if !self.subviews.contains(danmakuCell) {
            self.addSubview(danmakuCell)
        }
        danmakuCells[trackIndex] = danmakuCell // 更新当前轨道的弹幕
        
        // 通知代理弹幕即将显示
        delegate?.danmakuView?(self, willDisplayDanmakuCell: danmakuCell)
        
        // 正在展示的弹幕
        displayingDanmakuCells.append(danmakuCell)
        
        // 开始弹幕动画
        danmakuCell.startDanmakuAnimation { // 动画逻辑：从右侧飞入，向左侧飞出
            danmakuCell.transform = CGAffineTransform(translationX: -danmakuCell.frame.width - self.frame.size.width, y: 0)
        } completion: { [weak self] finished in
            guard let self = self else { return }
            self.handleDanmakuAnimationCompletion(for: danmakuCell, in: trackIndex)
        }
    }
    
    /// 查找可以发送弹幕的轨道
    ///
    /// - Parameter newDanmaku: 新的弹幕单元
    /// - Returns: 可用轨道的索引，如果没有可用轨道返回 -1
    @objc open func findAvailableTrackForNextDanmaku(_ newDanmaku: ARTVideoPlayerDanmakuCell) -> Int {
        for (index, lastDanmaku) in danmakuCells.enumerated() {
            if lastDanmaku == nil { return index } // 判断轨道是否为空
            if let lastDanmaku = lastDanmaku, canDisplayNextDanmaku(after: lastDanmaku, with: newDanmaku) { return index } // 如果轨道有弹幕，判断是否可以显示新的弹幕
        }
        return -1 // 如果没有可用轨道
    }
    
    /// 判断新的弹幕是否可以在同一轨道中发送
    ///
    /// - Parameters:
    ///   - lastDanmakuCell: 当前轨道上最后一条弹幕单元
    ///   - nextDanmakuCell: 待发送的弹幕单元
    /// - Returns: 如果可以发送，返回 true；否则返回 false
    @objc open func canDisplayNextDanmaku(after lastDanmakuCell: ARTVideoPlayerDanmakuCell, with nextDanmakuCell: ARTVideoPlayerDanmakuCell) -> Bool {
        guard let currentFrame = lastDanmakuCell.layer.presentation()?.frame else { // 获取动画中弹幕的 frame
            return false
        }
        
        if currentFrame.origin.x > self.frame.size.width - lastDanmakuCell.frame.size.width { // 当前弹幕未完全显示在屏幕中，不允许发送
            return false
        } else if currentFrame.size.width == 0 { // 刚刚添加的控件，可能 frame 值全为 0，也不允许发送
            return false
        } else if lastDanmakuCell.danmakuSpeed == nextDanmakuCell.danmakuSpeed &&
                    lastDanmakuCell.frame.size.width > nextDanmakuCell.frame.size.width { // 比较弹幕的宽度（速度），新弹幕宽度小则永远追不上，允许发送
            return true
        } else { // 计算新弹幕从出现到屏幕左侧的时间
            let displayTime = self.frame.size.width / (self.frame.size.width + nextDanmakuCell.frame.size.width) * nextDanmakuCell.danmakuSpeed
            
            // 计算此时上一条弹幕的最终 x 坐标
            let lastDanmakuFinalX = currentFrame.origin.x - (displayTime / lastDanmakuCell.danmakuSpeed) * (self.frame.size.width + lastDanmakuCell.frame.size.width)
            
            if lastDanmakuFinalX < -lastDanmakuCell.frame.size.width { // 如果上一条弹幕完全从屏幕中消失，允许发送
                return true
            }
        }
        return false
    }
}

// MARK: - Private Methods

extension ARTVideoPlayerDanmakuView {
    
    /// 计算弹幕的 Y 坐标
    ///
    /// - Parameters:
    ///   - trackIndex: 轨道索引
    ///   - danmakuCell: 弹幕单元
    /// - Returns: 计算后的 Y 坐标
    private func calculateDanmakuYPosition(for trackIndex: Int, with danmakuCell: ARTVideoPlayerDanmakuCell) -> CGFloat {
        if trackIndex == 0 { return 0 } // 如果是第一个轨道，Y 坐标从 0 开始
        if let previousDanmaku = danmakuCells[trackIndex - 1] { // 当前弹幕的位置是上一条弹幕底部加上间隔
            return previousDanmaku.frame.maxY + danmakuCell.danmakuTrackSpacing
        }
        return CGFloat(trackIndex) * (danmakuCell.frame.height + danmakuTrackSpacing)
    }
    
    /// 动画完成后的处理
    ///
    /// - Parameters:
    ///   - danmakuCell: 弹幕单元
    ///   - trackIndex: 所在轨道
    private func handleDanmakuAnimationCompletion(for danmakuCell: ARTVideoPlayerDanmakuCell, in trackIndex: Int) {
        danmakuCell.removeFromSuperview()
        displayingDanmakuCells.removeAll { $0 === danmakuCell }
        remainingDanmakuCount -= 1
        
        // 通知代理：单条弹幕完成
        delegate?.danmakuView?(self, didEndDisplayDanmakuCell: danmakuCell)
        if remainingDanmakuCount == 0 && displayingDanmakuCells.isEmpty { // 检查是否所有弹幕已完成
            delegate?.danmakuViewDidEndDisplayAllDanmaku?(self)
        }
    }
}

// MARK: - Public Methods

extension ARTVideoPlayerDanmakuView {
    
    /// 插入弹幕
    ///
    /// - Parameters:
    ///  - danmakuCell: 弹幕单元
    ///  - at: 插入位置
    ///  - completion: 完成回调
    @objc open func insertDanmaku(_ danmakuCells: [ARTVideoPlayerDanmakuCell], at index: Int, completion: ((Bool) -> Void)?) {
        guard index >= 0 && index <= danmakuDataSource.count else {
            completion?(false)
            return
        }
        danmakuDataSource.insert(contentsOf: danmakuCells, at: index)
        remainingDanmakuCount += danmakuCells.count
        completion?(true)
    }
    
    /// 开始弹幕
    @objc open func startDanmaku() {
        createDanmaku()
    }
    
    /// 暂停弹幕
    @objc open func pauseDanmaku() {
        
    }
    
    /// 恢复弹幕
    @objc open func resumeDanmaku() {
        
    }
    
    /// 停止弹幕
    @objc open func stopDanmaku() {
        
    }
    
    /// 更改弹幕轨道数量
    /// - Parameter track: 新的轨道数量
    @objc open func changeDanmakuTrack(_ track: Int) {
        guard track >= 0 else { return } // 防止轨道数为负数
        danmakuTrack = track
        if danmakuCells.count < track {
            danmakuCells = Array(repeating: nil, count: danmakuTrack)
        } else {
            danmakuCells.removeLast(danmakuCells.count - track)
        }
    }
}
