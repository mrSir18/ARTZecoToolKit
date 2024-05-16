//
//  ARTCitySelectorViewModel.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/5/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

/// 城市选择器模式.
enum ARTCitySelectorType: Int {
    /// 默认值.
    case none       = 0
    /// 热门城市.
    case hotCities  = 1
    /// 所有城市.
    case allCities  = 2
}

extension ARTCitySelectorViewModel {
    
    /// 配置模型.
    struct LayoutConfig {
        let sectionType: ARTCitySelectorType
        let columnCount: Int
        let itemHeight: CGFloat
        let insets: UIEdgeInsets
        let lineSpacing: CGFloat
        let interitemSpacing: CGFloat
        let headerSize: CGSize
        let footerSize: CGSize
    }
}

struct ARTCitySelectorViewModel {

    /// 热门城市数组.
    var hotCities: [ARTCitySelectorEntity] = []
    var hotLastSelectedIndex: IndexPath?
    
    /// 所有城市数组.
    var originaAllCities: [[Int: [ARTCitySelectorEntity]]] = [] 
    var allCities: [ARTCitySelectorEntity] = []
    var cityLastSelectedIndex: IndexPath?
    
    /// collectionView配置数组.
    var layoutConfigs: [LayoutConfig] = []
    
    /// 是否点击标题按钮回滚数据
    var isShouldRollback: Bool = false
    
    /// 记录最后一次点击的所有城市列表
    var lastAllCities: [ARTCitySelectorEntity] = []
    
    ///  点击标题按钮的索引
    var clickTitleCitiesIndex: Int!

    /// 配置模型.
    ///
    /// - Parameters:
    ///  - cityName: 历史设置的城市名称.
    ///  - hotCities: 热门城市数组.
    ///  - allCities: 所有城市数组.
    mutating func receiveData(_ cityName: String,
                              _ hotCityArray: [ARTCitySelectorEntity],
                              _ allCityArray: [ARTCitySelectorEntity],
                              swapCityNames: @escaping ([String]) -> Void) {
        allCities = private_sortCityArray(allCityArray)
        private_clearDuplicatePrefixes(in: &allCities)
        hotCities = hotCityArray
    
        /// 配置布局.
        setConfigureLayout()
        
        /// 恢复城市历史设置名称.
        restoreCityHistoryName(cityName, swapCityNames: swapCityNames)
    }
    
    mutating func setConfigureLayout() {
        layoutConfigs = []
        
        // 热门城市
        private_configureLayout(for:
                                    hotCities,
                                sectionType: .hotCities,
                                columnCount: 4,
                                itemHeight: 37.0,
                                insets: UIEdgeInsets(top: 0.0, left: 18.0, bottom: 0.0, right: 18.0),
                                lineSpacing: 8.0,
                                interitemSpacing: 8.0,
                                headerSize: CGSize(width: UIScreen.art_currentScreenWidth, height: 52.0),
                                footerSize: .zero)
        
        // 所有城市.
        private_configureLayout(for:
                                    allCities,
                                sectionType: .allCities,
                                columnCount: 1,
                                itemHeight: 45.0,
                                insets: .zero,
                                lineSpacing: 0.0,
                                interitemSpacing: 0.0,
                                headerSize: CGSize(width: UIScreen.art_currentScreenWidth, height: 12.0),
                                footerSize: .zero)
    }
    
    /// 更新城市历史设置名称
    /// - Parameters:
    ///  - cityName: 城市名称
    mutating func restoreCityHistoryName(_ cityName: String!, swapCityNames: @escaping ([String]) -> Void) {
        let maxLevels = ARTCityStyleConfiguration.default().maxLevels
        if let cityName = cityName, !cityName.isEmpty {
            var buttonTitle: [String] = cityName.components(separatedBy: " ")
            if buttonTitle.count > maxLevels {
                buttonTitle.removeLast(buttonTitle.count - maxLevels)
            } else {
                buttonTitle[buttonTitle.count - 1] = "请选择"
            }
            
            if buttonTitle.count == maxLevels {
                // 切换城市时，移除热门城市
                layoutConfigs.removeAll { $0.sectionType == .hotCities}
                swapCityNames(buttonTitle)
                
                // 递归查找历史设定的城市
                if let lastIndex = private_findIndexAndUpdateAllCities(in: &allCities, withButtonTitle: buttonTitle, andIndex: 0, into: &originaAllCities) {
                    // 热门城市下标
                    hotLastSelectedIndex = IndexPath(item: originaAllCities.first!.keys.first!, section: 0)
                    allCities = originaAllCities.last!.values.first!
                    cityLastSelectedIndex = lastIndex
                }
                
                // 查找热门城市下标
                if let keyIndex = originaAllCities[1].keys.first,
                    let entity = originaAllCities[1].values.first?[keyIndex],
                    let hotIndex = hotCities.firstIndex(where: { $0.id == entity.id }) {
                    hotLastSelectedIndex = IndexPath(item: hotIndex, section: 0)
                } else {
                    hotLastSelectedIndex = nil
                }

            }
        }
    }

    /// 获取城市类型.
    ///
    /// - Parameters:
    ///  - section: 索引.
    /// - Returns: 城市类型.
    public func cityType(for section: Int) -> ARTCitySelectorType {
        return layoutConfigs[section].sectionType
    }
    
    /// 获取城市数量.
    /// 
    /// - Parameters:
    ///  - indexPath: 索引.
    ///  - sectionType: 类型.
    ///  - cityName: 城市名.
    ///  - completion: 完成回调.
    ///  - Returns: 城市数组，完整城市名..
    mutating func addToOriginalAllCities(_ indexPath: IndexPath,
                                         _ sectionType: ARTCitySelectorType,
                                         cityName: @escaping ([String]) -> Void,
                                         completion: @escaping ([[Int: [ARTCitySelectorEntity]]], _ fullCityName: String) -> Void) {
        guard indexPath.row < allCities.count else {
            print("indexPath 越界")
            return
        }
        
        if isShouldRollback {
            hotLastSelectedIndex = nil
            cityLastSelectedIndex = nil
            isShouldRollback = false
            originaAllCities = Array(originaAllCities.prefix(clickTitleCitiesIndex!))
        }
        
        // 检查 originaAllCities 数组是否已达到最大级别
        let maxLevels = ARTCityStyleConfiguration.default().maxLevels
        if originaAllCities.count == maxLevels {
            originaAllCities.removeLast()
        }

        var clickIndexPath = indexPath
        var hotCityEntity: ARTCitySelectorEntity!
        if sectionType == .hotCities {
            hotLastSelectedIndex = clickIndexPath
            hotCityEntity = hotCities[indexPath.row]
            for (index, city) in allCities.enumerated() {
                if hotCityEntity.pid == city.id {
                    // 添加城市名
                    clickIndexPath = IndexPath(item: index, section: indexPath.section)
                    originaAllCities.append([index: allCities])
                    break
                }
            }
        } else {
            originaAllCities.append([indexPath.row: allCities])
            // 如果 originaAllCities 的数量为 2，且点击的城市为第二个城市，更新HotCities
            if originaAllCities.count == 2 {
                if let index = hotCities.firstIndex(where: { $0.id == allCities[indexPath.row].id }) {
                    hotLastSelectedIndex = IndexPath(item: index, section: 0)
                }
            }
        }
        // 切换城市时，移除热门城市
        layoutConfigs.removeAll { $0.sectionType == .hotCities}
        
        var fullCityName: String! = ""
        for city in originaAllCities {
            for (key, value) in city {
                fullCityName.append(value[key].ext_name + " ")
            }
        }
        
        // 按钮标题
        var buttonTitle: [String] = fullCityName.components(separatedBy: " ")
        if buttonTitle.count > maxLevels {
            buttonTitle.removeLast(buttonTitle.count - maxLevels)
        } else {
            buttonTitle[buttonTitle.count - 1] = "请选择"
        }
        cityName(buttonTitle)

        // 如果 originaAllCities 的数量还未达到最大级别，更新 allCities
        if originaAllCities.count < maxLevels {
            allCities = allCities[clickIndexPath.row].childs
            lastAllCities = allCities
            
            if sectionType == .hotCities {
                if let index = allCities.firstIndex(where: { $0.id == hotCityEntity.id }) {
                    // 添加城市名
                    fullCityName.append(allCities[index].ext_name + " ")
                    originaAllCities.append([index: allCities])
                    allCities = allCities[index].childs
                    lastAllCities = allCities
                    
                    // 按钮标题
                    var buttonTitle: [String] = fullCityName.components(separatedBy: " ")
                    if buttonTitle.count > maxLevels {
                        buttonTitle.removeLast(buttonTitle.count - maxLevels)
                    } else {
                        buttonTitle[buttonTitle.count - 1] = "请选择"
                    }
                    cityName(buttonTitle)
                }
                
            } else {
                if allCities.count == 1 && allCities[0].childs.count > 0 {
                    fullCityName.append(allCities[0].ext_name + " ")
                    originaAllCities.append([0: allCities])
                    if let index = hotCities.firstIndex(where: { $0.id == allCities[0].id }) {
                        hotLastSelectedIndex = IndexPath(item: index, section: 0)
                    }
                    allCities = allCities[0].childs
                    lastAllCities = allCities
                    
                    // 按钮标题
                    var buttonTitle: [String] = fullCityName.components(separatedBy: " ")
                    if buttonTitle.count > maxLevels {
                        buttonTitle.removeLast(buttonTitle.count - maxLevels)
                    } else {
                        buttonTitle[buttonTitle.count - 1] = "请选择"
                    }
                    cityName(buttonTitle)
                }
            }
        } else {
            completion(originaAllCities, fullCityName!)
        }
    }
    
    /// 更新城市列表.
    ///
    /// - Parameters:
    /// - index: 索引.
    mutating func updateCitiesList(index: Int) {
        // 更新点击的城市索引
        clickTitleCitiesIndex = index
        
        // 检查是否需要回滚
        isShouldRollback = index < originaAllCities.count
        
        if index == 0 {
            setConfigureLayout()
        } else {
            // 切换城市时，移除热门城市
            layoutConfigs.removeAll { $0.sectionType == .hotCities}
        }
        
        // 更新已选城市列表
        for (sectionIndex, _) in layoutConfigs.enumerated() {
            if cityType(for: sectionIndex) == .allCities {
                // 如果索引超出原始城市列表范围，则置空最后选中索引，否则更新全部城市的最后选中索引
                cityLastSelectedIndex = index < originaAllCities.count ?
                    IndexPath(item: originaAllCities[index].keys.first ?? 0, section: sectionIndex) : nil
                break
            }
        }
        // 更新所有城市列表
        allCities = isShouldRollback ? originaAllCities[index].values.first ?? [] : lastAllCities
    }
}

// MARK: - Private Method.

extension ARTCitySelectorViewModel {
    
    /// 配置布局.
    ///
    /// - Parameters:
    ///  - cities: 城市数组.
    ///  - sectionType: 模式.
    ///  - columnCount: 列数.
    ///  - itemHeight: item高度.
    ///  - insets: 内边距.
    ///  - lineSpacing: 行间距.
    ///  - interitemSpacing: item间距.
    ///  - headerSize: header大小.
    ///  - footerSize: footer大小.
    /// - Note: 如果cities为空, 则不会添加配置.
    private mutating func private_configureLayout(for
                                                  cities: [ARTCitySelectorEntity],
                                                  sectionType: ARTCitySelectorType,
                                                  columnCount: Int,
                                                  itemHeight: CGFloat,
                                                  insets: UIEdgeInsets,
                                                  lineSpacing: CGFloat,
                                                  interitemSpacing: CGFloat,
                                                  headerSize: CGSize,
                                                  footerSize: CGSize) {
        if !cities.isEmpty {
            layoutConfigs.append(LayoutConfig(sectionType: sectionType,
                                              columnCount: columnCount,
                                              itemHeight: itemHeight,
                                              insets: insets,
                                              lineSpacing: lineSpacing,
                                              interitemSpacing: interitemSpacing,
                                              headerSize: headerSize,
                                              footerSize: footerSize))
        }
    }
    
    
    private func private_findIndexAndUpdateAllCities(in allCities: inout [ARTCitySelectorEntity],
                                                     withButtonTitle buttonTitle: [String],
                                                     andIndex index: Int,
                                                     into originaAllCities: inout [[Int: [ARTCitySelectorEntity]]]) -> IndexPath? {
        guard let indexInAllCities = allCities.firstIndex(where: { $0.ext_name == buttonTitle[index] }) else {
            return nil
        }
        
        originaAllCities.append([indexInAllCities: allCities])
        allCities = allCities[indexInAllCities].childs
        
        if index == buttonTitle.count - 1 {
            return IndexPath(item: indexInAllCities, section: 0)
        } else {
            return private_findIndexAndUpdateAllCities(in: &allCities, withButtonTitle: buttonTitle, andIndex: index + 1, into: &originaAllCities)
        }
    }
    
    /// 对城市数组进行排序.
    /// - Parameter cityArray: 城市数组.
    /// - Returns: 排序后的城市数组.
    /// - Note: 递归排序.
    /// - Note: 递归排序的逻辑为: 先对当前数组进行排序, 然后对子数组进行排序.
    /// - Note: 递归排序的终止条件为: 子数组为空.
    private mutating func private_sortCityArray(_ cityArray: [ARTCitySelectorEntity]) -> [ARTCitySelectorEntity] {
        return cityArray.sorted { (city1, city2) -> Bool in
            return city1.pinyin < city2.pinyin
        }.map { city in
            let sortedCity = city
            sortedCity.childs = private_sortCityArray(city.childs)
            return sortedCity
        }
    }
    
    /// 清除重复的前缀.
    /// - Parameter cities: 城市数组.
    /// - Returns: 去重后的城市数组.
    /// - Note: 去重逻辑为: 如果前缀已经存在, 则将前缀置为空.
    /// - Note: 前缀为空的城市将会被分到独立的section中.
    private func private_clearDuplicatePrefixes(in cities: inout [ARTCitySelectorEntity]) {
        var seenPrefixes: Set<String> = Set()
        
        for city in cities {
            if !city.pinyin_prefix.isEmpty {
                if seenPrefixes.contains(city.pinyin_prefix) {
                    city.pinyin_prefix = ""
                } else {
                    seenPrefixes.insert(city.pinyin_prefix)
                }
            }
            if !city.childs.isEmpty {
                private_clearDuplicatePrefixes(in: &city.childs)
            }
        }
    }
}
