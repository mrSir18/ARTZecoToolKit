//
//  ARTScreenAdapter.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/6/20.
//

/// 获取适配比例
public func ARTAdaptScaleFactor() -> CGFloat {
    let screenWidth = UIScreen.main.bounds.size.width
    let designWidth: CGFloat = 375.0
    return screenWidth / designWidth
}

/// 适配值
public func ARTAdaptedValue(_ value: CGFloat) -> CGFloat {
    return round(value * ARTAdaptScaleFactor())
}

/// 适配尺寸
public func ARTAdaptedSize(width: CGFloat, height: CGFloat) -> CGSize {
    return CGSize(width: ARTAdaptedValue(width), height: ARTAdaptedValue(height))
}
