//
//  ARTCarouselEntity.swift
//  ARTZecoToolKit_Example
//
//  Created by mrSir18 on 2024/7/20.
//  Copyright © 2024 CocoaPods. All rights reserved.
//


import ARTZecoToolKit

class ARTCarouselEntity {
    let scrollDirection: UICollectionView.ScrollDirection
    let imageURL: String
    let itemSize: CGSize
    let itemScale: CGFloat
    let minimumLineSpacing: CGFloat

    init(scrollDirection: UICollectionView.ScrollDirection, imageURL: String, itemSize: CGSize, itemScale: CGFloat, minimumLineSpacing: CGFloat) {
        self.scrollDirection = scrollDirection
        self.imageURL = imageURL
        self.itemSize = itemSize
        self.itemScale = itemScale
        self.minimumLineSpacing = minimumLineSpacing
    }

    // 第一种样式：自定义 item
    static func firstStyleArray() -> [ARTCarouselEntity] {
        let itemSize = CGSize(width: UIScreen.art_currentScreenWidth, height: ARTAdaptedValue(300.0))
        let imageURLs = [
            "https://img2.baidu.com/it/u=1623302349,1771329113&fm=253&fmt=auto&app=120&f=JPEG?w=800&h=800",
            "https://p3.itc.cn/q_70/images01/20231108/c665b01b1a9743d598e27e926ff83f15.png",
            "https://img2.baidu.com/it/u=2053498362,2953193322&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=1062",
            "https://pic.rmb.bdstatic.com/bjh/events/d709f3e4e2721baba01a537f96289a6f4297.jpeg@h_1280",
            "https://b0.bdstatic.com/ugc/B7pv_c36BMDAo9J4hD4Rwge89aa51c1283c7b47a86000a3dd017bd.jpg@h_1280"
        ]

        return imageURLs.map {
            ARTCarouselEntity(scrollDirection: .horizontal, imageURL: $0, itemSize: itemSize, itemScale: 1.0, minimumLineSpacing: 0.0)
        }
    }

    // 第二种样式：自定义 item
    static func secondStyleArray() -> [ARTCarouselEntity] {
        let configs: [(String, CGSize, CGFloat, CGFloat)] = [
            ("https://img2.baidu.com/it/u=1623302349,1771329113&fm=253&fmt=auto&app=120&f=JPEG?w=800&h=800", CGSize(width: 250.0, height: 270.0), 1.2, 12.0),
            ("https://p3.itc.cn/q_70/images01/20231108/c665b01b1a9743d598e27e926ff83f15.png", CGSize(width: 220.0, height: 170.0), 1.4, 10.0),
            ("https://img2.baidu.com/it/u=2053498362,2953193322&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=1062", CGSize(width: UIScreen.art_currentScreenWidth, height: 190.0), 1.0, 0.0),
            ("https://pic.rmb.bdstatic.com/bjh/events/d709f3e4e2721baba01a537f96289a6f4297.jpeg@h_1280", CGSize(width: 180.0, height: 180.0), 1.6, 24.0),
            ("https://b0.bdstatic.com/ugc/B7pv_c36BMDAo9J4hD4Rwge89aa51c1283c7b47a86000a3dd017bd.jpg@h_1280", CGSize(width: 150.0, height: 200.0), 1.2, 36.0)
        ]

        return configs.map {
            ARTCarouselEntity(scrollDirection: .horizontal, imageURL: $0.0, itemSize: $0.1, itemScale: $0.2, minimumLineSpacing: $0.3)
        }
    }

    // 第三种样式：自定义 item
    static func thirdStyleArray() -> [ARTCarouselEntity] {
        let itemSize = CGSize(width: UIScreen.art_currentScreenWidth - 12.0, height: ARTAdaptedValue(300.0))
        let imageURLs = [
            "https://img2.baidu.com/it/u=1623302349,1771329113&fm=253&fmt=auto&app=120&f=JPEG?w=800&h=800",
            "https://p3.itc.cn/q_70/images01/20231108/c665b01b1a9743d598e27e926ff83f15.png",
            "https://img2.baidu.com/it/u=2053498362,2953193322&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=1062",
            "https://pic.rmb.bdstatic.com/bjh/events/d709f3e4e2721baba01a537f96289a6f4297.jpeg@h_1280",
            "https://b0.bdstatic.com/ugc/B7pv_c36BMDAo9J4hD4Rwge89aa51c1283c7b47a86000a3dd017bd.jpg@h_1280"
        ]

        return imageURLs.map {
            ARTCarouselEntity(scrollDirection: .vertical, imageURL: $0, itemSize: itemSize, itemScale: 1.0, minimumLineSpacing: 12.0)
        }
    }

    // 第四种样式：自定义 item
    static func fourthStyleArray() -> [ARTCarouselEntity] {
        let itemSize = CGSize(width: UIScreen.art_currentScreenWidth, height: ARTAdaptedValue(200.0))
        let imageURLs = [
            "https://img2.baidu.com/it/u=1623302349,1771329113&fm=253&fmt=auto&app=120&f=JPEG?w=800&h=800",
            "https://p3.itc.cn/q_70/images01/20231108/c665b01b1a9743d598e27e926ff83f15.png",
            "https://img2.baidu.com/it/u=2053498362,2953193322&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=1062",
            "https://pic.rmb.bdstatic.com/bjh/events/d709f3e4e2721baba01a537f96289a6f4297.jpeg@h_1280",
            "https://b0.bdstatic.com/ugc/B7pv_c36BMDAo9J4hD4Rwge89aa51c1283c7b47a86000a3dd017bd.jpg@h_1280"
        ]

        return imageURLs.map {
            ARTCarouselEntity(scrollDirection: .vertical, imageURL: $0, itemSize: itemSize, itemScale: 1.0, minimumLineSpacing: 12.0)
        }
    }
    
    // 合并所有样式数组
    static func dataSource() -> [[ARTCarouselEntity]] {
        return [
            ARTCarouselEntity.firstStyleArray(),
            ARTCarouselEntity.secondStyleArray(),
            ARTCarouselEntity.thirdStyleArray(),
            ARTCarouselEntity.fourthStyleArray()
        ]
    }
}


