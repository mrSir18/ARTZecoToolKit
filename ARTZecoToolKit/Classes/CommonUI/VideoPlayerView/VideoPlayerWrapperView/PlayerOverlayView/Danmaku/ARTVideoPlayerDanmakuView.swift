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
    public var danmakuTrack: Int = 0
    
    
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
        
        // 轨道数变更判断：如果轨道数不一致，更新轨道数
        if danmakuTrack != danmakuCell.danmakuTrack {
            updateDanmakuTrack(danmakuCell.danmakuTrack,
                               withSpacing: danmakuCell.danmakuTrackSpacing)
        }
        
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

    /// 查找可以发送弹幕的轨道索引
    ///
    /// - Parameter newDanmaku: 待发送的弹幕单元
    /// - Returns: 可用轨道的索引；如果没有可用轨道，返回 -1
    @objc open func findAvailableTrackForNextDanmaku(_ newDanmaku: ARTVideoPlayerDanmakuCell) -> Int {
        return danmakuCells.enumerated().first { index, lastDanmaku in
            if let lastDanmaku = lastDanmaku { // 如果当前轨道已有弹幕，检查新弹幕是否可以插入
                return canDisplayNextDanmaku(after: lastDanmaku, with: newDanmaku)
            }
            // 如果当前轨道为空，允许插入新弹幕
            return true
        }?.offset ?? -1 // 如果没有找到可用轨道，返回 -1
    }
    
    /// 判断新的弹幕是否可以在同一轨道中发送
    ///
    /// - Parameters:
    ///   - lastDanmakuCell: 当前轨道上最后一条弹幕单元
    ///   - nextDanmakuCell: 待发送的弹幕单元
    /// - Returns: 如果可以发送，返回 true；否则返回 false
    @objc open func canDisplayNextDanmaku(after lastDanmakuCell: ARTVideoPlayerDanmakuCell, with nextDanmakuCell: ARTVideoPlayerDanmakuCell) -> Bool {
        guard let currentFrame = lastDanmakuCell.layer.presentation()?.frame else { return false }

        let screenWidth = self.frame.size.width
        let lastDanmakuWidth = lastDanmakuCell.frame.size.width
        let nextDanmakuWidth = nextDanmakuCell.frame.size.width
        let lastDanmakuSpeed = lastDanmakuCell.danmakuSpeed
        let nextDanmakuSpeed = nextDanmakuCell.danmakuSpeed

        // 如果当前弹幕未完全显示，或者是刚刚添加的控件（frame 为 0），不允许显示
        if currentFrame.origin.x > screenWidth - lastDanmakuWidth || currentFrame.size.width == 0 {
            return false
        }

        // 如果弹幕速度相同且当前弹幕宽度大于下一个弹幕，允许显示
        if lastDanmakuSpeed == nextDanmakuSpeed && lastDanmakuWidth > nextDanmakuWidth {
            return true
        }

        // 计算新弹幕显示时间，若上一条弹幕完全消失，则允许显示
        let displayTime = screenWidth / (screenWidth + nextDanmakuWidth) * nextDanmakuSpeed
        let lastDanmakuFinalX = currentFrame.origin.x - (displayTime / lastDanmakuSpeed) * (screenWidth + lastDanmakuWidth)

        return lastDanmakuFinalX < -lastDanmakuWidth
    }
}

// MARK: - Private Methods

extension ARTVideoPlayerDanmakuView {
    
    /// 更新弹幕轨道设置
    ///
    /// - Parameters:
    ///  - track: 轨道数量
    ///  - spacing: 轨道间距
    private func updateDanmakuTrack(_ track: Int, withSpacing spacing: CGFloat) {
        danmakuTrack = track
        danmakuTrackSpacing = spacing
        changeDanmakuTrack(track) // 更新轨道数
    }
    
    /// 计算弹幕的 Y 坐标
    ///
    /// - Parameters:
    ///   - trackIndex: 轨道索引
    ///   - danmakuCell: 弹幕单元
    /// - Returns: 计算后的 Y 坐标
    private func calculateDanmakuYPosition(for trackIndex: Int, with danmakuCell: ARTVideoPlayerDanmakuCell) -> CGFloat {
        guard trackIndex > 0, let previousDanmaku = danmakuCells[trackIndex - 1] else {
            return CGFloat(trackIndex) * (danmakuCell.frame.height + danmakuTrackSpacing) // 如果是第一个轨道，Y 坐标从 0 开始
        }
        return previousDanmaku.frame.maxY + danmakuCell.danmakuTrackSpacing // 上一条弹幕底部加上间隔
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
    @objc open func insertDanmaku(_ danmakuCells: [ARTVideoPlayerDanmakuCell], at index: NSNumber? = nil, completion: ((Bool) -> Void)? = nil) {
        // 如果没有提供 index，则默认插入到最后
        let insertIndex = index?.intValue ?? danmakuDataSource.count
        guard insertIndex >= 0 && insertIndex <= danmakuDataSource.count else { // 检查插入位置是否有效
            completion?(false)
            return
        }
        
        danmakuDataSource.insert(contentsOf: danmakuCells, at: insertIndex)
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
        guard track >= 0 else { return }
        if track > danmakuCells.count { // 如果新的轨道数大于当前轨道数，添加新轨道
            danmakuCells.append(contentsOf: Array(repeating: nil, count: track - danmakuCells.count))
        } else if track < danmakuCells.count { // 如果新的轨道数小于当前轨道数，移除多余轨道
            danmakuCells.removeSubrange(track..<danmakuCells.count)
        }
    }
}
