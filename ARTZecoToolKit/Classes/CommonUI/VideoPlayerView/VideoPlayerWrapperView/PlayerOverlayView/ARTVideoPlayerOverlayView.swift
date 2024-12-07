//
//  ARTVideoPlayerOverlayView.swift
//  Pods
//
//  Created by mrSir18 on 2024/10/19.
//

open class ARTVideoPlayerOverlayView: ARTPassThroughView {
    
    /// 代理对象
    public weak var delegate: ARTVideoPlayerOverlayViewDelegate?
    
    /// 弹幕视图
    public var danmakuView: ARTDanmakuView!
    
    
    // MARK: - Initialization
    
    public init(_ delegate: ARTVideoPlayerOverlayViewDelegate? = nil) {
        super.init(frame: .zero)
        self.delegate = delegate
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Override Super Methods
    
    /// 重写父类方法，设置子视图
    open override func setupViews() {
        setupDanmakuView()
    }
    
    /// 创建弹幕视图
    @objc open func setupDanmakuView() {
        danmakuView = ARTDanmakuView(self)
        danmakuView.danmakuTrackHeight = ARTAdaptedValue(42.0) // 弹幕轨道高度
        addSubview(danmakuView)
        danmakuView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
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
        danmakuView.startDanmaku()
    }
    
    /// 停止弹幕
    @objc open func stopDanmaku() {
        danmakuView.stopDanmaku()
    }
}
