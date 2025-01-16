//
//  ARTARTPhotoBrowserViewController.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/7/15.
//

@objc public protocol ARTPhotoBrowserViewControllerProtocol: AnyObject {
    
    /// 照片浏览器视图控制器索引变化回调
    ///
    /// - Parameters:
    ///  - viewController: 照片浏览器视图控制器
    ///  - index: 索引
    @objc optional func photoBrowserViewController(_ viewController: ARTPhotoBrowserViewController, didChangedIndex index: Int)
    
    /// 自定义导航栏视图
    ///
    /// - Parameters:
    /// - viewController: 照片浏览器视图控制器
    /// - Returns: 自定义导航栏视图
    /// - Note: 返回自定义导航栏视图，若返回 nil 则使用默认导航栏视图
    /// - Note: 自定义导航栏视图需继承 ARTPhotoBrowserNavigationBar
    @objc optional func customNavigationBar(for viewController: ARTPhotoBrowserViewController) -> ARTPhotoBrowserNavigationBar?
    
    /// 自定义底部工具栏视图
    ///
    /// - Parameters:
    /// - viewController: 照片浏览器视图控制器
    /// - Returns: 自定义底部工具栏视图
    /// - Note: 返回自定义底部工具栏视图，若返回 nil 则使用默认底部工具栏视图
    /// - Note: 自定义底部工具栏视图需继承 ARTPhotoBrowserBottomBar
    @objc optional func customBottomBar(for viewController: ARTPhotoBrowserViewController) -> ARTPhotoBrowserBottomBar?
    
    /// 退出照片浏览器
    ///
    /// - Parameters:
    /// - viewController: 照片浏览器视图控制器
    /// - animated: 是否动画
    /// - completion: 退出完成回调
    /// - Note: 非【present】弹屏方式展示时需实现该方法
    /// - Note: 默认实现为 dismiss(animated:completion:)
    @objc optional func dismissPhotoBrowser(for viewController: ARTPhotoBrowserViewController, animated: Bool, completion: (() -> Void)?)
}

extension ARTPhotoBrowserViewController {
    /// 顶部和底部栏状态
    public enum TopBottomBarState {
        /// 隐藏
        case hidden
        /// 显示
        case visible
    }
}

open class ARTPhotoBrowserViewController: UIViewController {
    
    /// 代理对象
    public weak var delegate: ARTPhotoBrowserViewControllerProtocol?
    
    /// 默认配置
    public let configuration = ARTPhotoBrowserStyleConfiguration.default()
    
    /// 导航栏视图
    private var navigationBar: ARTPhotoBrowserNavigationBar!
    
    ///  底部工具栏视图
    private var bottomBar: ARTPhotoBrowserBottomBar!
    
    /// 列表视图
    private var collectionView: UICollectionView!
    
    /// 存储照片的数组
    internal var photos: [Any] = []
    
    /// 开始显示的照片索引,规则与数组索引一致
    internal var startIndex: Int = 0
    
    /// 记录上一次回调的索引
    private var lastReportedIndex: Int = -1
    
    /// 标记首次布局完成
    private var isFirstLayout = true
    
    /// 顶部和底部栏状态,默认为隐藏
    public var topBottomBarState: TopBottomBarState = .hidden
    
    /// 顶部和底部栏延迟任务
    private var delayTopBottomBarTask: DispatchSourceTimer?
    
    /// 当前显示的照片索引回调
    public var currentIndexCallback: ((Int) -> Void)?
    
    /// 保存当前图片url回调
    public var saveCurrentPhotoCallback: ((Any) -> Void)?
    
    
    // MARK: - Class Methods
    
    /// 类方法展示图片浏览器
    ///
    /// - Parameters:
    ///  - photos: 照片数组
    ///  - index: 起始索引,规则与数组索引一致
    ///  - delegate: 代理对象
    ///  - currentIndexCallback: 当前显示的照片索引回调
    ///  - Note: 该方法为类方法，直接调用即可展示图片浏览器
    ///  - Note: 该方法默认使用 present 弹屏方式展示
    public class func showPhotoBrowser(withPhotos photos: [Any], startIndex index: Int = 0, delegate: ARTPhotoBrowserViewControllerProtocol? = nil, currentIndexCallback: ((Int) -> Void)? = nil, saveCurrentPhotoCallback: ((Any) -> Void)? = nil) {
        let photoBrowserViewController = ARTPhotoBrowserViewController(photos: photos, startIndex: index, delegate: delegate, currentIndexCallback: currentIndexCallback, saveCurrentPhotoCallback: saveCurrentPhotoCallback)
        photoBrowserViewController.presentPhotoBrowser()
    }
    
    // MARK: - Instance Methods
    
    /// 实例方法展示图片浏览器
    public func showPhotoBrowser() {
        presentPhotoBrowser()
    }
    
    // MARK: - Initialization
    
    public init(photos: [Any], startIndex: Int = 0, delegate: ARTPhotoBrowserViewControllerProtocol? = nil, currentIndexCallback: ((Int) -> Void)? = nil, saveCurrentPhotoCallback: ((Any) -> Void)? = nil) {
        self.photos = photos
        self.startIndex = (startIndex >= 0 && startIndex < photos.count) ? startIndex : 0 // 索引越界处理,默认为 0
        self.delegate = delegate
        self.currentIndexCallback = currentIndexCallback
        self.saveCurrentPhotoCallback = saveCurrentPhotoCallback
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Initialization
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupBaseConfiguration() // 控制器基础配置
        setupNavigationBar() // 创建导航栏
        setupBottomBar() // 创建底部工具栏
        setupCollectionView() // 创建列表视图
        setupGestures() // 设置手势
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard isFirstLayout else { return }
        // 首次布局完成时滚动到指定索引,避免闪动
        isFirstLayout = false
        collectionView.scrollToItem(at: IndexPath(item: startIndex, section: 0), at: .centeredHorizontally, animated: false)
        // 如果启用顶部和底部淡出动画，则隐藏顶部和底部栏
        if configuration.enableTopBottomFadeOutAnimator { showTopBottomBarAnimated() }
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 取消顶部和底部栏延迟任务
        cancelDelayTopBottomBarTask()
    }
    
    // MARK: - Override Methods
    
    /// 控制器基础配置
    ///
    /// 重写父类方法，设置子视图
    /// - Note: 设置转场代理、隐藏导航栏、设置导航栏透明、设置背景颜色
    open func setupBaseConfiguration() {
        transitioningDelegate = self /// 设置转场代理
        navigationController?.navigationBar.isHidden = true /// 隐藏导航栏
        navigationController?.navigationBar.isTranslucent = true /// 设置导航栏透明
        view.backgroundColor = configuration.controllerBackgroundColor /// 设置背景颜色
    }
    
    /// 创建导航栏
    ///
    /// 重写父类方法，设置子视图
    /// - Note: 使用代理返回的自定义导航栏视图，若返回 nil 则创建默认的导航栏视图
    /// - Note: 默认导航栏视图需继承 ARTPhotoBrowserNavigationBar
    open func setupNavigationBar() {
        if let customNavBar = delegate?.customNavigationBar?(for: self) { // 使用代理返回的自定义导航栏视图
            navigationBar = customNavBar
            
        } else { // 创建默认的导航栏视图
            navigationBar = ARTPhotoBrowserNavigationBar(self)
            navigationBar.dismissPhotoBrowserCallback = { [weak self] in
                guard let self = self else { return }
                self.dismissPhotoBrowser()
            }
            view.addSubview(navigationBar)
            navigationBar.snp.makeConstraints { make in
                make.top.left.right.equalToSuperview()
                make.height.equalTo(art_navigationFullHeight())
            }
        }
    }
    
    /// 创建底部工具栏
    ///
    /// 重写父类方法，设置子视图
    /// - Note: 使用代理返回的自定义底部工具栏视图，若返回 nil 则创建默认的底部工具栏视图
    /// - Note: 默认底部工具栏视图需继承 ARTPhotoBrowserBottomBar
    open func setupBottomBar() {
        if let customBottomBar = delegate?.customBottomBar?(for: self) { // 使用代理返回的自定义底部工具栏视图
            bottomBar = customBottomBar
            
        } else { // 创建默认的底部工具栏视图
            bottomBar = ARTPhotoBrowserBottomBar(self)
            bottomBar.updatePageIndex(startIndex, pageCount: photos.count)
            view.addSubview(bottomBar)
            bottomBar.snp.makeConstraints { make in
                make.left.bottom.right.equalToSuperview()
                make.height.equalTo(art_tabBarFullHeight())
            }
        }
    }
    
    /// 创建列表视图
    ///
    /// 重写父类方法，设置子视图
    /// - Note: 设置列表视图的基础配置、代理、数据源、注册 cell、分页控制器
    open func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.backgroundColor      = .clear
        collectionView.delegate             = self
        collectionView.dataSource           = self
        collectionView.isPagingEnabled      = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.registerCell(ARTPhotoBrowserCell.self)
        view.addSubview(collectionView)
        view.sendSubviewToBack(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    /// 设置手势
    open func setupGestures() {
        if configuration.enableSwipeToDismissGesture { // 是否支持滑动关闭视图手势
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
            panGesture.maximumNumberOfTouches = 1
            panGesture.delaysTouchesBegan = true
            panGesture.delaysTouchesEnded = true
            panGesture.cancelsTouchesInView = true
            view.addGestureRecognizer(panGesture)
        }

        if configuration.enableLongPressSaveImageGesture { // 长按手势
            let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
            longPressGesture.minimumPressDuration = 0.5 // 设置长按时间
            view.addGestureRecognizer(longPressGesture)
        }
    }
    
    // MARK: - Private Instance Methods
    
    /// 展示图片浏览器
    ///
    /// - Note: 获取顶层视图控制器，然后以全屏模态的方式展示
    private func presentPhotoBrowser() {
        if let topViewController = UIApplication.art_topViewController() { // 获取顶层视图控制器
            let navigationController = UINavigationController(rootViewController: self)
            navigationController.modalPresentationStyle = configuration.modalPresentationStyle // 设置导航控制器的模态展示样式为全屏
            navigationController.modalTransitionStyle = configuration.modalTransitionStyle // 设置导航控制器的模态过渡样式为交叉溶解
            topViewController.present(navigationController, animated: true, completion: nil)
        }
    }
    
    // 提取创建 ActionSheet 内容项的函数
    private func createActionSheetItems(text: String) -> [ARTActionSheetContentEntity] {
        let textFont = .art_medium(ARTAdaptedValue(14.0)) ?? UIFont.systemFont(ofSize: ARTAdaptedValue(14.0))
        let textColor = UIColor.art_color(withHEXValue: 0x000000)
        let separatorLineColor = UIColor.art_color(withHEXValue: 0xEEEEEE)
        let textInset = UIEdgeInsets(top: 0.0, left: ARTAdaptedValue(24.0), bottom: 0.0, right: ARTAdaptedValue(24.0))
        return [
            ARTActionSheetContentEntity(
                text: text,
                textFont: textFont,
                textColor: textColor,
                textAlignment: .left,
                separatorLineColor: separatorLineColor,
                showSeparatorLine: false,
                textInset: textInset
            )
        ]
    }
    
    /// 保存当前图片
    /// - Note: 保存当前显示的图片
    private func saveCurrentPhoto() {
        let currentIndex = (lastReportedIndex != -1) ? lastReportedIndex : startIndex
        saveCurrentPhotoCallback?(photos[currentIndex])
    }
    
    // MARK: - Private Delegate Methods
    
    /// 退出图片浏览器
    ///
    /// - Note: 退出图片浏览器，通知代理对象
    func dismissPhotoBrowser() {
        guard (delegate?.dismissPhotoBrowser?(for: self, animated: true, completion: {
            print("图片浏览器退出成功")
        })) != nil else { /// 使用默认退出方式
            dismiss(animated: true, completion: nil)
            return
        }
    }
}

// MARK: - TopBottomBar Animation

extension ARTPhotoBrowserViewController {
    
    /// 显示顶底栏动画
    public func showTopBottomBarAnimated() {
        UIView.animate(withDuration: configuration.topBottomTransitionAnimatorDuration, animations: {
            self.topBottomBarState = .visible
            self.navigationBar.alpha = 1
            self.bottomBar.alpha = 1
        }, completion: { _ in
            self.resetDelayTopBottomBarTask()
        })
    }
    
    /// 隐藏顶底栏动画
    public func hideTopBottomBarAnimated() {
        UIView.animate(withDuration: configuration.topBottomTransitionAnimatorDuration, animations: {
            self.topBottomBarState = .hidden
            self.navigationBar.alpha = 0
            self.bottomBar.alpha = 0
        })
    }
    
    /// 切换顶底栏的显示状态
    ///
    /// - Note: 如果顶底栏是隐藏的，则显示；如果是显示的，则隐藏
    public func toggleTopBottomBar() {
        if topBottomBarState == .hidden {
            showTopBottomBarAnimated()
        } else {
            hideTopBottomBarAnimated()
        }
        resetDelayTopBottomBarTask()
    }
    
    /// 重置顶底栏的延迟隐藏任务
    ///
    /// - Note: 重新开始计时
    public func resetDelayTopBottomBarTask() {
        cancelDelayTopBottomBarTask()
        startDelayTopBottomBarTask()
    }
    
    /// 开始顶底栏的延迟隐藏任务
    ///
    /// - Note: 开始计时
    public func startDelayTopBottomBarTask() {
        delayTopBottomBarTask = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
        delayTopBottomBarTask?.schedule(deadline: .now() + configuration.topBottomFadeOutAnimatorDuration)
        delayTopBottomBarTask?.setEventHandler { [weak self] in
            guard let self = self else { return }
            if self.topBottomBarState == .visible {
                self.hideTopBottomBarAnimated()
            }
        }
        delayTopBottomBarTask?.resume()
    }
    
    /// 取消顶底栏的延迟隐藏任务
    ///
    /// - Note: 取消计时
    public func cancelDelayTopBottomBarTask() {
        if delayTopBottomBarTask != nil {
            delayTopBottomBarTask?.cancel()
            delayTopBottomBarTask = nil
        }
    }
    
    /// 显示保存图片操作
    public func showActionSheet() {
        ARTActionSheetStyleConfiguration.resetConfiguration()
        
        // 容器样式
        var containerEntity = ARTActionSheetStyleConfiguration.default().containerEntity
        containerEntity.height = ARTAdaptedValue(156.0)
        
        // 创建按钮样式内容
        let defaultStyleItems = createActionSheetItems(text: "保存图片")
        let groupStyleItems = createActionSheetItems(text: "取消")
        
        // 更新样式配置
        ARTActionSheetStyleConfiguration.default()
            .containerEntity(containerEntity)
            .contentEntitys([defaultStyleItems, groupStyleItems])
        
        // 创建并显示 ActionSheet
        let actionSheet = ARTActionSheet()
        actionSheet.didSelectItemCallback = { [weak self] buttonIndex in
            switch buttonIndex {
            case .first: // 保存图片
                self?.saveCurrentPhoto()
            default:
                break
            }
        }
        actionSheet.show()
    }
}

// MARK: - UIGestureRecognizer

extension ARTPhotoBrowserViewController {
    
    /// 处理拖动手势 - 滑动关闭视图
    @objc open func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: view)
        guard let currentIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)), // 获取当前手势位置对应的 indexPath 和 cell
              let photoCell = collectionView.cellForItem(at: currentIndexPath) as? ARTPhotoBrowserCell else {
            return
        }
        switch gesture.state {
        case .began:
            view.backgroundColor = .clear // 设置背景颜色透明
        case .changed:
            if translation.y != 0 {
                if navigationBar.alpha > 0 || bottomBar.alpha > 0 { // 避免重复设置
                    let targetAlpha = max(1 - abs(translation.y) / 200, 0)
                    navigationBar.alpha = targetAlpha
                    bottomBar.alpha = targetAlpha
                }
                photoCell.handlePanGesture(gesture) // 处理图片拖动手势
            }
        case .ended, .cancelled:
            let shouldDismiss = translation.y > 100 || translation.y < -100 || abs(velocity.y) > 300
            if shouldDismiss { // 关闭视图
                dismissPhotoBrowser()
            } else { // 恢复视图状态
                view.backgroundColor = configuration.controllerBackgroundColor // 恢复背景颜色
                UIView.animate(withDuration: 0.3) {
                    self.navigationBar.alpha = 1
                    self.bottomBar.alpha = 1
                }
                photoCell.handlePanGesture(gesture) // 处理图片拖动手势
            }
        default:
            break
        }
    }
    
    /// 处理长按手势 - 保存图片
    @objc open func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began: // 显示保存图片操作
            showActionSheet()
        default:
            break
        }
    }
}

// MARK: - UIScrollViewDelegate

extension ARTPhotoBrowserViewController: UIScrollViewDelegate {
    
    /// 更新当前页码
    ///
    ///  通知回调、代理对象当前页码
    ///  - Note: 用于外部调用，实现任意一个 回调即可获取当前页码
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
        if pageIndex != lastReportedIndex {
            currentIndexCallback?(pageIndex) /// 回调当前页码与代理对象，用于外部调用，实现任意一个回调即可
            delegate?.photoBrowserViewController?(self, didChangedIndex: pageIndex) /// 通知代理对象当前页码发生变化
            lastReportedIndex = pageIndex
            if type(of: bottomBar!) == ARTPhotoBrowserBottomBar.self { /// 如果底部栏是默认
                bottomBar.updatePageIndex(pageIndex, pageCount: photos.count)
            }
        }
    }
}

// MARK: - ARTPhotoBrowserNavigationBarDelegate

extension ARTPhotoBrowserViewController: ARTPhotoBrowserNavigationBarDelegate {
    
}

// MARK: - ARTPhotoBrowserNavigationBar

extension ARTPhotoBrowserViewController: ARTPhotoBrowserBottomBarDelegate {
    
}

// MARK: - UIViewControllerTransitioningDelegate

extension ARTPhotoBrowserViewController: UIViewControllerTransitioningDelegate {
    
    /// 动画控制器
    ///
    /// - Returns: 返回一个动画控制器
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ARTFadeOutAnimator()
    }
}
