//
//  ARTVideoPlayerOverlayView.swift
//  Pods
//
//  Created by mrSir18 on 2024/10/19.
//

import ARTZecoToolKit

open class ARTVideoPlayerOverlayView: ARTPassThroughView {
    
    /// 代理对象
    public weak var delegate: ARTVideoPlayerOverlayViewDelegate?
    
    /// 弹幕视图
    public var danmakuView: ARTDanmakuView!
    
    
    // MARK: - Initialization
    
    public init(_ delegate: ARTVideoPlayerOverlayViewDelegate? = nil) {
        super.init(frame: .zero)
        self.delegate = delegate
        setupViews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Super Methods

    /// 子类重写: 设置视图
    open func setupViews() {
        setupDanmakuView()
    }
    
    /// 创建弹幕视图
    @objc open func setupDanmakuView() {
        danmakuView = delegate_customDanmakuView() ?? defaultDanmakuView()
        addSubview(danmakuView)
        danmakuView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        applyDanmakuSettings() // 设置弹幕属性
    }
}

// MARK: - Private Methods

extension ARTVideoPlayerOverlayView {
    
    /// 默认弹幕视图
    internal func defaultDanmakuView() -> ARTDanmakuView {
        danmakuView = ARTDanmakuView(self)
        danmakuView.danmakuTrackHeight = ARTAdaptedValue(42.0) // 弹幕轨道高度
        return danmakuView
    }
}

// MARK: - Public Methods

extension ARTVideoPlayerOverlayView {
    
    /// 弹幕cell初始化位置
    /// - Parameter isLandscape: 是否为横屏模式
    @objc open func resizeDanmakuCellPosition(for orientation: ScreenOrientation) {
        guard let danmakuView = danmakuView else { return }
        let topPosition: CGFloat = {
            switch orientation {
            case .window, .landscapeFullScreen: // 横屏模式时，将弹幕视图设置为全屏
                return ARTAdaptedValue(6.0)
            case .portraitFullScreen: // 竖屏模式时，调整弹幕视图的位置和高度
                return art_navigationFullHeight() + ARTAdaptedValue(6.0)
            default:
                return danmakuView.danmakuCellPositionY
            }
        }()
        danmakuView.danmakuCellPositionY = topPosition
    }
    
    /// 处理点击事件并委托给弹幕视图
    @objc open func handleTapOnOverlay(at location: CGPoint) -> Bool {
        guard let danmakuView = danmakuView else { return false }
        return danmakuView.processDanmakuTap(at: location)
    }
    
    /// 是否开始发送弹幕
    /// - Parameter isDanmakuEnabled: 是否开启弹幕
    @objc open func shouldSendDanmaku(isDanmakuEnabled: Bool) {
        isDanmakuEnabled ? startDanmaku() : stopDanmaku()
    }
    
    /// 开始弹幕
    @objc open func startDanmaku() {
        if isDanmakuEnabled() { danmakuView.startDanmaku() }
    }
    
    /// 暂停弹幕
    @objc open func pauseDanmaku() {
        danmakuView.pauseDanmaku()
    }
    
    /// 恢复弹幕
    @objc open func resumeDanmaku() {
        if isDanmakuEnabled() { danmakuView.resumeDanmaku() }
    }
    
    /// 停止弹幕
    @objc open func stopDanmaku() {
        danmakuView.stopDanmaku()
    }
    
    /// 更新弹幕滑块值改变事件
    /// - Parameter sliderOption: 滑块选项
    public func updateDanmakuSliderValueChanged(for sliderOption: ARTVideoPlayerGeneralDanmakuEntity.SliderOption) {
        updateDanmakuProperty(for: sliderOption)
    }
    
    /// 应用弹幕设置
    public func applyDanmakuSettings() {
        let danmakuEntity = ARTVideoPlayerGeneralDanmakuEntity()
        danmakuEntity.sliderOptions.forEach { option in
            updateDanmakuProperty(for: option)
        }
    }
    
    /// 更新弹幕的属性
    /// - Parameter option: 弹幕选项
    private func updateDanmakuProperty(for option: ARTVideoPlayerGeneralDanmakuEntity.SliderOption) {
        switch option.optionType {
        case .opacity: // 不透明度
            let danmakuOpacity = CGFloat(option.defaultValue) / 100.0
            danmakuView.updateDanmakuAlpha(to: danmakuOpacity)
            
        case .displayArea: // 显示区域
            let displayArea = option.defaultValue + 1 // 计算显示区域，注意 option.defaultValue 的值从 0 开始，所以下标+1
            danmakuView.updateDanmakuDisplayArea(to: displayArea)
            
        case .scale: // 缩放比例
            let scaleLevel = option.defaultValue + 1 // 缩放级别（从 1 开始）
            let scaleValues: [CGFloat] = [0.8, 0.9, 1.0, 1.1, 1.2]
//            let danmakuScale = scaleValues[safe: scaleLevel - 1] ?? 1.0  // 使用 safe 下标来防止越界
//            let danmakuScale = scaleValues[safe: scaleLevel - 1] ?? 1.0  // 使用 safe 下标来防止越界
//            danmakuView.updateDanmakuScale(to: danmakuScale)
            
        case .speed: // 移动速度
            let speedIndex = option.defaultValue + 1 // 移动速度（从 1 开始）
            let speedLevel = ARTDanmakuView.SpeedLevel(rawValue: speedIndex) ?? .moderate
            danmakuView.updateDanmakuSpeed(to: speedLevel)
        }
    }
    
    /// 检查弹幕功能是否启用
    private func isDanmakuEnabled() -> Bool {
        return UserDefaults.standard.bool(forKey: "DanmakuEnabledKey")
    }
}

// MARK: - Private Delegate Methods

extension ARTVideoPlayerOverlayView {

    /// 获取自定义弹幕视图
    /// - Returns: 自定义弹幕视图
    private func delegate_customDanmakuView() -> ARTDanmakuView? {
        return delegate?.overlayViewDidCustomDanmakuView?(for: self)
    }
}
