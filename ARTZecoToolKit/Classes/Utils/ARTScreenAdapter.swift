//
//  ARTScreenAdapter.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/6/20.
//

/// 获取适配比例
public func ARTAdaptScaleFactor() -> CGFloat {
    let screenSize = UIScreen.main.bounds.size
    let designWidth: CGFloat = 375.0
    let designHeight: CGFloat = 812.0 // 通常为667.0 或 812.0

    // 根据当前设备方向选择设计宽度或高度
    let isPortrait = screenSize.width < screenSize.height
    let referenceWidth = isPortrait ? designWidth : designHeight
    return screenSize.width / referenceWidth
}

/// 适配值
public func ARTAdaptedValue(_ value: CGFloat) -> CGFloat {
    return round(value * ARTAdaptScaleFactor())
}

/// 适配尺寸
public func ARTAdaptedSize(width: CGFloat, height: CGFloat) -> CGSize {
    return CGSize(width: ARTAdaptedValue(width), height: ARTAdaptedValue(height))
}
