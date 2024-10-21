//
//  ARTVideoPlayerSlider.swift
//  Pods
//
//  Created by mrSir18 on 2024/10/20.
//

/// 自定义视频播放器滑块类，具有可调节的轨道高度。
///
/// 开源项目，欢迎贡献与使用。请遵循相关许可协议。
open class ARTVideoPlayerSlider: UISlider {

    /// 轨道的高度，默认为 3.0。
    public var trackHeight: CGFloat = ARTAdaptedValue(3.0)

    /// 滑块图像的偏移量，默认为 0.0。
    public var thumbOffset: CGFloat = 0.0

    /// 定义滑块轨道区域的矩形。
    ///
    /// - Parameters:
    ///  - bounds: 轨道的边界。
    ///  - Returns: 轨道的矩形。
    /// - Note: 返回: 定义轨道框架的 CGRect，已根据指定的轨道高度进行调整。
    open override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let newTrackRect = super.trackRect(forBounds: bounds)
        return CGRect(origin: newTrackRect.origin, size: CGSize(width: newTrackRect.width, height: trackHeight))
    }

    /// 定义滑块图像区域的矩形，考虑了偏移量。
    ///
    /// - Parameters:
    ///  - bounds: 滑块的边界。
    ///  - rect: 轨道的边界。
    ///  - value: 滑块的值。
    ///  - Returns: 滑块的矩形。
    /// - Note: 定义滑块图像框架的 CGRect。
    open override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        let originalThumbRect = super.thumbRect(forBounds: bounds, trackRect: rect, value: value)
        return originalThumbRect.offsetBy(dx: 0, dy: thumbOffset)
    }
}
