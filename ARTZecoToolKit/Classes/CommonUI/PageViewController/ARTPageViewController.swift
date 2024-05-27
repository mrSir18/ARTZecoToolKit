//
//  ARTPageViewController.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/5/27.
//

import UIKit

public protocol ARTPageViewControllerProtocol: AnyObject {
    
    /// 获取视图控制器
    ///
    /// - Parameters:
    ///   - pageViewController: 控制器对象.
    func viewControllers(_ pageViewController: ARTPageViewController) -> [UIViewController]
    
    /// 获取当前视图控制器的索引
    ///
    /// - Parameters:
    ///   - pageViewController: 控制器对象.
    ///   - index: 当前视图控制器的索引.
    func pageViewController(_ pageViewController: ARTPageViewController, didUpdatePageIndex index: Int)
}

public class ARTPageViewController: UIPageViewController {
    
    /// 遵循 ARTPageViewControllerProtocol 协议的弱引用委托对象.
    weak var pageDelegate: ARTPageViewControllerProtocol?
    
    /// 视图控制器数组.
    private lazy var pages: [UIViewController] = {
        return pageDelegate?.viewControllers(self) ?? []
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        // 检查pages数组是否为空
        guard !pages.isEmpty else {
            ARTAlertController.showAlertController(title: "视图控制器数组为空",
                                                   message: "请检查 ARTPageViewControllerProtocol 协议中 viewControllers(_:) 方法是否返回了视图控制器数组.",
                                                   preferredStyle: .alert,
                                                   buttonTitles: ["确定", "取消"],
                                                   buttonStyles: [.default, .cancel], in: self) { mode in
                print("点击了\(mode)按钮")
            }
            return
        }
        
        // 设置第一个视图控制器
        if let firstViewController = pages.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
            pageDelegate?.pageViewController(self, didUpdatePageIndex: 0)
        }
    }
    
    /// 添加到父视图控制器
    ///
    /// - Parameters:
    ///  - parent: 父视图控制器.
    ///  - Returns: 返回 ARTPageViewController 对象.
    ///  - Note: 该方法用于添加到父视图控制器.
    public class func addToParent(_ parent: UIViewController) -> ARTPageViewController {
        let pageViewController = ARTPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        if let pageDelegate = parent as? ARTPageViewControllerProtocol {
            pageViewController.pageDelegate = pageDelegate
        }
        parent.addChild(pageViewController)
        parent.view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: parent)
        return pageViewController
    }
    
    /// 跳转到指定视图控制器
    ///
    /// - Parameters:
    ///  - index: 视图控制器的索引.
    ///  - animated: 是否动画.
    public func goToPage(index: Int, animated: Bool) {
        guard index >= 0, index < pages.count else { return }
        let currentIndex = pages.firstIndex(of: viewControllers?.first ?? UIViewController()) ?? 0
        let direction: UIPageViewController.NavigationDirection = index > currentIndex ? .forward : .reverse
        setViewControllers([pages[index]], direction: direction, animated: animated) { [weak self] _ in
            guard let self = self else { return }
            self.pageDelegate?.pageViewController(self, didUpdatePageIndex: index)
        }
    }
}

// MARK: - UIPageViewControllerDelegate
extension ARTPageViewController: UIPageViewControllerDelegate {
    
    /// 完成动画
    ///
    /// - Parameters:
    ///  - pageViewController: 控制器对象.
    ///  - finished: 是否完成.
    ///  - previousViewControllers: 前一个视图控制器.
    ///  - completed: 是否完成.
    ///  - Note: 该方法用于完成动画.
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed, let viewController = viewControllers?.first, let index = pages.firstIndex(of: viewController) else { return }
        pageDelegate?.pageViewController(self, didUpdatePageIndex: index)
    }
}

// MARK: - UIPageViewControllerDataSource
extension ARTPageViewController: UIPageViewControllerDataSource {
    
    /// 获取前一个视图控制器
    ///
    /// - Parameters:
    ///  - pageViewController: 控制器对象.
    ///  - viewController: 当前视图控制器.
    ///  - Returns: 返回前一个视图控制器.
    ///  - Note: 该方法用于获取前一个视图控制器.
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        let previousIndex = currentIndex - 1
        guard previousIndex >= 0 else { return nil }
        return pages[previousIndex]
    }
    
    /// 获取后一个视图控制器
    ///
    /// - Parameters:
    ///  - pageViewController: 控制器对象.
    ///  - viewController: 当前视图控制器.
    ///  - Returns: 返回后一个视图控制器.
    ///  - Note: 该方法用于获取后一个视图控制器.
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        let nextIndex = currentIndex + 1
        guard nextIndex < pages.count else { return nil }
        return pages[nextIndex]
    }
}
