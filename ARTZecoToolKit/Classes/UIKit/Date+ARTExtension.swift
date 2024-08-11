//
//  Date+ARTExtension.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/8/11.
//

extension Date {
    
    /// 获取格式化后的日期字符串
    /// - Parameter date: 需要格式化的日期对象
    /// - Returns: 格式化后的日期字符串，使用 "yyyy-MM-dd" 格式
    public static func formattedDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    /// 将日期字符串转换为 Date 对象
    /// - Parameter dateString: 需要转换的日期字符串
    /// - Returns: 转换后的 Date 对象，如果转换失败则返回 nil
    public static func dateFromString(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"  // 内部定义的日期格式
        return formatter.date(from: dateString)
    }
    
    /// 将时间戳转换为 Date 对象
    /// - Parameter timestamp: 时间戳（秒）
    /// - Returns: 对应的 Date 对象
    public static func dateFromTimestamp(_ timestamp: TimeInterval) -> Date {
        return Date(timeIntervalSince1970: timestamp)
    }
    
    /// 将 Date 对象转换为时间戳
    /// - Parameter date: 日期对象
    /// - Returns: 对应的时间戳（秒）
    public static func timestampFromDate(_ date: Date) -> TimeInterval {
        return date.timeIntervalSince1970
    }
}
