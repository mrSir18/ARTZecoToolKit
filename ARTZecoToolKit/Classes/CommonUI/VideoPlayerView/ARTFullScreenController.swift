//
//  ARTFullScreenController.swift
//  Pods
//
//  Created by mrSir18 on 2024/10/19.
//

import UIKit

/// 全屏控制器，用于展示视频内容
open class ARTFullScreenController: UIViewController {
    
    /// 内容栈视图，用于承载全屏视频及其相关组件
    public var contentStackView: UIStackView!
    
    
    // MARK: - Life Cycle
    
    /// 视图加载完成时调用
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupContentStackView()
    }
    
    // MARK: - Override Methods
    
    /// 设置内容栈视图的属性和布局
    open func setupContentStackView() {
        contentStackView = UIStackView() // 初始化内容栈视图
        contentStackView.isUserInteractionEnabled = true // 启用用户交互
        contentStackView.axis = .horizontal // 设置为横向布局
        contentStackView.distribution = .fill // 填充整个栈视图
        contentStackView.alignment = .fill // 填充对齐
        contentStackView.insetsLayoutMarginsFromSafeArea = false // 不受安全区域影响
        contentStackView.isLayoutMarginsRelativeArrangement = true // 相对布局边距
        contentStackView.layoutMargins = .zero // 设置布局边距为零
        contentStackView.spacing = 0 // 设置子视图间距为零
        view.addSubview(contentStackView) // 将内容栈视图添加到主视图
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview() // 设置栈视图与主视图边缘对齐
        }
    }
}

extension ARTFullScreenController {
    
    /// 是否允许自动旋转
    open override var shouldAutorotate: Bool {
        return false
    }
    
    /// 支持的界面方向
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape // 仅支持横屏
    }
    
    /// 状态栏样式
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    /// 是否隐藏状态栏
    open override var prefersStatusBarHidden: Bool {
        return true
    }
    
    /// 是否自动隐藏主屏幕指示器
    open override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    /// 呈现方向 - 右侧横屏
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeRight
    }
}
