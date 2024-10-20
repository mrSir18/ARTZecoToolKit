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

    /// 返回定义滑块轨道区域的矩形。
    /// - 参数 bounds: 滑块的边界。
    /// - 返回: 定义轨道框架的 CGRect，已根据指定的轨道高度进行调整。
    open override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let newTrackRect = super.trackRect(forBounds: bounds)
        return CGRect(origin: newTrackRect.origin, size: CGSize(width: newTrackRect.width, height: trackHeight))
    }
}
