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
            make.height.equalTo(ARTAdaptedValue(260.0))
        }
        
        let buttonsInfo: [(title: String, action: Selector)] = [
            ("开始弹幕", #selector(startDanmakuAction)),
            ("添加弹幕", #selector(addDanmakuAction)),
            ("暂停弹幕", #selector(pauseDanmakuAction)),
            ("继续弹幕", #selector(resumeDanmakuAction)),
            ("结束弹幕", #selector(stopDanmakuAction)),
            ("2条弹幕", #selector(twoDanmakuAction)),
            ("4条弹幕", #selector(fourDanmakuAction)),
            ("透明度", #selector(opacityDanmakuAction)),
            ("字体大小", #selector(fontSizeAction))
        ]
        
        let maxButtonsPerRow = Int((UIScreen.main.bounds.width - ARTAdaptedValue(48)) / ARTAdaptedValue(80 + 24))
        var rowStackViews: [UIStackView] = []
        var currentRowStack: UIStackView? = nil
        
        for (index, info) in buttonsInfo.enumerated() {
            let button = UIButton(type: .custom)
            button.setTitle(info.title, for: .normal)
            button.backgroundColor = .art_randomColor()
            button.addTarget(self, action: info.action, for: .touchUpInside)
            
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
                        make.top.equalTo(danmakuView.snp.bottom).offset(ARTAdaptedValue(24))
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

    @objc open func startDanmakuAction() {
        print("开始弹幕")
        danmakuView.startDanmaku()
    }
    
    @objc open func addDanmakuAction() {
        print("添加弹幕")
        let danmakuCell = ARTCustomDanmakuCell()
        danmakuCell.danmakuSpeed = [3, 4, 5, 6].randomElement() ?? 3
        danmakuCell.danmakuTrack = 4
        danmakuCell.danmakuTrackSpacing = 10.0
        danmakuCell.danmakuDelayTime = 0.0
        danmakuCell.danmakuDuration = 0.0
        danmakuView.insertDanmaku([danmakuCell], at: 0)
    }
    
    @objc open func pauseDanmakuAction() {
        print("暂停弹幕")
        danmakuView.pauseDanmaku()
    }
    
    @objc open func resumeDanmakuAction() {
        print("继续弹幕")
        danmakuView.resumeDanmaku()
    }

    @objc open func stopDanmakuAction() {
        print("结束弹幕")
        danmakuView.stopDanmaku()
    }
    
    @objc open func twoDanmakuAction() {
        print("2条弹幕")
        danmakuView.changeDanmakuTrack(2)
    }

    @objc open func fourDanmakuAction() {
        print("4条弹幕")
        danmakuView.changeDanmakuTrack(4)
    }

    @objc open func opacityDanmakuAction() {
        print("透明度")
    }
    
    @objc open func fontSizeAction() {
        print("字体大小")
    }
}

// MARK: ARTVideoPlayerDanmakuViewDelegate

extension ARTViewController_DanmakuView: ARTVideoPlayerDanmakuViewDelegate {
    
}
