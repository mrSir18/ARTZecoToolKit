//
//  ARTVideoPlayerGeneralDanmakuEntity.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/11/7.
//

// MARK: - 弹幕设置相关扩展
extension ARTVideoPlayerGeneralDanmakuEntity {
    
    // 滑块选项类型
    public enum SliderOptionType {
        case opacity        // 不透明度
        case displayArea    // 显示区域
        case scale          // 缩放比例
        case speed          // 移动速度
    }
    
    // 滑块选项
    public struct SliderOption {
        let title: String       // 标题
        let minValue: Float     // 最小值
        let maxValue: Int       // 最大值
        let segments: [String]  // 分段
        var defaultValue: Int   // 默认值
        let optionType: SliderOptionType // 选项类型
    }
    
    // 默认值结构体
    public struct DefaultValues {
        static let opacity: Int     = 100
        static let displayArea: Int = 2
        static let scale: Int       = 2
        static let speed: Int       = 2
        
        // 通过类型获取对应的默认值
        static func defaultValue(for optionType: SliderOptionType) -> Int {
            switch optionType {
            case .opacity:
                return opacity
            case .displayArea:
                return displayArea
            case .scale:
                return scale
            case .speed:
                return speed
            }
        }
    }
}

public struct ARTVideoPlayerGeneralDanmakuEntity {
    
    // 弹幕设置选项
    public var sliderOptions: [SliderOption]
    
    // MARK: - Initialization
    public init() {
        self.sliderOptions = [
            SliderOption(title: "不透明度", minValue: 0, maxValue: 100, segments: [], defaultValue: DefaultValues.opacity, optionType: .opacity),
            SliderOption(title: "显示区域", minValue: 0, maxValue: 3, segments: ["1/4屏", "2/4屏", "3/4屏", "4/4屏"], defaultValue: DefaultValues.displayArea, optionType: .displayArea),
            SliderOption(title: "字体大小", minValue: 0, maxValue: 4, segments: ["小", "较小", "适中", "较大", "大"], defaultValue: DefaultValues.scale, optionType: .scale),
            SliderOption(title: "移动速度", minValue: 0, maxValue: 4, segments: ["慢", "较慢", "适中", "较快", "快"], defaultValue: DefaultValues.speed, optionType: .speed)
        ]
    }
    
    // 恢复默认值
    public mutating func restoreDefaults() {
        sliderOptions = sliderOptions.map { option in
            var modifiedOption = option
            modifiedOption.defaultValue = DefaultValues.defaultValue(for: option.optionType)
            return modifiedOption
        }
    }
}
