//
//  ARTCitySelectorEntity.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/5/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import HandyJSON

public class ARTCitySelectorEntity: HandyJSON {
    
    var id: String = ""
    var pid: String = ""
    var deep: String = ""
    var name: String = ""
    var pinyin: String = ""
    var pinyin_prefix: String = ""
    var ext_id: String = ""
    var ext_name: String = ""
    var childs: [ARTCitySelectorEntity] = []
    
    required public init() {
        
    }

    public func mapping(mapper: HelpingMapper) {
        /// 重新映射大写拼音前缀
        mapper <<<
            self.pinyin_prefix <-- TransformOf<String, String>(fromJSON: { (value: String?) -> String? in
                return value?.uppercased()
            }, toJSON: { (value: String?) -> String? in
                return value
            })
    }
}
