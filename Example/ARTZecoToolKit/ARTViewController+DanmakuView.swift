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

class ARTViewController_DanmakuView: ARTBaseViewController {
    
    /// 弹幕视图
    private var danmakuView: ARTVideoPlayerDanmakuView!
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDanmakuView()
        setupButtons()
    }
    
    /// 创建弹幕视图
    private func setupDanmakuView() {
        danmakuView = ARTVideoPlayerDanmakuView(self)
        danmakuView.backgroundColor = .art_randomColor()
        danmakuView.initialInterval = 0.1
        view.addSubview(danmakuView)
        danmakuView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(ARTAdaptedValue(100.0))
            make.height.equalTo(ARTAdaptedValue(260.0))
        }
    }
    
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
    
    @objc private func handleButtonTap(_ sender: UIButton) {
        guard let actionType = DanmakuActionType(rawValue: sender.tag) else { return }
        performAction(for: actionType)
    }
}

// MARK: Test Button

extension ARTViewController_DanmakuView {
    
    private func performAction(for actionType: DanmakuActionType) {
        switch actionType {
        case .start:
            print("开始弹幕")
            danmakuView.startDanmaku()
        case .add:
            print("添加弹幕")
            let danmakuCell = ARTCustomDanmakuCell()
            danmakuCell.backgroundColor = .art_randomColor()
            danmakuCell.danmakuSpeed = TimeInterval.random(in: 3...6)
            danmakuCell.danmakuTrack = 4
            danmakuCell.danmakuTrackSpacing = 12.0
            danmakuCell.danmakuDelayTime = 0.0
            danmakuCell.danmakuDuration = 0.0
            danmakuView.insertDanmaku([danmakuCell])
        case .pause:
            print("暂停弹幕")
            danmakuView.pauseDanmaku()
        case .resume:
            print("继续弹幕")
            danmakuView.resumeDanmaku()
        case .stop:
            print("结束弹幕")
            danmakuView.stopDanmaku()
        case .twoTracks:
            print("2条弹幕")
            danmakuView.changeDanmakuTrack(2)
        case .fourTracks:
            print("4条弹幕")
            danmakuView.changeDanmakuTrack(4)
        case .changeOpacity:
            print("透明度")
        case .changeFontSize:
            print("字体大小")
        }
    }
}

// MARK: ARTVideoPlayerDanmakuViewDelegate

extension ARTViewController_DanmakuView: ARTVideoPlayerDanmakuViewDelegate {
    
    func danmakuView(_ danmakuView: ARTVideoPlayerDanmakuView, didClickDanmakuCell danmakuCell: ARTVideoPlayerDanmakuCell) {
        print("点击弹幕 \(String(describing: danmakuCell.backgroundColor?.description))")
    }
    
    func danmakuView(_ danmakuView: ARTVideoPlayerDanmakuView, willDisplayDanmakuCell danmakuCell: ARTVideoPlayerDanmakuCell) {
//        print("弹幕即将显示")
    }
    
    func danmakuView(_ danmakuView: ARTVideoPlayerDanmakuView, didEndDisplayDanmakuCell danmakuCell: ARTVideoPlayerDanmakuCell) {
//        print("弹幕显示完成")
    }
    
    func danmakuViewDidEndDisplayAllDanmaku(_ danmakuView: ARTVideoPlayerDanmakuView) {
        print("所有弹幕显示完成")
    }
}
