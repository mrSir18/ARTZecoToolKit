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

extension String {
    
    /// 将格式化时间字符串转换为总秒数。
    ///
    /// - Parameter formattedTime: 格式化的时间字符串，支持 "HH:mm:ss" 或 "mm:ss" 格式。
    /// - Returns: 转换后的总秒数，如果格式不正确或无法解析则返回 `nil`。
    /// - Note: 该方法支持两种格式：
    ///   - "mm:ss"：分钟:秒，例如 "02:15" 转换为 135 秒。
    ///   - "HH:mm:ss"：小时:分钟:秒，例如 "01:01:15" 转换为 3675 秒。
    public func art_secondsFromFormattedTime() -> Double? {
        let timeComponents = self.split(separator: ":") // 将输入的时间字符串按 ":" 分隔
        
        // 处理 "分钟:秒" 格式 (mm:ss)
        if timeComponents.count == 2 {
            guard let minutes = Double(timeComponents[0]), let seconds = Double(timeComponents[1]) else {
                return nil // 如果无法转换为数字，返回 nil
            }
            return minutes * 60 + seconds // 返回总秒数
        }
        // 处理 "小时:分钟:秒" 格式 (HH:mm:ss)
        else if timeComponents.count == 3 {
            guard let hours = Double(timeComponents[0]), let minutes = Double(timeComponents[1]), let seconds = Double(timeComponents[2]) else {
                return nil // 如果无法转换为数字，返回 nil
            }
            return hours * 3600 + minutes * 60 + seconds // 返回总秒数
        }
        
        return nil // 如果格式不符合预期，返回 nil
    }
}
