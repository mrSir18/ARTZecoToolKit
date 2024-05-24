//
//  ARTScrollView.swift
//  Alamofire
//
//  Created by mrSir18 on 2024/5/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import SnapKit

// MARK: - ARTScrollViewProtocol

@objc public protocol ARTScrollViewProtocol: AnyObject {
    
    /// 滚动视图:点击事件
    ///
    /// - Parameters:
    ///  - scrollView: 轮播图管理对象
    ///  - index: 当前轮播图索引
    @objc optional func scrollView(_ scrollView: ARTScrollView, didTapSelectItemAt index: Int)

    /// 滚动视图:自动滚动到指定索引
    ///
    /// - Parameters:
    ///  - scrollView: 轮播图管理对象
    ///  - index: 当前轮播图索引
    @objc optional func scrollView(_ scrollView: ARTScrollView, autoScrollTo index: Int)
}

// MARK: - ARTScrollView

public class ARTScrollView: UIView {

    /// 遵循 ARTScrollViewProtocol 协议的弱引用委托对象.
    weak var delegate: ARTScrollViewProtocol?
    
    /// 滚动视图
    private var scrollView: UIScrollView!
    
    /// 定时器
    private var timer: Timer?
    
    /// 当前页数
    private var currentPage: Int = 0
    
    /// 默认滚动间隔3秒
    public var interval: TimeInterval = 3.0
    
    /// 滚动视图数据源
    public var dataSources: [ARTScrollViewItem] = [] {
        didSet {
            if !dataSources.isEmpty {
                createScrollPageEffect()
            }
        }
    }
    
    public convenience init(_ delegate: ARTScrollViewProtocol) {
        self.init()
        self.delegate = delegate
        
        // 创建滚动视图
        scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator   = false
        scrollView.showsVerticalScrollIndicator     = false
        scrollView.delegate                         = self
        scrollView.isPagingEnabled                  = true
        scrollView.bounces                          = false
        scrollView.scrollsToTop                     = false
        scrollView.contentSize                      = CGSizeMake(0.0, 0.0)
        scrollView.backgroundColor                  = .clear
        scrollView.contentInsetAdjustmentBehavior   = .never
        self.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func createScrollPageEffect() {
        removeScrollPageFromSuperview()
        layoutIfNeeded()
        
        // 获取滚动视图的宽度和总页数
        let pageCount = dataSources.count
        let scrollViewWidth = scrollView.frame.size.width
        var offsetX = scrollViewWidth
        
        // 判断是否需要滚动
        let shouldEnableScrolling = pageCount > 1
        scrollView.isScrollEnabled = shouldEnableScrolling
        shouldEnableScrolling ? startAutoScroll() : stopAutoScroll()
        
        // 创建视图并添加到滚动视图中
        func addPageView(at index: Int, offsetX: CGFloat) {
            let pageView = UIView()
            pageView.tag = index
            pageView.isUserInteractionEnabled = true
            pageView.backgroundColor = .clear
            scrollView.addSubview(pageView)
            pageView.snp.makeConstraints { make in
                make.size.equalTo(scrollView)
                make.left.equalTo(offsetX)
                make.top.equalTo(0)
            }
            
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.layer.masksToBounds = true
            pageView.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.edges.equalTo(pageView)
            }
            /// 如果模型中包含非空且非空字符串的图像 URL，则根据情况设置背景图像视图的内容模式和图像.
            let imageUrl = dataSources[index].imageUrl
            if !imageUrl.isEmpty {
                if isValidHttpUrl(imageUrl) {
                    imageView.yy_imageURL = URL(string: imageUrl)
//                    imageView.af.setImage(withURL: URL(string: imageUrl)!)
                } else {
                    imageView.image = UIImage(named: imageUrl)
                }
            }

            let button = ARTAlignmentButton(type: .custom)
            button.tag = index
            button.addTarget(self, action: #selector(clickImageTapHandler), for: .touchUpInside)
            pageView.addSubview(button)
            button.snp.makeConstraints { make in
                make.edges.equalTo(pageView)
            }
        }
        // 添加第一个视图
        addPageView(at: pageCount - 1, offsetX: 0)
        
        // 添加中间的视图
        for index in 0..<pageCount {
            addPageView(at: index, offsetX: offsetX)
            offsetX += scrollViewWidth
        }
        
        // 添加最后一个视图
        addPageView(at: 0, offsetX: offsetX)
        
        // 设置滚动视图的偏移量和内容大小
        scrollView.setContentOffset(CGPoint(x: scrollViewWidth, y: 0), animated: false)
        scrollView.contentSize = CGSize(width: CGFloat(pageCount + 2) * scrollViewWidth, height: scrollView.frame.size.height)
    }
    
    // MARK: - Private Button Actions
    
    @objc private func clickImageTapHandler(_ sender: UIButton) {
        delegate?.scrollView?(self, didTapSelectItemAt: sender.tag)
    }
    
    // MARK: - Private Methods
    
    private func startAutoScroll() {
        guard timer == nil else { return }
        
        timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(startTimer(_:)), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    @objc private func startTimer(_ timer: Timer) {
        let currentOffset = scrollView.contentOffset.x + scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x: currentOffset, y: 0), animated: true)
    }
    
    private func stopAutoScroll() {
        timer?.invalidate()
        timer = nil
    }

    private func removeScrollPageFromSuperview() {
        scrollView.subviews.forEach { $0.removeFromSuperview() }
        stopAutoScroll()
    }
    
    /// 判断给定的字符串是否为有效的 HTTP 或 HTTPS URL.
    ///
    /// - Parameter urlString: 待检查的字符串.
    /// - Returns: 如果是有效的 HTTP 或 HTTPS URL，则返回 true；否则返回 false.
    private func isValidHttpUrl(_ urlString: String) -> Bool {
        return urlString.hasPrefix("http://") || urlString.hasPrefix("https://")
    }
}

// MARK: - Publick Methods

extension ARTScrollView {

    /// 滚动到指定索引位置
    ///
    /// - Parameter index: 要滚动到的索引
    public func scrollToIndex(_ index: Int) {
        stopAutoScroll()
        guard dataSources.count > 1 else { return }
        
        let scrollViewWidth = scrollView.frame.size.width
        let offsetX = CGFloat(index + 1) * scrollViewWidth
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        startAutoScroll()
    }
}

// MARK: - UIScrollViewDelegate

extension ARTScrollView: UIScrollViewDelegate {
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        handleScrollViewDidEndDecelerating(scrollView)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopAutoScroll()
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        timer?.fireDate = .distantPast
        startAutoScroll()
    }

    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        handleScrollViewDidEndDecelerating(scrollView)
    }
    
    private func handleScrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let scrollViewWidth = scrollView.frame.size.width
        var currentPage = Int(offsetX / scrollViewWidth) - 1
        let pageCount = dataSources.count
        
        if currentPage >= pageCount {
            currentPage = 0
            scrollView.setContentOffset(CGPoint(x: scrollViewWidth, y: 0), animated: false)
        }
        
        if currentPage < 0 {
            currentPage = pageCount - 1
            scrollView.setContentOffset(CGPoint(x: scrollViewWidth * CGFloat(pageCount) + 1, y: 0), animated: false)
        }
        
        self.currentPage = currentPage
        delegate?.scrollView?(self, autoScrollTo: currentPage)
    }
}
