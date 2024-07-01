//
//  ARTAlertController.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/7/2.
//

/// 定义 ARTAlertController 的模式枚举.
public enum ARTAlertControllerMode {
    /// 第一种模式.
    case first
    /// 第二种模式.
    case second
    /// 第三种模式.
    case third
    /// 第四种模式.
    case fourth
    /// 第五种模式.
    case fifth
    /// 第六种模式.
    case sixth
    /// 第七种模式.
    case seventh
    /// 第八种模式.
    case eighth
    /// 第九种模式.
    case ninth
    /// 第十种模式.
    case tenth
    // 根据需要添加更多的模式.
    case custom(Int) // 自定义情况，处理超出枚举情况数量的按钮点击
    /// 获取所有的模式.
    static var allCases: [ARTAlertControllerMode] {
        return [.first, .second, .third, .fourth, .fifth, .sixth, .seventh, .eighth, .ninth, .tenth]
    }
}
