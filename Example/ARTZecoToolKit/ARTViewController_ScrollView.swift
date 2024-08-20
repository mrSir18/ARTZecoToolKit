//
//  ARTViewController_ScrollView.swift
//  ARTZecoToolKit_Example
//
//  Created by mrSir18 on 2024/5/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import ARTZecoToolKit

class ARTViewController_ScrollView: ARTBaseViewController {

    /// 轮播数据源
    private let dataSources: [ARTScrollViewItem] = [
        ARTScrollViewItem(id: "1", title: "", desc: "", imageUrl: "https://b0.bdstatic.com/9a718281687090415ea88d65e823488f.jpg@h_1280", videoUrl: "", linkUrl: "", extParams: "1"),
        ARTScrollViewItem(id: "2", title: "", desc: "", imageUrl: "2", videoUrl: "", linkUrl: "", extParams: ["nickName" : "mrSir18"]),
        ARTScrollViewItem(id: "3", title: "", desc: "", imageUrl: "https://b0.bdstatic.com/9a718281687090415ea88d65e823488f.jpg@h_1280", videoUrl: "", linkUrl: "", extParams: ""),
        ARTScrollViewItem(id: "4", title: "", desc: "", imageUrl: "https://img.soogif.com/5mSGKbh6tQKlCBJdxmbdUC0ceSPT9oCR.JPEG", videoUrl: "", linkUrl: "", extParams: ""),
        ARTScrollViewItem(id: "5", title: "", desc: "", imageUrl: "2", videoUrl: "", linkUrl: "", extParams: "")
    ]
    
    private var pageControl: UIPageControl!
    
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// 自定义轮播视图
        let scrollView = ARTScrollView(self)
        scrollView.interval = 3.0
        scrollView.backgroundColor = . art_randomColor()
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(baseContainerView.snp.bottom)
            make.left.bottom.right.equalToSuperview()
        }
        scrollView.dataSources = dataSources
        
        /// 页码视图
        pageControl = UIPageControl(frame: .zero)
        pageControl.numberOfPages = dataSources.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .red
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.isUserInteractionEnabled = false
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(scrollView.snp.bottom).offset(-50.0)
            make.left.right.equalToSuperview()
            make.height.equalTo(50.0)
        }
    }
}

// MARK: - ARTScrollViewProtocol

extension ARTViewController_ScrollView: ARTScrollViewProtocol {
   
    func scrollView(_ scrollView: ARTScrollView, didTapSelectItemAt index: Int) {
        print("点击了第\(index)个")
    }

    func scrollView(_ scrollView: ARTScrollView, autoScrollTo index: Int) {
        pageControl.currentPage = Int(index)
        print("自动滚动到第\(index)个")
    }

}
