//
//  ARTActionSheetStyleConfiguration+Chaining.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/7/2.
//

public extension ARTActionSheetStyleConfiguration {
    @discardableResult
    func containerEntity(_ entity: ARTActionSheetContainerEntity) -> ARTActionSheetStyleConfiguration {
        containerEntity = entity
        return self
    }
    
    @discardableResult
    func lineEntity(_ entity: ARTActionSheetLineEntity) -> ARTActionSheetStyleConfiguration {
        lineEntity = entity
        return self
    }
    
    @discardableResult
    func collectionEntity(_ entity: ARTActionSheetCollectionEntity) -> ARTActionSheetStyleConfiguration {
        collectionEntity = entity
        return self
    }
    
    @discardableResult
    func contentEntitys(_ entitys: [[ARTActionSheetContentEntity]]) -> ARTActionSheetStyleConfiguration {
        contentEntitys = entitys
        return self
    }
}
