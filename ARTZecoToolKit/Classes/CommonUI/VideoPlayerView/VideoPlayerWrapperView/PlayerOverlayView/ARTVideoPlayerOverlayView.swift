//
//  ARTVideoPlayerOverlayView.swift
//  Pods
//
//  Created by mrSir18 on 2024/10/19.
//

/// 协议方法
///
/// - NOTE: 可继承该协议方法
public protocol ARTVideoPlayerOverlayViewDelegate: AnyObject {
    
}

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

// MARK: - Setup Initializer

extension ARTVideoPlayerOverlayView: ARTDanmakuViewDelegate {
    
}

extension ARTVideoPlayerOverlayView {

    /// 创建弹幕视图
    @objc open func setupDanmakuView() {
//        danmakuView = ARTDanmakuView(self)
//        addSubview(danmakuView)
//        danmakuView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
        
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
        
        let button2 = UIButton(type: .custom)
        button2.backgroundColor = .art_randomColor()
        button2.setTitle("添加弹幕", for: .normal)
        button2.addTarget(self, action: #selector(danmakuAction), for: .touchUpInside)
        addSubview(button2)
        button2.snp.makeConstraints { make in
            make.size.equalTo(button)
            make.centerY.equalToSuperview()
            make.left.equalTo(ARTAdaptedValue(80))
        }
    }
    
    /// 添加弹幕
    @objc open func danmakuStart() {
        print("开始")
//        danmakuView.startDanmaku()
    }
    
    @objc open func danmakuStop() {
        print("结束")
    }
    
    @objc open func danmakuAction() {
        print("添加弹幕")
//        let danmakuCell = ARTVideoPlayerDanmakuCell()
//        danmakuCell.danmakuTrack = 4
//        danmakuCell.danmakuTrackSpacing = 10.0
//        danmakuCell.danmakuDelayTime = 0.0
//        danmakuCell.danmakuDuration = 0.0
//        danmakuView.insertDanmaku([danmakuCell], at: 0) { _ in
//            print("添加弹幕成功")
//        }
    }
}
