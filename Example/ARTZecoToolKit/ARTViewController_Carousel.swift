//
//  ARTViewController_Carousel.swift
//  ARTZecoToolKit_Example
//
//  Created by mrSir18 on 2024/7/18.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import ARTZecoToolKit

class ARTViewController_Carousel: ARTBaseViewController {
    
    // 初始数据源
    private var dataSource: [[ARTCarouselEntity]] = ARTCarouselEntity.dataSource()
    
    // 样式一
    private var carouselEntity: [ARTCarouselEntity]!
    
    // 轮播图
    private var carouselView:ARTCarouselView!
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 创建测试按钮方法
        createButtons()
        
        // 创建轮播图
        carouselEntity = dataSource[0]
        carouselView = ARTCarouselView(self)
        carouselView.scrollDirection    = .horizontal   // 滚动方向 (默认为 .horizontal)
        carouselView.startIndex         = 2             // 起始位置 (默认为 0)
        carouselView.isAutoScroll       = true          // 是否自动滚动 (默认为 true)
        carouselView.isCycleScroll      = true          // 是否循环滚动 (默认为 true)
        carouselView.autoScrollInterval = 3.0           // 自动滚动时间间隔 (默认为 3.0)
        carouselView.backgroundColor    = .art_randomColor()
        view.addSubview(carouselView)
        carouselView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(-art_tabBarFullHeight())
            make.height.equalTo(ARTAdaptedValue(300.0))
        }
        carouselView.reloadData() // 刷新数据
    }
    
    // MARK: - 样式测试按钮
    
    private func createButtons() {

        // 按钮的配置信息
        let buttonConfigs: [String] = [
            ".horizontal 翻页轮播",
            ".horizontal 缩放比例",
            ".vertical 翻页轮播",
            ".vertical 缩放比例"
        ]

        let buttonWidth: CGFloat        = ARTAdaptedValue(150.0)
        let buttonHeight: CGFloat       = ARTAdaptedValue(80.0)
        let verticalSpacing: CGFloat    = ARTAdaptedValue(24.0)
        let horizontalSpacing: CGFloat  = ARTAdaptedValue(36.0)
        let topOffset: CGFloat          = art_navigationFullHeight() + ARTAdaptedValue(24.0)
        buttonConfigs.enumerated().forEach { index, title in
            let button = UIButton(type: .system)
            button.tag = index
            button.backgroundColor  = .gray
            button.titleLabel?.font = .art_medium(20.0)
            button.setTitle(title, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            view.addSubview(button)
            
            let row = index / 2
            let column = index % 2
            button.snp.makeConstraints { make in
                make.size.equalTo(ARTAdaptedSize(width: buttonWidth, height: buttonHeight))
                make.top.equalTo(topOffset + CGFloat(row) * (buttonHeight + verticalSpacing))
                if column == 0 {
                    make.centerX.equalTo(view.snp.centerX).offset(-((buttonWidth + horizontalSpacing) / 2))
                } else {
                    make.centerX.equalTo(view.snp.centerX).offset((buttonWidth + horizontalSpacing) / 2)
                }
            }
        }
    }
    
    @objc func buttonTapped(sender: UIButton) {
        carouselEntity = dataSource[sender.tag]
        carouselView.scrollDirection = carouselEntity[0].scrollDirection
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
        return carouselEntity.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { // Cell 数据
        if indexPath.row % 2 == 0 {
            let cell = collectionView.dequeueCell(for: indexPath) as ARTSecondCarouselCell
            cell.updateTitle("第 \(indexPath.row) 个")
            return cell
        }
        let cell = collectionView.dequeueCell(for: indexPath) as ARTFirstCarouselCell
        cell.loadImage(carouselEntity[indexPath.row].imageURL)
        return cell
    }
    
    // MARK: - 可选方法
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize { // Cell 大小
        return carouselEntity[indexPath.row].itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat { // 行间距
        return carouselEntity[section].minimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, scaleForItemAtIndexPath indexPath: IndexPath) -> CGFloat { // 缩放系数
        return carouselEntity[indexPath.row].itemScale
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
