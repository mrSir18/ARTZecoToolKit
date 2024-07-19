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
            make.height.equalTo(ARTAdaptedValue(250))
        }
        carouselView.reloadData()
    }
}

// MARK: - ARTCarouselViewProtocol

extension ARTViewController_Carousel: ARTCarouselViewProtocol {
    
    // MARK: - 必选方法
    
    func registerCells(for collectionView: UICollectionView) { // 注册 Cell.
        collectionView.registerCell(ARTFirstCarouselCell.self)
        collectionView.registerCell(ARTSecondCarouselCell.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { // Cell 数量
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { // Cell 数据
        if indexPath.row % 2 == 0 {
            let cell = collectionView.dequeueCell(for: indexPath) as ARTSecondCarouselCell
            cell.updateTitle("第 \(indexPath.row) 个")
            return cell
        }
        let cell = collectionView.dequeueCell(for: indexPath) as ARTFirstCarouselCell
        cell.loadImage(photos[indexPath.row] as! URL)
        return cell
    }
    
    // MARK: - 可选方法
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize { // Cell 大小
        return ARTAdaptedSize(width: 200.0, height: 150.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat { // 行间距
        return ARTAdaptedValue(12.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat { // 列间距
        return ARTAdaptedValue(12.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, scaleForItemAtIndexPath indexPath: IndexPath) -> CGFloat { // 缩放系数
        return 1.4
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { // 点击事件
        print("点击了第 \(indexPath.row) 个")
    }
    
    func carouselView(_ carouselView: ARTCarouselView, didBeginDraggingItemAt index: Int) { // 开始拖拽
        print("开始拖拽第 \(index) 个")
    }
    
    func carouselView(_ carouselView: ARTCarouselView, didEndScrollingAnimationAt index: Int) { // 结束滚动
        print("结束滚动第 \(index) 个")
    }
    
    func carouselView(_ carouselView: ARTCarouselView, didScrollToItemAt index: Int) {
//        print("滚动到第 \(index) 个")
    }
}
