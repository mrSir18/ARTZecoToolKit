//
//  CollectionSectionProtocol.swift
//  ARTZecoToolKit_Example
//
//  Created by mrSir18 on 2024/7/13.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import ARTZecoToolKit

// 定义协议，所有的分组数据结构都实现此协议
protocol CollectionSectionProtocol {
    var configModel: ARTCollectionViewConfigModel? {get}  // 配置样式
    var sectionType: CollectionSectionType {get}
    var headerSize: CGSize {get}
    var footerSize: CGSize {get}
    var cellReuseIdentifiers: [String] {get}
    var cellHeights: [CGFloat] {get}
    var column: Int {get}
    var minimumLineSpacing: CGFloat { get }
    var minimumInteritemSpacing: CGFloat { get }
    var sectionInsets: UIEdgeInsets { get }
    var spacingBetweenFooterAndNextHeader: CGFloat {get}
}


/// 定义 样式 枚举.
enum CollectionSectionType {
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
