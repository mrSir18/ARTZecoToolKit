//
//  ARTActionSheetStyleConfiguration.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/7/2.
//

/// 自定义UI样式配置
@objcMembers
public class ARTActionSheetStyleConfiguration: NSObject {
    
    private static var single = ARTActionSheetStyleConfiguration()
    
    public class func `default`() -> ARTActionSheetStyleConfiguration {
        return ARTActionSheetStyleConfiguration.single
    }
    
    public class func resetConfiguration() {
        ARTActionSheetStyleConfiguration.single = ARTActionSheetStyleConfiguration()
    }
    
    /// 容器样式实体.
    ///
    /// - Note: 默认allCharacter().
    private var pri_containerEntity: ARTActionSheetContainerEntity = ARTActionSheetContainerEntity.allCharacter()
    public var containerEntity: ARTActionSheetContainerEntity {
        get {
            pri_containerEntity
        }
        set {
            pri_containerEntity = newValue
        }
    }
    
    /// 线块样式实体.
    ///
    /// - Note: 默认allCharacter().
    private var pri_lineEntity: ARTActionSheetLineEntity = ARTActionSheetLineEntity.allCharacter()
    public var lineEntity: ARTActionSheetLineEntity {
        get {
            pri_lineEntity
        }
        set {
            pri_lineEntity = newValue
        }
    }
    
    /// 表单样式实体.
    ///
    /// - Note: 默认allCharacter().
    private var pri_collectionEntity: ARTActionSheetCollectionEntity = ARTActionSheetCollectionEntity.allCharacter()
    public var collectionEntity: ARTActionSheetCollectionEntity {
        get {
            pri_collectionEntity
        }
        set {
            pri_collectionEntity = newValue
        }
    }
    
    /// 内容样式实体二维数组.
    ///
    /// - Note: 默认allCharacters().
    private var pri_contentEntitys: [[ARTActionSheetContentEntity]] = ARTActionSheetContentEntity.allCharacters()
    public var contentEntitys: [[ARTActionSheetContentEntity]] {
        get {
            pri_contentEntitys
        }
        set {
            pri_contentEntitys = newValue
        }
    }
    // 根据需要添加更多的属性表.
}
