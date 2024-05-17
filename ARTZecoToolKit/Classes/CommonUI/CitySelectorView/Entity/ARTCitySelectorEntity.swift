//
//  ARTCitySelectorEntity.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/5/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import SmartCodable

public class ARTCitySelectorEntity: SmartCodable {
    
    var id: String = ""
    var pid: Int = 0
    var deep: Int = 0
    var name: String = ""
    var pinyin: String = ""
    var pinyin_prefix: String = ""
    var ext_id: String = ""
    var ext_name: String = ""
    var childs: [ARTCitySelectorEntity] = []
    
    required public init() {
        
    }

    public func didFinishMapping() {
        pinyin_prefix = pinyin_prefix.uppercased()
    }
}
