//
//  ARTCityPickerView.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/5/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import SnapKit

@objc public protocol ARTCityPickerViewProtocol: AnyObject {
    
    /// 城市选择器视图中选定项目时调用.
    ///
    /// - Parameters:
    ///   - citySelectorView: 城市选择器视图。
    ///   - cityName: 选定的城市名称
    @objc optional func citySelectorView(_ citySelectorView: ARTCityPickerView, didSelectItemAt cityName: String)
}

public class ARTCityPickerView: UIView {

    /// 遵循 ARTCityPickerViewProtocol 协议的弱引用委托对象.
    weak var delegate: ARTCityPickerViewProtocol?
    
    /// 数据源.处理
    var viewModel: ARTCityPickerViewModel = {
        return ARTCityPickerViewModel()
    }()
    
    /// 容器视图.
    private var containerView: UIView!
    
    /// 头部视图
    var headerView: ARTCityPickerHeader!
    
    /// 列表视图
    var collectionView: UICollectionView!
    
    
    // MARK: - Initialization
    
    public convenience init(_ delegate: ARTCityPickerViewProtocol) {
        self.init()
        self.backgroundColor = .clear
        self.delegate        = delegate
        setupViews()
    }
    
    private func setupViews() {
        // 创建遮罩视图
        let overlayView = UIView()
        overlayView.backgroundColor = .art_color(withHEXValue: 0x000000, alpha: 0.2)
        addSubview(overlayView)
        overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        overlayView.addGestureRecognizer(tapGesture)
        
        // 创建容器视图
        containerView = UIView()
        containerView.backgroundColor     = .white
        containerView.layer.cornerRadius  = ARTCityStyleConfiguration.default().cornerRadius
        containerView.layer.maskedCorners = ARTCityStyleConfiguration.default().maskedCorners
        containerView.clipsToBounds       = ARTCityStyleConfiguration.default().clipsToBounds
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalTo(overlayView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(ARTCityStyleConfiguration.default().containerHeight + art_safeAreaBottom())
        }
        
        // 创建头部视图
        headerView = ARTCityPickerHeader(self)
        containerView.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(ARTAdaptedValue(90.0))
        }
//        let headerView = ARTCityPickerHeader(self)
//        containerView.addSubview(headerView)
//        headerView.snp.makeConstraints { make in
//            make.left.top.right.equalTo(0.0)
//            make.height.equalTo(154.0)
//        }
        
        // 创建列表视图
        let layout = ARTCollectionViewFlowLayout(self)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator   = false
        collectionView.backgroundColor                = .white
        collectionView.delegate                       = self
        collectionView.dataSource                     = self
        collectionView.contentInset                   = UIEdgeInsets(top: 0.0, left: 0.0, bottom: art_safeAreaBottom(), right: 0.0)
        collectionView.registerCell(ARTCityPickerHotCell.self)
        collectionView.registerCell(ARTCityPickerCell.self)
        collectionView.registerSectionHeader(ARTCityPickerHotHeader.self)
        collectionView.registerSectionHeader(ARTSectionHeaderView.self)
        collectionView.registerSectionFooter(ARTSectionFooterView.self)
        containerView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
        }
    }
    
    // MARK: - Private Methods (UIPanGestureRecognizer)

    @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        removeCitySelector()
    }
}

// MARK: - Public Method

extension ARTCityPickerView {
    
    /// 创建并显示城市选择器.
    ///
    /// - Parameters:
    ///  - cityArray: 数据源数 组.
    ///  - hotArray: 热门城市数组.
    public func showCitySelector(_ cityName: String, 
                                 _ hotCities: [ARTCityPickerEntity],
                                 _ allCities: [ARTCityPickerEntity]) {
        viewModel.receiveData(cityName, hotCities, allCities) { cityNames in
            self.headerView.updateCitySelectorHeader(cityNames)
        }
        
        art_keyWindow.addSubview(self)
        self.snp.makeConstraints { make in
            make.size.equalTo(CGSizeMake(UIScreen.art_currentScreenWidth, 
                                         UIScreen.art_currentScreenHeight))
            make.left.top.equalToSuperview()
        }
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return}
            self.containerView.transform = CGAffineTransformTranslate(self.containerView.transform, 0, -ARTCityStyleConfiguration.default().containerHeight - art_safeAreaBottom())
        }
    }
    
    /// 移除城市选择器.
    public func removeCitySelector() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return}
            self.containerView.transform = CGAffineTransformTranslate(self.containerView.transform, 0, ARTCityStyleConfiguration.default().containerHeight + art_safeAreaBottom())
        } completion: { [weak self] finish in
            guard let self = self else { return}
            self.removeFromSuperview()
        }
    }
}

// MARK: - ARTCityPickerHeaderProtocol

extension ARTCityPickerView: ARTCityPickerHeaderProtocol {
    
    func didTapCloseCitySelector(_ headerView: ARTCityPickerHeader) {
        removeCitySelector()
    }
    
    func citySelectorElementKindHeader(_ headerView: ARTCityPickerHeader, didSelectItemAt index: Int) {
        viewModel.updateCitiesList(index: index)
        collectionView.reloadData()
    }
}
