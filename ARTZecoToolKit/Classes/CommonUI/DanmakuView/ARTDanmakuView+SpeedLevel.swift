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
        case extremelyFast      = 1 // 极快
        case fast               = 2 // 快速
        case moderate           = 3 // 适中
        case slow               = 4 // 慢速
        case extremelySlow      = 5 // 极慢
        
        func randomDuration() -> CGFloat {
            switch self {
            case .extremelyFast:
                return CGFloat.random(in: 3...5)
            case .fast:
                return CGFloat.random(in: 6...8)
            case .moderate:
                return CGFloat.random(in: 9...10)
            case .slow:
                return CGFloat.random(in: 11...13)
            case .extremelySlow:
                return CGFloat.random(in: 14...16)
            }
        }
    }
}
