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
    case pause
    case resume
    case stop
    case oneTrack
    case twoTracks
    case threeTracks
    case oneOpacity
    case twoOpacity
    case threeOpacity
    case oneSpeed
    case twoSpeed
    case threeSpeed
    case oneSize
    case twoSize
}

class ARTViewController_DanmakuView: ARTBaseViewController {
    
    /// 弹幕视图
    private var danmakuView: ARTDanmakuView!
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 创建弹幕视图
        danmakuView = ARTDanmakuView(self)
        danmakuView.backgroundColor = .art_randomColor()
        view.addSubview(danmakuView)
        danmakuView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(art_navigationFullHeight())
            make.height.equalTo(ARTAdaptedValue(180.0))
        }
        setupButtons()
    }
}

// MARK: - ARTDanmakuViewDelegate

extension ARTViewController_DanmakuView: ARTDanmakuViewDelegate {
    
    func danmakuViewCreateCell(_ danmakuView: ARTDanmakuView) -> ARTDanmakuCell { // 创建弹幕
        let cell = ARTCustomDanmakuCell()
        cell.backgroundColor = .art_randomColor()
        return cell
    }
    
    func danmakuView(_ danmakuView: ARTDanmakuView, didClickDanmakuCell danmakuCell: ARTDanmakuCell) { // 点击弹幕
        guard let danmakuCell = danmakuCell as? ARTCustomDanmakuCell else { return }
        print("点击了弹幕：\(danmakuCell.bulletLabel.text ?? "")")
    }
    
    func danmakuView(_ danmakuView: ARTDanmakuView, willDisplayDanmakuCell danmakuCell: ARTDanmakuCell) { // 弹幕开始显示
        //        guard let danmakuCell = danmakuCell as? ARTCustomDanmakuCell else { return }
        //        print("弹幕开始显示：\(danmakuCell.bulletLabel.text ?? "")")
    }
    
    func danmakuView(_ danmakuView: ARTDanmakuView, didEndDisplayDanmakuCell danmakuCell: ARTDanmakuCell) { // 弹幕结束显示
        //        guard let danmakuCell = danmakuCell as? ARTCustomDanmakuCell else { return }
        //        print("弹幕结束显示：\(danmakuCell.bulletLabel.text ?? "")")
    }
    
    func danmakuViewDidEndDisplayAllDanmaku(_ danmakuView: ARTDanmakuView) { // 所有弹幕显示完
        print("所有弹幕显示完毕")
    }
}

// MARK: Test Button

extension ARTViewController_DanmakuView {
    
    private func setupButtons() { /// 创建按钮
        let buttonsInfo: [(title: String, actionType: DanmakuActionType)] = [
            ("开始弹幕", .start),
            ("暂停弹幕", .pause),
            ("继续弹幕", .resume),
            ("结束弹幕", .stop),
            ("1条弹幕", .oneTrack),
            ("2条弹幕", .twoTracks),
            ("4条弹幕", .threeTracks),
            ("25%透明度", .oneOpacity),
            ("75%透明度", .twoOpacity),
            ("100%透明度", .threeOpacity),
            ("极慢", .oneSpeed),
            ("适中", .twoSpeed),
            ("极快", .threeSpeed),
            ("50%大小", .oneSize),
            ("100%大小", .twoSize)
        ]
        
        let maxButtonsPerRow = Int((UIScreen.main.bounds.width - ARTAdaptedValue(48)) / ARTAdaptedValue(80 + 24))
        var rowStackViews: [UIStackView] = []
        var currentRowStack: UIStackView? = nil
        
        for (index, info) in buttonsInfo.enumerated() {
            let button = UIButton(type: .custom)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
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
                make.size.equalTo(ARTAdaptedSize(width: 90.0, height: 80.0))
            }
        }
    }
    
    @objc private func handleButtonTap(_ sender: UIButton) {
        guard let actionType = DanmakuActionType(rawValue: sender.tag) else { return }
        print("\(sender.titleLabel?.text ?? "")")
        performAction(for: actionType)
    }
    
    private func performAction(for actionType: DanmakuActionType) {
        switch actionType {
        case .start: // 开始弹幕
            danmakuView.startDanmaku()
            
        case .pause: // 暂停弹幕
            danmakuView.pauseDanmaku()
            
        case .resume: // 继续弹幕
            danmakuView.resumeDanmaku()
            
        case .stop: // 结束弹幕
            danmakuView.stopDanmaku()
            
        case .oneTrack: // 1条弹幕
            danmakuView.updateDanmakuTrackCount(1)
            
        case .twoTracks: // 2条弹幕
            danmakuView.updateDanmakuTrackCount(2)
            
        case .threeTracks: // 4条弹幕
            danmakuView.updateDanmakuTrackCount(4)
            
        case .oneOpacity: // 25%透明度
            danmakuView.updateDanmakuAlpha(0.25)
            
        case .twoOpacity: // 75%透明度
            danmakuView.updateDanmakuAlpha(0.75)
            
        case .threeOpacity: // 100%透明度
            danmakuView.updateDanmakuAlpha(1.0)
            
        case .oneSpeed: // 极慢
            danmakuView.updateDanmakuSpeed(.extremelySlow)
            
        case .twoSpeed: // 适中
            danmakuView.updateDanmakuSpeed(.moderate)
            
        case .threeSpeed: // 极快
            danmakuView.updateDanmakuSpeed(.extremelyFast)
            
        case .oneSize: // 50%大小
            danmakuView.updateDanmakuSize(0.5)
            
        case .twoSize: // 100%大小
            danmakuView.updateDanmakuSize(1.0)
        }
    }
}
