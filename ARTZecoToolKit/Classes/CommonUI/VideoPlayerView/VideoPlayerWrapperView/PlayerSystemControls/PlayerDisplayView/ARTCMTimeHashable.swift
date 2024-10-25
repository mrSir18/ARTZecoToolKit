//
//  ARTCMTimeHashable.swift
//  Pods
//
//  Created by mrSir18 on 2024/10/22.
//

import AVFoundation

/// 一个可哈希的结构体，用于表示CMTime
public struct CMTimeHashable: Hashable {
    public var seconds: Double   // 时间的秒数
    public var timescale: Int32  // 时间的尺度

    /// 初始化方法，从CMTime转换为CMTimeHashable
    public init(_ time: CMTime) {
        self.seconds = CMTimeGetSeconds(time) // 获取时间的秒数
        self.timescale = time.timescale       // 获取时间的尺度
    }
    
    /// 哈希函数，将结构体的属性组合成哈希值
    public func hash(into hasher: inout Hasher) {
        hasher.combine(seconds)   // 将秒数加入哈希值
        hasher.combine(timescale) // 将时间尺度加入哈希值
    }
    
    /// 判断两个CMTimeHashable实例是否相等
    public static func ==(lhs: CMTimeHashable, rhs: CMTimeHashable) -> Bool {
        return lhs.seconds == rhs.seconds && lhs.timescale == rhs.timescale
    }
}
