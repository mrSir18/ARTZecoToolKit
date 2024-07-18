//
//  ARTViewController_Carousel.swift
//  ARTZecoToolKit_Example
//
//  Created by mrSir18 on 2024/7/18.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import ARTZecoToolKit

class ARTViewController_Carousel: ARTBaseViewController {
    
    // 数据源
    private let photos: [Any] = [
        URL(string: "https://img2.baidu.com/it/u=1623302349,1771329113&fm=253&fmt=auto&app=120&f=JPEG?w=800&h=800")!,
        URL(string: "https://p3.itc.cn/q_70/images01/20231108/c665b01b1a9743d598e27e926ff83f15.png")!,
        URL(string: "https://img2.baidu.com/it/u=2053498362,2953193322&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=1062")!,
        URL(string: "https://pic.rmb.bdstatic.com/bjh/events/d709f3e4e2721baba01a537f96289a6f4297.jpeg@h_1280")!,
        URL(string: "https://b0.bdstatic.com/ugc/B7pv_c36BMDAo9J4hD4Rwge89aa51c1283c7b47a86000a3dd017bd.jpg@h_1280")!
    ]
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 创建轮播图
        let carouselView = ARTCarouselView(self)
        carouselView.scrollDirection = .vertical
        carouselView.startIndex = 2
        carouselView.isAutoScroll = true
        carouselView.isCycleScroll = true
        carouselView.autoScrollInterval = 3.0
        carouselView.backgroundColor = .gray
        view.addSubview(carouselView)
        carouselView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(ARTAdaptedValue(300.0))
        }
        carouselView.reloadData()
    }
}

// MARK: - ARTCarouselViewProtocol

extension ARTViewController_Carousel: ARTCarouselViewProtocol {
    
    func registerCells(for collectionView: UICollectionView) { // 注册cell
        collectionView.registerCell(ARTFirstCarouselCell.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(for: indexPath) as ARTFirstCarouselCell
        cell.loadImage(photos[indexPath.row] as! URL)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
