//
//  ARTActionSheetEntity.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/7/2.
//

/// 容器实体
public struct ARTActionSheetContainerEntity {
    /// 容器高度
    public var height: CGFloat
    /// 容器背景色
    public var backgroundColor: UIColor
    /// 容器圆角
    public var radius: CGFloat
    /// 是否允许通过下拉关闭 Sheet 视图
    public var allowDismissByPullDown: Bool
    /// 是否允许通过点击空白区域关闭 Sheet 视图
    public var allowDismissByTapOnBackground: Bool
    /// 是否根据内容高度设定容器高度
    public var enableAutoHeight: Bool

    
    // MARK: - Initialization
    
    public init(height: CGFloat, backgroundColor: UIColor, radius: CGFloat, allowDismissByPullDown: Bool, allowDismissByTapOnBackground: Bool, enableAutoHeight: Bool) {
        self.height = max(0.0, round(height))
        self.backgroundColor = backgroundColor
        self.radius = radius
        self.allowDismissByPullDown = allowDismissByPullDown
        self.allowDismissByTapOnBackground = allowDismissByTapOnBackground
        self.enableAutoHeight = enableAutoHeight
    }
    
    /// 静态方法返回容器实体
    public static func allCharacter() -> ARTActionSheetContainerEntity {
        return ARTActionSheetContainerEntity(height: ARTAdaptedValue(244.0),
                                             backgroundColor: .white,
                                             radius: ARTAdaptedValue(18.0),
                                             allowDismissByPullDown: true,
                                             allowDismissByTapOnBackground: true,
                                             enableAutoHeight: false)
    }
}


/// 线块实体
public struct ARTActionSheetLineEntity {
    /// 线块颜色
    public var backgroundColor: UIColor
    /// 线块Size
    public var size: CGSize
    /// 线块圆角
    public var radius: CGFloat
    /// 是否隐藏顶部下拉线块
    public var showSeparatorLine: Bool
    
    
    // MARK: - Initialization
    
    public init(backgroundColor: UIColor, size: CGSize, radius: CGFloat, showSeparatorLine: Bool) {
        self.backgroundColor = backgroundColor
        self.size = size
        self.radius = radius
        self.showSeparatorLine = showSeparatorLine
    }
    
    /// 静态方法返回线块实体
    public static func allCharacter() -> ARTActionSheetLineEntity {
        return ARTActionSheetLineEntity(backgroundColor: .art_color(withHEXValue: 0xD8D8D8),
                                        size: ARTAdaptedSize(width: 28.0, height: 4.0),
                                        radius: ARTAdaptedValue(2.0),
                                        showSeparatorLine: false)
    }
}


/// 表单实体
public struct ARTActionSheetCollectionEntity {
    /// 表单背景色
    public var backgroundColor: UIColor
    /// 表单圆角
    public var radius: CGFloat
    /// 是否滚动
    public var scrolling: Bool
    /// 表单距离父视图边距，默认+安全区域
    public var contentInset: UIEdgeInsets
    /// 表单内边距
    public var sectionInsets: UIEdgeInsets
    /// 表单高度
    public var cellHeight: CGFloat
    /// 表单组背景色
    public var groupBackgroundColor: UIColor
    /// 组头距离上一个组尾的间距
    public var headerSpacing: CGFloat
    
    
    // MARK: - Initialization
    
    public init(backgroundColor: UIColor,
                radius: CGFloat,
                scrolling: Bool,
                contentInset: UIEdgeInsets,
                sectionInsets: UIEdgeInsets,
                cellHeight: CGFloat,
                groupBackgroundColor: UIColor,
                headerSpacing: CGFloat) {
        self.backgroundColor = backgroundColor
        self.radius = radius
        self.scrolling = scrolling
        self.contentInset = contentInset
        self.sectionInsets = sectionInsets
        self.cellHeight = cellHeight
        self.groupBackgroundColor = groupBackgroundColor
        self.headerSpacing = headerSpacing
    }
    
    /// 静态方法返回表单实体
    public static func allCharacter() -> ARTActionSheetCollectionEntity {
        let contentInset = UIEdgeInsets(top: ARTAdaptedValue(28.0), left: ARTAdaptedValue(12.0), bottom: ARTAdaptedValue(24.0), right: ARTAdaptedValue(12.0))
        let sectionInsets = UIEdgeInsets(top: 0.0, left: ARTAdaptedValue(24.0), bottom: 0.0, right: ARTAdaptedValue(24.0))
        return ARTActionSheetCollectionEntity(backgroundColor: .clear,
                                              radius: ARTAdaptedValue(8.0),
                                              scrolling: true,
                                              contentInset: contentInset,
                                              sectionInsets: sectionInsets,
                                              cellHeight: ARTAdaptedValue(44.0),
                                              groupBackgroundColor: .art_color(withHEXValue: 0xFCFCFC),
                                              headerSpacing: ARTAdaptedValue(12.0))
    }
}


/// 内容实体
public struct ARTActionSheetContentEntity {
    /// 文本
    public var text: String
    /// 文本字体
    public var textFont: UIFont
    /// 文本颜色
    public var textColor: UIColor
    /// 文本
    public var textAlignment: NSTextAlignment
    /// 分割颜色
    public var separatorLineColor: UIColor
    /// 是否显示分割线
    public var showSeparatorLine: Bool
    /// 文本上下左右间距
    public var textInset: UIEdgeInsets
    
    
    // MARK: - Initialization
    
    public init(text: String,
                textFont: UIFont,
                textColor: UIColor,
                textAlignment: NSTextAlignment,
                separatorLineColor: UIColor,
                showSeparatorLine: Bool,
                textInset: UIEdgeInsets) {
        self.text = text
        self.textFont = textFont
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.separatorLineColor = separatorLineColor
        self.showSeparatorLine = showSeparatorLine
        self.textInset = textInset
    }
    
    /// 静态方法返回包含所有内容信息的数组
    public static func allCharacters() -> [[ARTActionSheetContentEntity]] {
        let textFont = .art_medium(ARTAdaptedValue(14.0)) ?? UIFont.systemFont(ofSize: ARTAdaptedValue(14.0))
        let textColor = UIColor.art_color(withHEXValue: 0x000000)
        let separatorLineColor = UIColor.art_color(withHEXValue: 0xEEEEEE)
        let textInset = UIEdgeInsets(top: 0.0, left: ARTAdaptedValue(24.0), bottom: 0.0, right: ARTAdaptedValue(24.0))
        // 默认样式数组
        let defaultStyleItems = [
            ARTActionSheetContentEntity(text: "查看大图", textFont: textFont, textColor: textColor, textAlignment: .left, separatorLineColor: separatorLineColor, showSeparatorLine: true, textInset: textInset),
            ARTActionSheetContentEntity(text: "拍照", textFont: textFont, textColor: textColor, textAlignment: .left, separatorLineColor: separatorLineColor, showSeparatorLine: true, textInset: textInset),
            ARTActionSheetContentEntity(text: "从相册选择", textFont: textFont, textColor: textColor, textAlignment: .left, separatorLineColor: separatorLineColor, showSeparatorLine: false, textInset: textInset)
        ]
        // 分组样式数组
        let groupStyleItems = [
            ARTActionSheetContentEntity(text: "取消", textFont: textFont, textColor: textColor, textAlignment: .left, separatorLineColor: separatorLineColor, showSeparatorLine: false, textInset: textInset)
        ]
        return [defaultStyleItems, groupStyleItems]
    }
}

