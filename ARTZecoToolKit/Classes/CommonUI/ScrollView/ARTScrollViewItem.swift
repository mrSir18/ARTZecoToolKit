//
//  ARTScrollViewItem.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/5/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import SmartCodable

public struct ARTScrollViewItem: SmartCodable {
    
    public var id: String?          // ID
    public var title: String?       // 标题
    public var desc: String?        // 描述
    public var imageUrl: String?    // 图片
    public var videoUrl: String?    // 视频
    public var linkUrl: String?     // H5链接
    @SmartAny
    public var extParams: Any?      // 扩展参数
    
    public init() {
        
    }
    
    public init(id: String?, title: String? = nil, desc: String? = nil, imageUrl: String? = nil, videoUrl: String? = nil, linkUrl: String? = nil, extParams: Any? = nil) {
        self.id         = id
        self.title      = title
        self.desc       = desc
        self.imageUrl   = imageUrl
        self.videoUrl   = videoUrl
        self.linkUrl    = linkUrl
        self.extParams  = extParams
    }
}
