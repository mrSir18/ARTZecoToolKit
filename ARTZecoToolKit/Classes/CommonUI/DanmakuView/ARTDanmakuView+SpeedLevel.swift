//
//  ARTDanmakuView+SpeedLevel.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/12/6.
//

// MARK: - Enum & Class

extension ARTDanmakuView {
    
    /// 弹幕状态枚举
    public enum DanmakuState {
        case idle      // 未启动
        case running   // 正在运行
        case paused    // 暂停中
        case stopped   // 已停止
    }
    
    /// 弹幕速度等级枚举
    public enum SpeedLevel: Int, CaseIterable {
        case extremelySlow      = 1 // 极慢
        case slow               = 2 // 慢速
        case moderate           = 3 // 适中
        case fast               = 4 // 快速
        case extremelyFast      = 5 // 极快
        
        func randomDuration() -> CGFloat {
            switch self {
            case .extremelyFast:
                return CGFloat.random(in: 9...11)
            case .fast:
                return CGFloat.random(in: 11...13)
            case .moderate:
                return CGFloat.random(in: 13...15)
            case .slow:
                return CGFloat.random(in: 15...17)
            case .extremelySlow:
                return CGFloat.random(in: 17...19)
            }
        }
    }
}
