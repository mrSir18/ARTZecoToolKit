//
//  ARTViewController+DanmakuView.swift
//  ARTZecoToolKit_Example
//
//  Created by mrSir18 on 2024/11/19.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import ARTZecoToolKit

enum DanmakuActionType: Int {
    case start
    case add
    case pause
    case resume
    case stop
    case twoTracks
    case fourTracks
    case changeOpacity
    case changeFontSize
}

    
    /// 弹幕速度等级枚举
public enum ASpeedLevel: Int, CaseIterable {
    case extremelyFast      = 1 // 极快
    case fast               = 2 // 快速
    case moderate           = 3 // 适中
    case slow               = 4 // 慢速
    case extremelySlow      = 5 // 极慢
    
    /// 默认值
    public static let defaultLevel: ASpeedLevel = .moderate
    
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

extension ARTViewController_DanmakuView: ARTDanmakuViewDelegate {
    
    func danmakuViewCreateCell(_ danmakuView: ARTDanmakuView) -> ARTDanmakuCell {
        let cell = ARTDanmakuCell()
        cell.backgroundColor = .art_randomColor()
        return cell
    }
}

class ARTViewController_DanmakuView: ARTBaseViewController {
    
    private var trackCount: Int = 4 { // 当前轨道数量
        didSet {
            updateTracks()
            filterVisibleBullets() // 移除超出范围的弹幕
        }
    }
    private var trackYPositions: [CGFloat] = [] // 存储轨道的 Y 坐标
    private var trackLastUsedTimes: [TimeInterval] = [] // 记录每条轨道的最近使用时间
    private var trackPadding: CGFloat = 10 // 轨道间距
    private let trackLock = DispatchSemaphore(value: 1)
    private let speedLevel: ASpeedLevel = .moderate
    
    private var danmakuView: ARTDanmakuView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .art_randomColor()
        setupButtons()
        
        danmakuView = ARTDanmakuView(self)
        danmakuView.backgroundColor = .art_randomColor()
        view.addSubview(danmakuView)
        danmakuView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(art_navigationFullHeight())
            make.height.equalTo(ARTAdaptedValue(180.0))
        }
        danmakuView.startDanmaku()
        
//        // 初始化轨道
//        setupTracks()
//        
//        // 定时生成弹幕
//        Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(sendBullet), userInfo: nil, repeats: true)
    }
    
    // 初始化轨道
    private func setupTracks() {
        updateTracks()
    }
    
    private func updateTracks() {
        let topMargin: CGFloat = 100
        let trackHeight: CGFloat = 30
        
        trackYPositions = (0..<trackCount).map { index in
            topMargin + CGFloat(index) * (trackHeight + trackPadding)
        }
        
        // 动态调整最近使用时间数组的大小
        if trackLastUsedTimes.count > trackCount {
            trackLastUsedTimes = Array(trackLastUsedTimes.prefix(trackCount))
        } else {
            trackLastUsedTimes.append(contentsOf: Array(repeating: 0, count: trackCount - trackLastUsedTimes.count))
        }
    }
    
    @objc func sendBullet() {
        trackLock.wait() // 加锁
        defer { trackLock.signal() } // 解锁
        
        let contents: [String] = [
            "这款产品非常好，使用！",
            "质量很不错。",
            "非常满意的一次购。",
            "非常亮。",
            "收到商品比很高。",
            "给朋友买的，他很喜欢，赞一个！",
            "弹幕 😄 \(arc4random())"
        ]
        let bulletLabel = UILabel()
        bulletLabel.text = contents.randomElement()
        bulletLabel.textColor = .white
        bulletLabel.font = UIFont.systemFont(ofSize: 16)
        bulletLabel.backgroundColor = .art_randomColor()
        bulletLabel.sizeToFit()

        // 设置随机滚动时间（速度）
        let randomDuration = speedLevel.randomDuration()
        print("弹幕速度：\(randomDuration)")
        // 设置初始位置
        let startX = view.bounds.width
        guard let (startY, trackIndex) = selectAvailableTrack(for: bulletLabel, duration: randomDuration) else { return }
        bulletLabel.frame = CGRect(x: startX, y: startY, width: bulletLabel.bounds.width, height: bulletLabel.bounds.height)
        bulletLabel.isUserInteractionEnabled = true
        bulletLabel.tag = trackIndex // 记录标签的轨道编号
        view.addSubview(bulletLabel)
        
        // 更新轨道最后使用时间
        trackLastUsedTimes[trackIndex] = Date().timeIntervalSince1970

        // 创建移动动画
        let animation = CABasicAnimation(keyPath: "position.x")
        animation.fromValue = startX + bulletLabel.bounds.width
        animation.toValue = -bulletLabel.bounds.width
        animation.duration = randomDuration // 使用随机持续时间
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.isRemovedOnCompletion = true
        animation.fillMode = .forwards
        animation.delegate = self
        // 绑定弹幕视图
        animation.setValue(bulletLabel, forKey: "associatedLabel")
        
        // 添加动画到视图的 layer
        bulletLabel.layer.add(animation, forKey: "bulletAnimation")
    }
    
    private func selectAvailableTrack(for bulletLabel: UILabel, duration: Double) -> (CGFloat, Int)? {
        let currentTime = Date().timeIntervalSince1970
        let minInterval: TimeInterval = 0 // 每条轨道间隔的最小时间

        for (index, lastUsedTime) in trackLastUsedTimes.enumerated() {
            // 检查轨道是否足够空闲
            if currentTime - lastUsedTime > minInterval {
                // 确保轨道中没有可能追上的弹幕
                if canShoot(danmaku: bulletLabel, inTrack: index, duration: duration) {
                    return (trackYPositions[index], index)
                }
            }
        }
        return nil
    }

    private func canShoot(danmaku: UILabel, inTrack index: Int, duration: Double) -> Bool {
        guard let lastLabel = view.subviews
                .compactMap({ $0 as? UILabel })
                .filter({ $0.tag == index })
                .last else {
            // 如果当前轨道没有弹幕，直接返回 true
            return true
        }

        // 当前轨道最后一个弹幕的相关数据
        let preFrame = lastLabel.layer.presentation()?.frame ?? lastLabel.frame
        let preWidth = view.bounds.width + preFrame.width
        let preRight = max(preFrame.maxX, 0)
        let preDuration = lastLabel.layer.animation(forKey: "bulletAnimation")?.duration ?? 1.0

        // 新弹幕的相关数据
        let nextWidth = view.bounds.width + danmaku.bounds.width
        let nextDuration = duration // 传入的统一随机持续时间

        // 1. 获取前一个弹幕剩余的运动时间
        let preTimeRemaining = min(preRight / preWidth * preDuration, preDuration)

        // 2. 路程差，减去一个固定安全距离以防止刚好追上
        let distance = view.bounds.width - preRight - 10
        guard distance >= 0 else {
            // 距离小于 0，说明前一个弹幕刚刚发送
            return false
        }

        // 3. 计算速度差
        let preSpeed = preWidth / preDuration
        let nextSpeed = nextWidth / nextDuration
        if nextSpeed - preSpeed <= 0 {
            // 如果新弹幕的速度小于或等于前一个弹幕，永远不会追上
            return true
        }

        // 4. 计算追击时间
        let catchUpTime = distance / (nextSpeed - preSpeed)
        if catchUpTime < preTimeRemaining {
            // 如果追击时间小于前一个弹幕的剩余运动时间，说明会追上
            return false
        }

        return true
    }
    
    func setTrackCount(_ count: Int) {
        guard count > 0 else { return }
        trackCount = count
    }
    
    private func filterVisibleBullets() {
        for subview in view.subviews {
            guard let bulletLabel = subview as? UILabel else { continue }
            
            let trackIndex = Int(bulletLabel.tag)
            if trackIndex >= trackCount {
                bulletLabel.layer.removeAllAnimations()
                bulletLabel.removeFromSuperview()
            }
        }
    }
    
    func updateBulletAlpha(_ alpha: CGFloat) {
//        bulletAlpha = max(0.0, min(1.0, alpha)) // 限制在 0 到 1 之间
        
        // 更新当前显示的弹幕透明度
        for subview in view.subviews {
            guard let bulletLabel = subview as? UILabel else { continue }
            bulletLabel.alpha = alpha
        }
    }
}

extension ARTViewController_DanmakuView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard flag else { return }

        // 获取绑定的 UILabel
        if let bulletLabel = anim.value(forKey: "associatedLabel") as? UILabel {
            // 移除动画和视图
            bulletLabel.layer.removeAllAnimations()
            bulletLabel.removeFromSuperview()
            print("弹幕已移除：\(bulletLabel.text ?? "")")
        }
    }
}

extension ARTViewController_DanmakuView {
    
    /// 触摸事件处理
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        // 获取触摸点位置
        let touchPoint = touch.location(in: view)
        
        // 遍历所有弹幕，检测触摸点是否在标签范围内
        for subview in view.subviews {
            if let label = subview as? UILabel {
                // 获取动画过程中显示的 frame
                let labelFrameInView = label.layer.presentation()?.frame ?? label.frame
                
                // 检查触摸点是否在label的frame内
                if labelFrameInView.contains(touchPoint) {
                    print("点击了弹幕：\(label.text ?? "")")
                    
                    // 点击弹幕时，设置背景颜色为随机颜色
                    label.backgroundColor = .art_randomColor()
                }
            }
        }
    }
}


// MARK: Test Button

extension ARTViewController_DanmakuView {
    
    /// 创建按钮
    private func setupButtons() {
        let buttonsInfo: [(title: String, actionType: DanmakuActionType)] = [
            ("开始弹幕", .start),
            ("添加弹幕", .add),
            ("暂停弹幕", .pause),
            ("继续弹幕", .resume),
            ("结束弹幕", .stop),
            ("2条弹幕", .twoTracks),
            ("4条弹幕", .fourTracks),
            ("透明度",  .changeOpacity),
            ("字体大小", .changeFontSize)
        ]
        
        let maxButtonsPerRow = Int((UIScreen.main.bounds.width - ARTAdaptedValue(48)) / ARTAdaptedValue(80 + 24))
        var rowStackViews: [UIStackView] = []
        var currentRowStack: UIStackView? = nil
        
        for (index, info) in buttonsInfo.enumerated() {
            let button = UIButton(type: .custom)
            button.setTitle(info.title, for: .normal)
            button.backgroundColor = .art_randomColor()
            button.tag = info.actionType.rawValue
            button.addTarget(self, action: #selector(handleButtonTap(_:)), for: .touchUpInside)
            
            if index % maxButtonsPerRow == 0 {
                currentRowStack = UIStackView()
                currentRowStack?.axis = .horizontal
                currentRowStack?.distribution = .fillEqually
                currentRowStack?.alignment = .center
                currentRowStack?.spacing = ARTAdaptedValue(24)
                view.addSubview(currentRowStack!)
                
                currentRowStack?.snp.makeConstraints { make in
                    if let lastRowStack = rowStackViews.last {
                        make.top.equalTo(lastRowStack.snp.bottom).offset(ARTAdaptedValue(24))
                    } else {
                        make.top.equalTo(ARTAdaptedValue(284.0))
                    }
                    make.centerX.equalToSuperview()
                }
                rowStackViews.append(currentRowStack!)
            }
            
            currentRowStack?.addArrangedSubview(button)
            button.snp.makeConstraints { make in
                make.width.height.equalTo(ARTAdaptedValue(90))
            }
        }
    }
    
    @objc private func handleButtonTap(_ sender: UIButton) {
        guard let actionType = DanmakuActionType(rawValue: sender.tag) else { return }
        performAction(for: actionType)
    }
    
    private func performAction(for actionType: DanmakuActionType) {
        switch actionType {
        case .start:
            print("开始弹幕")
        case .add:
            print("添加弹幕")
        case .pause:
            print("暂停弹幕")
        case .resume:
            print("继续弹幕")
        case .stop:
            print("结束弹幕")
        case .twoTracks:
            print("2条弹幕")
            danmakuView.updateDanmakuTrackCount(1)
        case .fourTracks:
            print("4条弹幕")
            danmakuView.updateDanmakuTrackCount(2)
        case .changeOpacity:
            print("透明度")
            danmakuView.updateDanmakuTrackCount(3)
        case .changeFontSize:
            print("字体大小")
            danmakuView.updateDanmakuTrackCount(4)
        }
    }
}
