//
//  ARTScrollViewItem.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/5/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

// MARK: - 滚动视图管理类
public struct ARTScrollViewItem {
    public let id: String
    public let imageUrl: String
    public let videoUrl: String
    public let h5Link: String
    
    public init(id: String = "", imageUrl: String = "", videoUrl: String = "", h5Link: String = "") {
        self.id         = id
        self.imageUrl   = imageUrl
        self.videoUrl   = videoUrl
        self.h5Link     = h5Link
    }
}

