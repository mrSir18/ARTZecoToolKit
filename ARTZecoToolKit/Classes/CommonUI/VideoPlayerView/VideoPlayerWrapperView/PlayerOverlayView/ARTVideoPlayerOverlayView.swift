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
    private var danmakuView: ARTDanmakuView!
    
    
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
}

extension ARTVideoPlayerOverlayView {

    /// 创建弹幕视图
    @objc open func setupDanmakuView() {
        danmakuView = ARTDanmakuView(self)
        danmakuView.danmakuTrackHeight = ARTAdaptedValue(42.0) // 弹幕轨道高度
        addSubview(danmakuView)
        danmakuView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let button = UIButton(type: .custom)
        button.setTitle("开始弹幕", for: .normal)
        button.backgroundColor = .art_randomColor()
        button.addTarget(self, action: #selector(danmakuStart), for: .touchUpInside)
        addSubview(button)
        button.snp.makeConstraints { make in
            make.size.equalTo(ARTAdaptedSize(width: 80, height: 80))
            make.centerY.equalToSuperview()
            make.right.equalTo(snp.centerX).offset(-ARTAdaptedValue(10))
        }
        
        let button1 = UIButton(type: .custom)
        button1.setTitle("结束弹幕", for: .normal)
        button1.backgroundColor = .art_randomColor()
        button1.addTarget(self, action: #selector(danmakuStop), for: .touchUpInside)
        addSubview(button1)
        button1.snp.makeConstraints { make in
            make.size.equalTo(button)
            make.centerY.equalToSuperview()
            make.left.equalTo(snp.centerX).offset(ARTAdaptedValue(10))
        }
    }
    
    /// 添加弹幕
    @objc open func danmakuStart() {
        print("开始")
        danmakuView.startDanmaku()
    }
    
    @objc open func danmakuStop() {
        print("结束")
        danmakuView.stopDanmaku()
    }
}
