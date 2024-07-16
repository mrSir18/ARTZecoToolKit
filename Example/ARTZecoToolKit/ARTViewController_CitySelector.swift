//
//  ARTViewController_CitySelector.swift
//  ARTZecoToolKit_Example
//
//  Created by mrSir18 on 2024/5/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import ARTZecoToolKit

class ARTViewController_CitySelector: ARTBaseViewController {

    /// 热门城市数
    private var hotCities: [ARTCitySelectorEntity] = []
    
    /// 城市数据源
    private var allCities: [ARTCitySelectorEntity] = []
    
    /// 城市名称
    var cityName: String = ""
    
    /// 城市选择器按钮
    private lazy var citySelectorButton: ARTAlignmentButton = {
        let button = ARTAlignmentButton(type: .custom)
        button.titleLabel?.font = .art_regular(16.0)
        button.backgroundColor  = .art_randomColor()
        button.setTitle("选择城市", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(citySelectorButtonAction), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 解析城市数据
        parseCityData()
        
        // 创建城市选择器按钮
        view.addSubview(citySelectorButton)
        citySelectorButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.centerX.centerY.equalToSuperview()
            make.height.equalTo(200.0)
        }
    }
    
    @objc private func citySelectorButtonAction () {
        let citySelectorView = ARTCitySelectorView(self)
        citySelectorView.showCitySelector(cityName, hotCities, allCities)
    }
    
    /// 解析城市数据
    private func parseCityData () {
        DispatchQueue.global().async {
            guard let hotFilePath = Bundle.main.path(forResource: "hot_area_format_user", ofType: "json"),
                  let hotJsonData = try? Data(contentsOf: URL(fileURLWithPath: hotFilePath)),
                  let hotJsonString = String(data: hotJsonData, encoding: .utf8),
                  let hotCityArray = [ARTCitySelectorEntity].deserialize(from: hotJsonString) else {
                DispatchQueue.main.async {
                    print("解析失败")
                }
                return
            }
            
            guard let filePath = Bundle.main.path(forResource: "area_format_user", ofType: "json"),
                  let jsonData = try? Data(contentsOf: URL(fileURLWithPath: filePath)),
                  let jsonString = String(data: jsonData, encoding: .utf8),
                  let allCityArray = [ARTCitySelectorEntity].deserialize(from: jsonString) else {
                DispatchQueue.main.async {
                    print("解析失败")
                }
                return
            }
            
            DispatchQueue.main.async {
                self.hotCities = hotCityArray
                self.allCities = allCityArray
                print("解析成功")
            }
        }
    }
}

// MARK: - ARTCitySelectorViewProtocol

extension ARTViewController_CitySelector: ARTCitySelectorViewProtocol {

    public func citySelectorView(_ citySelectorView: ARTCitySelectorView, didSelectItemAt cityName: String) {
        self.cityName = cityName
        citySelectorButton.setTitle(self.cityName, for: .normal)
    }
}

