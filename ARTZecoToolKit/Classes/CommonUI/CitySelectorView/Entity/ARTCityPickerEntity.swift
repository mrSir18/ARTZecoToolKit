//
//  ARTCityPickerEntity.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/5/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import SmartCodable

public class ARTCityPickerEntity: SmartCodable {
    
    var id: String                      = "" /// Id
    var pid: Int                        = 0  /// 父级Id
    var pinyin: String                  = "" /// 拼音
    var pinyin_prefix: String           = "" /// 拼音首字母
    var ext_name: String                = "" /// 城市名字
    var childs: [ARTCityPickerEntity] = []

    required public init() {
        
    }
    
    // MARK: - SmartCodable
    
    public func didFinishMapping() {
        pinyin_prefix = pinyin_prefix.uppercased()
    }
    
    public static func mappingForKey() -> [SmartKeyTransformer]? {[
        CodingKeys.id                   <--- ["provinceId",         "cityId",       "countryId",        "streetId"],
        CodingKeys.pinyin               <--- ["provincePinYin",     "cityPinYin",   "countryPinYin",    "streetPinYin"],
        CodingKeys.pinyin_prefix        <--- ["provincePrefix",     "cityPrefix",   "countryPrefix",    "streetPrefix"],
        CodingKeys.ext_name             <--- ["provinceName",       "cityName",     "countryName",      "streetName"]
    ]}
}





// MARK: 热门城市数

public class ARTCityPickerHotEntity: SmartCodable {

    var provinceInfo: ARTCityPickerEntity = ARTCityPickerEntity() /// 省份信息
    var cityInfo: ARTCityPickerEntity     = ARTCityPickerEntity() /// 城市信息

    required public init() {
        
    }
}
