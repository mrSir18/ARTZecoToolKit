//
//  CMTime+ARTExtension.swift
//  Pods
//
//  Created by mrSir18 on 2024/10/20.
//

import AVFoundation

extension CMTime {
    
    /// 格式化时间.
    ///
    /// - Returns: 格式化后的时间字符串，格式为 "HH:mm:ss" 或 "mm:ss"。
    /// - Note: 将 CMTime 转换为小时、分钟和秒的字符串表示。
    public func art_formattedTime() -> String {
        let totalSeconds = CMTimeGetSeconds(self)
        guard totalSeconds >= 0 else { return "00:00" } // 如果时间为负，则返回默认时间格式
        
        let hours = Int(totalSeconds) / 3600
        let minutes = (Int(totalSeconds) % 3600) / 60
        let seconds = Int(totalSeconds) % 60
        
        return hours > 0
        ? String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        : String(format: "%02d:%02d", minutes, seconds)
    }
}
