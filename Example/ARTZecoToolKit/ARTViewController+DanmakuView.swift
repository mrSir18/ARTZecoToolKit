//
//  ARTViewController+DanmakuView.swift
//  ARTZecoToolKit_Example
//
//  Created by mrSir18 on 2024/11/19.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import ARTZecoToolKit

class ARTViewController_DanmakuView: ARTBaseViewController {
    
    /// 弹幕视图
    private var danmakuView: ARTVideoPlayerDanmakuView!
    
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDanmakuView()
    }
    
    /// 创建弹幕视图
    private func setupDanmakuView() {
        danmakuView = ARTVideoPlayerDanmakuView()
        view.addSubview(danmakuView)
        danmakuView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(ARTAdaptedValue(100.0))
            make.height.equalTo(ARTAdaptedValue(300.0))
        }
        
        let button = UIButton(type: .custom)
        button.setTitle("开始弹幕", for: .normal)
        button.backgroundColor = .art_randomColor()
        button.addTarget(self, action: #selector(danmakuStart), for: .touchUpInside)
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.size.equalTo(ARTAdaptedSize(width: 80, height: 80))
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-ARTAdaptedValue(100.0))
        }
        
        let button1 = UIButton(type: .custom)
        button1.setTitle("结束弹幕", for: .normal)
        button1.backgroundColor = .art_randomColor()
        button1.addTarget(self, action: #selector(danmakuStop), for: .touchUpInside)
        view.addSubview(button1)
        button1.snp.makeConstraints { make in
            make.size.equalTo(button)
            make.bottom.equalTo(button)
            make.right.equalTo(-ARTAdaptedValue(24.0))
        }
        
        let button2 = UIButton(type: .custom)
        button2.backgroundColor = .art_randomColor()
        button2.setTitle("添加弹幕", for: .normal)
        button2.addTarget(self, action: #selector(danmakuAction), for: .touchUpInside)
        view.addSubview(button2)
        button2.snp.makeConstraints { make in
            make.size.equalTo(button)
            make.bottom.equalTo(button)
            make.left.equalTo(ARTAdaptedValue(24))
        }
    }
    
    /// 添加弹幕
    @objc open func danmakuStart() {
        print("开始")
        danmakuView.startDanmaku()
    }
    
    @objc open func danmakuStop() {
        print("结束")
    }
    
    @objc open func danmakuAction() {
        let danmakuCell = ARTCustomDanmakuCell()
        danmakuCell.danmakuSpeed = [3,4,5,6].randomElement() ?? 3
        danmakuCell.danmakuTrack = 4
        danmakuCell.danmakuTrackSpacing = 10.0
        danmakuCell.danmakuDelayTime = 0.0
        danmakuCell.danmakuDuration = 0.0
        danmakuView.insertDanmaku([danmakuCell], at: 0) { _ in
            
        }
    }
}

// MARK: ARTVideoPlayerDanmakuViewDelegate

extension ARTViewController_DanmakuView: ARTVideoPlayerDanmakuViewDelegate {
    
}
