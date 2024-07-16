//
//  ARTARTPhotoBrowserViewController.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/7/15.
//

public protocol ARTPhotoBrowserViewControllerDelegate: AnyObject {
    
    /// 照片浏览器视图控制器索引变化回调
    ///
    /// - Parameters:
    ///  - viewController: 照片浏览器视图控制器
    ///  - index: 索引
    func photoBrowserViewController(_ viewController: ARTPhotoBrowserViewController, didChangedIndex index: Int)
    
    /// 自定义导航栏视图
    ///
    /// - Parameters:
    /// - viewController: 照片浏览器视图控制器
    /// - Returns: 自定义导航栏视图
    /// - Note: 返回自定义导航栏视图，若返回 nil 则使用默认导航栏视图
    /// - Note: 自定义导航栏视图需继承 ARTPhotoBrowserNavigationBar
    func customNavigationBar(for viewController: ARTPhotoBrowserViewController) -> ARTPhotoBrowserNavigationBar?
    
    /// 自定义底部工具栏视图
    ///
    /// - Parameters:
    /// - viewController: 照片浏览器视图控制器
    /// - Returns: 自定义底部工具栏视图
    /// - Note: 返回自定义底部工具栏视图，若返回 nil 则使用默认底部工具栏视图
    /// - Note: 自定义底部工具栏视图需继承 ARTPhotoBrowserBottomBar
    func customBottomBar(for viewController: ARTPhotoBrowserViewController) -> ARTPhotoBrowserBottomBar?
}

open class ARTPhotoBrowserViewController: UIViewController {
    
    // 代理对象
    public weak var delegate: ARTPhotoBrowserViewControllerDelegate?
    
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
    
    /// 当前显示的照片索引
    internal var startIndex: Int = 0
    
    /// 记录上一次回调的索引
    private var lastReportedIndex = -1
    
    /// 标记首次布局完成
    private var isFirstLayout = true
    
    /// 当前显示的照片索引回调
    public var currentIndexCallback: ((Int) -> Void)?
    
    
    // MARK: - Class Methods
    
    /// 类方法展示图片浏览器
    public class func showPhotoBrowser(withPhotos photos: [Any], startIndex index: Int, currentIndexCallback: ((Int) -> Void)? = nil) {
        let photoBrowserViewController = ARTPhotoBrowserViewController(photos: photos, startIndex: index)
        photoBrowserViewController.currentIndexCallback = currentIndexCallback
        photoBrowserViewController.presentPhotoBrowser()
    }
    
    // MARK: - Instance Methods
    
    /// 实例方法展示图片浏览器
    public func showPhotoBrowser() {
        presentPhotoBrowser()
    }
    
    // MARK: - Initialization
    
    public init(photos: [Any], startIndex: Int) {
        self.photos = photos
        self.startIndex = startIndex
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        // 控制器基础配置
        setupBaseConfiguration()
        
        // 创建导航栏
        setupNavigationBar()
        
        // 创建底部工具栏
        setupBottomBar()
        
        // 创建列表视图
        setupCollectionView()
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if isFirstLayout { /// 防止内存不必要的开销
            collectionView.scrollToItem(at: IndexPath(item: startIndex, section: 0), at: .centeredHorizontally, animated: false)
            isFirstLayout = false
        }
    }
    
    // MARK: - Private Methods
    
    /// 控制器基础配置
    ///
    /// - Note: 设置转场代理、隐藏导航栏、设置导航栏透明、设置背景颜色
    private func setupBaseConfiguration() {
        transitioningDelegate = self /// 设置转场代理
        navigationController?.navigationBar.isHidden = true /// 隐藏导航栏
        navigationController?.navigationBar.isTranslucent = true /// 设置导航栏透明
        view.backgroundColor = configuration.controllerBackgroundColor /// 设置背景颜色
    }
    
    /// 创建导航栏
    ///
    /// - Note: 使用代理返回的自定义导航栏视图，若返回 nil 则创建默认的导航栏视图
    /// - Note: 默认导航栏视图需继承 ARTPhotoBrowserNavigationBar
    private func setupNavigationBar() {
        if let customNavBar = delegate?.customNavigationBar(for: self) { // 使用代理返回的自定义导航栏视图
            navigationBar = customNavBar
            view.addSubview(navigationBar!)
            
        } else { // 创建默认的导航栏视图
            navigationBar = ARTPhotoBrowserNavigationBar()
            navigationBar.closeControllerCallback = { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true, completion: nil)
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
    /// - Note: 使用代理返回的自定义底部工具栏视图，若返回 nil 则创建默认的底部工具栏视图
    /// - Note: 默认底部工具栏视图需继承 ARTPhotoBrowserBottomBar
    private func setupBottomBar() {
        if let customBottomBar = delegate?.customBottomBar(for: self) { // 使用代理返回的自定义底部工具栏视图
            bottomBar = customBottomBar
            view.addSubview(bottomBar)
            
        } else { // 创建默认的底部工具栏视图
            bottomBar = ARTPhotoBrowserBottomBar()
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
    /// - Note: 设置列表视图的基础配置、代理、数据源、注册 cell、分页控制器
    private func setupCollectionView() {
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
    
    // MARK: - Instance Methods Methods
    
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
            delegate?.photoBrowserViewController(self, didChangedIndex: pageIndex) /// 通知代理对象当前页码发生变化
            lastReportedIndex = pageIndex
            guard (delegate?.customBottomBar(for: self)) != nil else { /// 使用默认底部工具栏视图
//                print("自定义底部工具栏视图")
                bottomBar.updatePageIndex(pageIndex, pageCount: photos.count)
                return
            }
        }
    }
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
