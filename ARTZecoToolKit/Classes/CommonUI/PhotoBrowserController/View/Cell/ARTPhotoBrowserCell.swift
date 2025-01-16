//
//  ARTPhotoBrowserCell.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/7/15.
//

extension ARTPhotoBrowserCell {
    // 单击枚举类型
    enum CellSingleTapType: Int, CaseIterable {
        case dismiss = 0 // 单击关闭
        case none    = 1 // 顶底栏
    }
}

class ARTPhotoBrowserCell: UICollectionViewCell {
    
    /// 默认配置
    private let configuration = ARTPhotoBrowserStyleConfiguration.default()
    
    /// 滚动视图，用于支持缩放图片
    private var scrollView: UIScrollView!
    
    /// 图片显示视图
    private var imageView: UIImageView!
    
    /// 背景图片用于模糊效果
    private var backgroundImageView: UIImageView!
    
    /// 高斯模糊效果
    private var blurEffectView: UIView!
    
    /// 双击手势缩放
    private var doubleTapZoomGesture: UITapGestureRecognizer!
    
    /// 单击手势关闭
    private var singleTapGesture: UITapGestureRecognizer!
    
    /// 单击枚举回调闭包，用于处理单击事件
    public var singleTapCallback: ((_ tapType: CellSingleTapType) -> Void)?
    
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        setupBlurEffectView() // 设置模糊效果
        setupScrollView() // 设置滚动视图
        setupImageView() // 设置图片视图
        setupGestures() // 设置手势
    }
    
    // MARK: - Setup Methods
    
    private func setupBlurEffectView() { // 创建高斯模糊效果视图
        guard configuration.enableBackgroundBlurEffect else { return }
        
        blurEffectView = UIView()
        contentView.addSubview(blurEffectView)
        blurEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 创建背景图片视图
        backgroundImageView = UIImageView()
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        blurEffectView.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 添加模糊效果
        let blurEffect = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.addSubview(visualEffectView)
        visualEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupScrollView() { // 创建滚动视图
        scrollView = UIScrollView(frame: contentView.bounds)
        scrollView.delegate = self
        scrollView.minimumZoomScale = configuration.minimumZoomScale
        scrollView.maximumZoomScale = configuration.maximumZoomScale
        scrollView.contentInsetAdjustmentBehavior = .never
        contentView.addSubview(scrollView)
    }
    
    private func setupImageView() { // 创建图片视图
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)
    }

    private func setupGestures() { // 添加双击缩放手势
        if configuration.enableDoubleTapZoomGesture {
            doubleTapZoomGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
            doubleTapZoomGesture.numberOfTapsRequired = 2
            contentView.addGestureRecognizer(doubleTapZoomGesture)
        }
        
        if configuration.enableSingleTapDismissGesture || configuration.enableTopBottomFadeOutAnimator { // 添加单击手势
            singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(_:)))
            singleTapGesture.delaysTouchesBegan = false
            singleTapGesture.numberOfTapsRequired = 1
            if configuration.enableDoubleTapZoomGesture { // 防止与双击手势冲突
                singleTapGesture.require(toFail: doubleTapZoomGesture)
            }
            contentView.addGestureRecognizer(singleTapGesture)
        }
    }

    // MARK: - Private UITapGestureRecognizer Methods
    
    @objc private func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        /// 图片宽度小于等于scrollView宽度时，不进行缩放
        if imageView.bounds.width <= scrollView.bounds.width { return }
        
        UIView.animate(withDuration: 0.35) {
            /// 获取点击位置
            let pointInView = gesture.location(in: self.imageView)
            
            /// 获取当前缩放比例
            let newZoomScale: CGFloat
            if self.scrollView.zoomScale == self.scrollView.minimumZoomScale {
                newZoomScale = self.scrollView.maximumZoomScale
            } else {
                newZoomScale = self.scrollView.minimumZoomScale
            }
            
            /// 计算缩放后的区域
            let scrollViewSize = self.scrollView.bounds.size
            let width = scrollViewSize.width / newZoomScale
            let height = scrollViewSize.height / newZoomScale
            let x = pointInView.x - (width / 2.0)
            let y = pointInView.y - (height / 2.0)
            let rectToZoomTo = CGRect(x: x, y: y, width: width, height: height)
            
            /// 缩放到指定区域
            self.scrollView.zoom(to: rectToZoomTo, animated: false)
        }
    }
    
    @objc private func handleSingleTap(_ gesture: UITapGestureRecognizer) {
        let action: CellSingleTapType = configuration.enableTopBottomFadeOutAnimator ? .none : .dismiss
        singleTapCallback?(action)
    }
    
    // MARK: - Private Methods
    
    /// 图片缩放到合适的位置
    private func adjustFrameToCenter() {
        var frameToCenter = imageView.frame
        
        // 如果图片的宽度小于 scrollView 的宽度，则居中显示
        if frameToCenter.size.width < scrollView.bounds.size.width {
            frameToCenter.origin.x = (scrollView.bounds.size.width - frameToCenter.size.width) / 2.0
        } else {
            frameToCenter.origin.x = 0.0
        }
        
        // 如果图片的高度小于 scrollView 的高度，则居中显示
        if frameToCenter.size.height < scrollView.bounds.size.height {
            frameToCenter.origin.y = (scrollView.bounds.size.height - frameToCenter.size.height) / 2.0
        } else {
            frameToCenter.origin.y = 0.0
        }
        
        imageView.frame = frameToCenter
    }
    
    private func handleImageLoadResult(image: UIImage?) {
        guard let image = image else { return }
        
        // 设置图片视图的 frame 和内容大小
        self.imageView.frame = CGRect(origin: .zero, size: image.size)
        self.scrollView.contentSize = image.size
        if configuration.enableBackgroundBlurEffect { self.backgroundImageView.image = image }
        
        // 计算最小缩放比例以适应图片大小
        let scaleWidth = self.contentView.bounds.size.width / image.size.width
        let scaleHeight = self.contentView.bounds.size.height / image.size.height
        let minScale = min(scaleWidth, scaleHeight)
        
        // 设置滚动视图的最小缩放比例和当前缩放比例
        self.scrollView.minimumZoomScale = minScale
        self.scrollView.zoomScale = minScale
        
        // 调整图片视图使其居中
        self.adjustFrameToCenter()
    }
    
    // MARK: - Public Methods
    
    /// 处理图片加载结果
    ///
    /// - Parameter image: 图片对象
    /// - Parameter source: 图片来源，可以是 URL、String 或 UIImage 对象
    public func loadImage(from source: Any) {
        scrollView.setZoomScale(1.0, animated: false)
        scrollView.contentOffset = .zero
        
        if let urlString = source as? String { /// 检查 source 是否为字符串类型
            if urlString.hasPrefix("http://") || urlString.hasPrefix("https://") {
                imageView.sd_setImage(with: URL(string: urlString)) { [weak self] image, error, cacheType, url in
                    guard let self = self else { return }
                    self.handleImageLoadResult(image: image)
                }
                return
            } else if urlString.hasPrefix("file://") { /// 如果是本地文件路径
                let fileURL = URL(fileURLWithPath: urlString)
                imageView.image = UIImage(contentsOfFile: fileURL.path)
                handleImageLoadResult(image: imageView.image)
                return
            } else { /// 如果是资源图片名称
                imageView.image = UIImage(named: urlString)
                handleImageLoadResult(image: imageView.image)
                return
            }
        } else if let url = source as? URL { /// 检查 source 是否为 URL 类型
            if url.isFileURL { /// 如果是本地文件 URL
                imageView.image = UIImage(contentsOfFile: url.path)
                handleImageLoadResult(image: imageView.image)
                return
            } else { // 如果是网络图片 URL
                imageView.sd_setImage(with: url) { [weak self] image, error, cacheType, url in
                    guard let self = self else { return }
                    self.handleImageLoadResult(image: image)
                }
                return
            }
        } else if let image = source as? UIImage { // 检查 source 是否为 UIImage 类型
            imageView.image = image
            handleImageLoadResult(image: image)
            return
        }
    }
    
    /// 处理滑动收起视图手势
    @objc public func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let panTranslation = gesture.translation(in: contentView)
        let maxVerticalTranslation: CGFloat = 500.0 // 最大垂直滑动距离，用于计算背景透明度
        let translationY = panTranslation.y // 当前手势的垂直偏移量
        let backgroundOpacity = max(0.0, 1 - min(abs(translationY) / maxVerticalTranslation, 1)) // 计算背景透明度和缩放比例
        let scalingFactor = max(0.4, 1 - abs(translationY) / 2000) // 控制缩小速度及最小缩放比例（0.4 ~ 1.0）

        switch gesture.state {
        case .changed:
            if scrollView.zoomScale != scrollView.minimumZoomScale || scrollView.contentOffset.y != 0 { return }
            let scaleTransformation = CGAffineTransform(scaleX: scalingFactor, y: scalingFactor)
            let translationTransformation = CGAffineTransform(translationX: panTranslation.x, y: translationY)
            scrollView.transform = scaleTransformation.concatenating(translationTransformation)
            blurEffectView.alpha = backgroundOpacity // 背景透明度
        case .ended, .cancelled:
            UIView.animate(withDuration: 0.25) {
                self.scrollView.transform = .identity
                self.blurEffectView.alpha = 1.0
            }
        default:
            break
        }
    }
}

// MARK: - UIScrollViewDelegate

extension ARTPhotoBrowserCell: UIScrollViewDelegate {
    
    /// 缩放视图
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    /// 缩放结束后调整图片位置
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        adjustFrameToCenter()
    }
}
