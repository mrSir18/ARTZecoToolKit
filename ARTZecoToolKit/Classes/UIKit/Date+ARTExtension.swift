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
    public static func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    /// 将日期字符串转换为 Date 对象
    /// - Parameter dateString: 需要转换的日期字符串
    /// - Returns: 转换后的 Date 对象，如果转换失败则返回 nil
    public static func dateFromString(_ dateString: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"  // 内部定义的日期格式
        return formatter.date(from: dateString) ?? Date()
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
    
    /// 将两个日期之间的差值转换为描述年龄的字符串。
    /// - Parameters:
    ///   - startDate: 开始日期。
    ///   - endDate: 结束日期。
    /// - Returns: 描述年龄差异的字符串，包括年、月和天数。
    
    public static func convertToAgeDescription(from startDate: Date, to endDate: Date) -> String {
        let calendar = Calendar.current
        // 计算 startDate 和 endDate 之间的年、月、日差值。
        let components = calendar.dateComponents([.year, .month, .day], from: startDate, to: endDate)
        
        let years = components.year ?? 0
        let months = components.month ?? 0
        let days = components.day ?? 0
        // 计算 startDate 和 endDate 之间的总天数。
        let totalDays = calendar.dateComponents([.day], from: startDate, to: endDate).day ?? 0
        
        // 根据总天数和年龄组件返回具体的描述字符串。
        switch totalDays {
        case 100:
            // 特殊情况：正好100天
            return "宝宝百天"
        case _ where years > 0 && months == 0 && days == 0:
            // 只包含整年
            return "\(years)岁"
        case _ where years > 0 && months > 0 && days == 0:
            // 包含整年和整月
            return "\(years)岁\(months)个月"
        case _ where years > 0:
            // 包含整年、整月和天数
            return "\(years)岁\(months)个月\(days)天"
        case _ where months > 0 && days == 0:
            // 只包含整月
            return "\(months)个月"
        case _ where months > 0:
            // 包含整月和天数
            return "\(months)个月\(days)天"
        default:
            // 只包含天数
            return "\(days)天"
        }
    }
    
    /// 计算时间差并返回相应的字符串
    ///
    /// - Parameter dateString: 日期字符串
    public func timeAgoSinceDate(_ dateString: String) -> String? {
        // 定义日期格式
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        
        // 将日期字符串转换为 Date 对象
        guard let date = dateFormatter.date(from: dateString) else {
            return nil
        }
        
        // 获取当前时间和日历对象
        let now = Date()
        let calendar = Calendar.current
        
        // 计算时间差
        let components = calendar.dateComponents([.minute, .hour, .day], from: date, to: now)
        
        // 判断时间差并返回相应的字符串
        if let day = components.day, day >= 1 {
            if day == 1 {
                return "昨天"
            } else if day == 2 {
                return "前天"
            } else if day == 3 {
                return "\(day)天前"
            } else {
                // 如果超过 3 天，返回具体日期
                return dateFormatter.string(from: date)
            }
        }
        
        if let hour = components.hour, hour >= 1 {
            return "\(hour)小时前"
        }
        
        if let minute = components.minute {
            if minute < 5 {
                return "刚刚"
            } else {
                return "\(minute)分钟前"
            }
        }
        
        return nil
    }
}
