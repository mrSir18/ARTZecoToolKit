//
//  ARTScrollViewItem.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/5/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

public struct ARTScrollViewItem {
    
    public let id: String?          // ID
    public let title: String?       // 标题
    public let desc: String?        // 描述
    public let imageUrl: String?    // 图片
    public let videoUrl: String?    // 视频
    public let linkUrl: String?     // H5链接
    
    public init(id: String?, title: String?, desc: String?, imageUrl: String?, videoUrl: String?, linkUrl: String?) {
        self.id         = id
        self.title      = title
        self.desc       = desc
        self.imageUrl   = imageUrl
        self.videoUrl   = videoUrl
        self.linkUrl    = linkUrl
    }
}

