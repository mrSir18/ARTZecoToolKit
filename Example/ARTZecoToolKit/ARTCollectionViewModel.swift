//
//  ARTCollectionViewModel.swift
//  ARTZecoToolKit_Example
//
//  Created by mrSir18 on 2024/7/13.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import ARTZecoToolKit

class ARTCollectionViewModel {
    
    // 分组数据结构
    public var collectionSections: [CollectionSectionProtocol] = []
    
    
    // MARK: - Life Cycle
    
    func loadData(completion: () -> Void) {
        if let result = requestJsonString().art_toDictionary() {
            guard let entity = ARTCollectionEntity.deserialize(from: result) else {return}
            configureSections(entity)
            completion()
        }
    }
    
    private func configureSections(_ entity: ARTCollectionEntity) {
        var sectionsArray: [CollectionSectionProtocol] = []
        
        // 组【头、脚】--> 全圆角
        let firstSection = FirstSection(entity)
        sectionsArray.append(firstSection)
        
        // 组【头、脚】--> 指定圆角
        let secondSection = SecondSection(entity)
        sectionsArray.append(secondSection)
        
        // 组【头、脚】--> 指定背景图
        let thirdSection = ThirdSection(entity)
        sectionsArray.append(thirdSection)
        
        // 组【头、脚】--> 全屏模式，可指定圆角，默认四个角
        let fourthSection = FourthSection(entity)
        sectionsArray.append(fourthSection)
        
        // Cell第0行说最后一行圆角 --> 可指定圆角，默认四个角
        let fifthSection = FifthSection(entity)
        sectionsArray.append(fifthSection)
        
        
        /// 阴影、边框等看配置模型自行测试
        ///
        collectionSections = sectionsArray
    }
}

// MARK: - Collection Section Protocol

extension ARTCollectionViewModel {
    
    struct FirstSection: CollectionSectionProtocol {
        var configModel: ARTCollectionViewConfigModel?  // 配置样式
        var collectionEntity: ARTCollectionEntity?      // 数据源
        let sectionType: CollectionSectionType          = .first
        var cellReuseIdentifiers: [String]
        let headerSize: CGSize                          = CGSize(width: UIScreen.art_currentScreenWidth, height: ARTAdaptedValue(48.0))
        let footerSize: CGSize                          = CGSize(width: UIScreen.art_currentScreenWidth, height: ARTAdaptedValue(48.0))
        var cellHeights: [CGFloat]
        let column: Int                                 = 3 // 3列
        let minimumLineSpacing: CGFloat                 = ARTAdaptedValue(12.0)
        let minimumInteritemSpacing: CGFloat            = ARTAdaptedValue(12.0)
        let sectionInsets: UIEdgeInsets                 = UIEdgeInsets(top: ARTAdaptedValue(12.0), left: ARTAdaptedValue(12.0), bottom: ARTAdaptedValue(12.0), right: ARTAdaptedValue(12.0))
        let spacingBetweenFooterAndNextHeader: CGFloat  = 0.0 // 距离上一个脚部视图的间距
        
        init(_ collectionEntity: ARTCollectionEntity?) {
            self.collectionEntity       = collectionEntity
            self.cellReuseIdentifiers   = Array(repeating: String(describing: ARTCollectionCell.self), count: 7) // cout: 7个itemCell，根据接口数据动态配置
            let randomCGFloats = (0..<7).map { _ in CGFloat(arc4random() % 3 + 1) * ARTAdaptedValue(44) }
            self.cellHeights = randomCGFloats // 随机高度，可改为数组，根据接口数据动态配置
            
            // 配置样式
            let entity: ARTCollectionViewConfigModel = ARTCollectionViewConfigModel()
            entity.cornerRadius         = ARTAdaptedValue(12.0)     // 圆角
            entity.backgroundColor      = .art_randomColor()        // 背景色
            entity.imageURLString       = ""                        // 背景图片
            self.configModel            = entity
        }
    }
    
    struct SecondSection: CollectionSectionProtocol {
        var configModel: ARTCollectionViewConfigModel?  // 配置样式
        var collectionEntity: ARTCollectionEntity?      // 数据源
        let sectionType: CollectionSectionType          = .second
        var cellReuseIdentifiers: [String]
        let headerSize: CGSize                          = CGSize(width: UIScreen.art_currentScreenWidth, height: ARTAdaptedValue(48.0))
        let footerSize: CGSize                          = CGSize(width: UIScreen.art_currentScreenWidth, height: ARTAdaptedValue(48.0))
        var cellHeights: [CGFloat]
        let column: Int                                 = 3 // 3列
        let minimumLineSpacing: CGFloat                 = ARTAdaptedValue(12.0)
        let minimumInteritemSpacing: CGFloat            = ARTAdaptedValue(12.0)
        let sectionInsets: UIEdgeInsets                 = UIEdgeInsets(top: ARTAdaptedValue(12.0), left: ARTAdaptedValue(12.0), bottom: ARTAdaptedValue(12.0), right: ARTAdaptedValue(12.0))
        let spacingBetweenFooterAndNextHeader: CGFloat  = ARTAdaptedValue(12.0) // 距离上一个脚部视图的间距
        
        init(_ collectionEntity: ARTCollectionEntity?) {
            self.collectionEntity       = collectionEntity
            self.cellReuseIdentifiers   = Array(repeating: String(describing: ARTCollectionCell.self), count: 7) // cout: 7个itemCell，根据接口数据动态配置
            let randomCGFloats = (0..<7).map { _ in ARTAdaptedValue(44) }
            self.cellHeights = randomCGFloats // 随机高度，可改为数组，根据接口数据动态配置
            
            // 配置样式
            let entity: ARTCollectionViewConfigModel = ARTCollectionViewConfigModel()
            entity.maskedCorners        = [.layerMinXMinYCorner, .layerMaxXMinYCorner] // 指定圆角
            entity.cornerRadius         = ARTAdaptedValue(12.0)     // 圆角
            entity.backgroundColor      = .art_randomColor()        // 背景色
            entity.imageURLString       = ""                        // 背景图片
            self.configModel            = entity
        }
    }
    
    struct ThirdSection: CollectionSectionProtocol {
        var configModel: ARTCollectionViewConfigModel?  // 配置样式
        var collectionEntity: ARTCollectionEntity?      // 数据源
        let sectionType: CollectionSectionType          = .third
        var cellReuseIdentifiers: [String]
        let headerSize: CGSize                          = CGSize(width: UIScreen.art_currentScreenWidth, height: ARTAdaptedValue(48.0))
        let footerSize: CGSize                          = CGSize(width: UIScreen.art_currentScreenWidth, height: ARTAdaptedValue(48.0))
        var cellHeights: [CGFloat]
        let column: Int                                 = 1 // 1列
        let minimumLineSpacing: CGFloat                 = ARTAdaptedValue(12.0)
        let minimumInteritemSpacing: CGFloat            = ARTAdaptedValue(12.0)
        let sectionInsets: UIEdgeInsets                 = UIEdgeInsets(top: ARTAdaptedValue(12.0), left: ARTAdaptedValue(12.0), bottom: ARTAdaptedValue(12.0), right: ARTAdaptedValue(12.0))
        let spacingBetweenFooterAndNextHeader: CGFloat  = ARTAdaptedValue(12.0) // 距离上一个脚部视图的间距
        
        init(_ collectionEntity: ARTCollectionEntity?) {
            self.collectionEntity       = collectionEntity
            self.cellReuseIdentifiers   = Array(repeating: String(describing: ARTCollectionCell.self), count: 3) // cout: 7个itemCell，根据接口数据动态配置
            let randomCGFloats = (0..<7).map { _ in ARTAdaptedValue(78.0) }
            self.cellHeights = randomCGFloats // 随机高度，可改为数组，根据接口数据动态配置
            
            // 配置样式
            let entity: ARTCollectionViewConfigModel = ARTCollectionViewConfigModel()
            entity.maskedCorners        = [.layerMinXMinYCorner, .layerMaxXMinYCorner] // 指定圆角
            entity.cornerRadius         = ARTAdaptedValue(12.0)     // 圆角
            entity.backgroundColor      = .art_randomColor()        // 背景色
            entity.imageURLString       = "https://p3.itc.cn/q_70/images01/20231108/c665b01b1a9743d598e27e926ff83f15.png" // 背景图片
            self.configModel            = entity
        }
    }
    
    struct FourthSection: CollectionSectionProtocol {
        var configModel: ARTCollectionViewConfigModel?  // 配置样式
        var collectionEntity: ARTCollectionEntity?      // 数据源
        let sectionType: CollectionSectionType          = .fourth
        var cellReuseIdentifiers: [String]
        let headerSize: CGSize                          = CGSize(width: UIScreen.art_currentScreenWidth, height: ARTAdaptedValue(48.0))
        let footerSize: CGSize                          = CGSize(width: UIScreen.art_currentScreenWidth, height: ARTAdaptedValue(48.0))
        var cellHeights: [CGFloat]
        let column: Int                                 = 2 // 1列
        let minimumLineSpacing: CGFloat                 = ARTAdaptedValue(12.0)
        let minimumInteritemSpacing: CGFloat            = ARTAdaptedValue(12.0)
        let sectionInsets: UIEdgeInsets                 = UIEdgeInsets(top: ARTAdaptedValue(12.0), left: ARTAdaptedValue(12.0), bottom: ARTAdaptedValue(12.0), right: ARTAdaptedValue(12.0))
        let spacingBetweenFooterAndNextHeader: CGFloat  = ARTAdaptedValue(12.0) // 距离上一个脚部视图的间距
        
        init(_ collectionEntity: ARTCollectionEntity?) {
            self.collectionEntity       = collectionEntity
            self.cellReuseIdentifiers   = Array(repeating: String(describing: ARTCollectionCell.self), count: 5) // cout: 7个itemCell，根据接口数据动态配置
            let randomCGFloats = (0..<7).map { _ in ARTAdaptedValue(78.0) }
            self.cellHeights = randomCGFloats // 随机高度，可改为数组，根据接口数据动态配置
            
            // 配置样式
            let entity: ARTCollectionViewConfigModel = ARTCollectionViewConfigModel()
            entity.isFullScreen         = true // 头、脚部全屏
            entity.cornerRadius         = ARTAdaptedValue(12.0)     // 圆角
            entity.backgroundColor      = .art_randomColor()        // 背景色
            entity.imageURLString       = "https://pic2.zhimg.com/v2-0c75f8743a93c88dac67ae0e76597c39_r.jpg" // 背景图片
            self.configModel            = entity
        }
    }
    
    struct FifthSection: CollectionSectionProtocol {
        var configModel: ARTCollectionViewConfigModel?  // 配置样式
        var collectionEntity: ARTCollectionEntity?      // 数据源
        let sectionType: CollectionSectionType          = .fifth
        var cellReuseIdentifiers: [String]
        let headerSize: CGSize                          = CGSize(width: UIScreen.art_currentScreenWidth, height: ARTAdaptedValue(48.0))
        let footerSize: CGSize                          = CGSize(width: UIScreen.art_currentScreenWidth, height: ARTAdaptedValue(48.0))
        var cellHeights: [CGFloat]
        let column: Int                                 = 2 // 1列
        let minimumLineSpacing: CGFloat                 = ARTAdaptedValue(12.0)
        let minimumInteritemSpacing: CGFloat            = ARTAdaptedValue(12.0)
        let sectionInsets: UIEdgeInsets                 = UIEdgeInsets(top: ARTAdaptedValue(12.0), left: ARTAdaptedValue(12.0), bottom: ARTAdaptedValue(12.0), right: ARTAdaptedValue(12.0))
        let spacingBetweenFooterAndNextHeader: CGFloat  = ARTAdaptedValue(12.0) // 距离上一个脚部视图的间距
        
        init(_ collectionEntity: ARTCollectionEntity?) {
            self.collectionEntity       = collectionEntity
            self.cellReuseIdentifiers   = Array(repeating: String(describing: ARTCollectionCell.self), count: 5) // cout: 7个itemCell，根据接口数据动态配置
            let randomCGFloats = (0..<7).map { _ in ARTAdaptedValue(78.0) }
            self.cellHeights = randomCGFloats // 随机高度，可改为数组，根据接口数据动态配置
            
            // 配置样式
            let entity: ARTCollectionViewConfigModel = ARTCollectionViewConfigModel()
            entity.collectionCornerMask = .art_layerAllCorner       // 可指定圆角，默认四个角
            entity.cornerRadius         = ARTAdaptedValue(12.0)     // 圆角
            entity.backgroundColor      = .art_randomColor()        // 背景色
            entity.imageURLString       = "https://img2.baidu.com/it/u=2053498362,2953193322&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=1062" // 背景图片
            self.configModel            = entity
        }
    }
}

// MARK: - Test Data

extension ARTCollectionViewModel {
    
    func requestJsonString() -> String {
        let jsonString = """
        {
            "title": "Test"
        }
        """
        return jsonString
    }
}
