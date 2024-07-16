//
//  ARTPhotoBrowserCell.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/7/15.
//

class ARTPhotoBrowserCell: UICollectionViewCell {
    
    /// 默认配置
    public let configuration = ARTPhotoBrowserStyleConfiguration.default()
    
    /// 滚动视图，用于支持缩放图片
    private var scrollView: UIScrollView!
    
    /// 图片显示视图
    private var imageView: UIImageView!
    
    /// 背景图片用于模糊效果
    private var backgroundImageView: UIImageView!
    
    /// 双击手势缩放
    private var doubleTapZoomGesture: UITapGestureRecognizer!
    
    /// 单击手势关闭
    private var singleTapGesture: UITapGestureRecognizer!
    
    /// 单击回调闭包，用于处理单击事件
    public var singleTapCallback: (() -> Void)?
    
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        if configuration.enableBackgroundBlurEffect {
            // 创建背景图片视图
            backgroundImageView = UIImageView()
            backgroundImageView.contentMode = .scaleAspectFill
            backgroundImageView.clipsToBounds =  true
            contentView.addSubview(backgroundImageView)
            backgroundImageView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            let blurEffect = UIBlurEffect(style: .dark)
            let visualView = UIVisualEffectView(effect: blurEffect)
            contentView.addSubview(visualView)
            visualView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        
        // 创建滚动视图
        scrollView = UIScrollView(frame: contentView.bounds)
        scrollView.delegate = self
        scrollView.minimumZoomScale = configuration.minimumZoomScale
        scrollView.maximumZoomScale = configuration.maximumZoomScale
        scrollView.contentInsetAdjustmentBehavior = .never
        contentView.addSubview(scrollView)
        
        // 创建图片视图
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)
        
        if configuration.enableDoubleTapZoomGesture { // 创建双击手势
            doubleTapZoomGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
            doubleTapZoomGesture.numberOfTapsRequired = 2
            scrollView.addGestureRecognizer(doubleTapZoomGesture)
        }
        
        if configuration.enableSingleTapDismissGesture { // 创建单击手势
            singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(_:)))
            singleTapGesture.delaysTouchesBegan = false
            singleTapGesture.numberOfTapsRequired = 1
            if configuration.enableDoubleTapZoomGesture { // 解决单击事件和双击事件的冲突
                singleTapGesture.require(toFail: doubleTapZoomGesture)
            }
            scrollView.addGestureRecognizer(singleTapGesture)
        }
    }
    
    // MARK: - Private UITapGestureRecognizer Methods
    
    @objc private func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        /// 获取点击位置
        let pointInView = gesture.location(in: imageView)
        
        /// 获取当前缩放比例
        let newZoomScale: CGFloat
        if scrollView.zoomScale == scrollView.minimumZoomScale {
            newZoomScale = scrollView.maximumZoomScale
        } else {
            newZoomScale = scrollView.minimumZoomScale
        }
        
        /// 计算缩放后的区域
        let scrollViewSize = scrollView.bounds.size
        let width = scrollViewSize.width / newZoomScale
        let height = scrollViewSize.height / newZoomScale
        let x = pointInView.x - (width / 2.0)
        let y = pointInView.y - (height / 2.0)
        let rectToZoomTo = CGRect(x: x, y: y, width: width, height: height)
        
        /// 缩放到指定区域
        scrollView.zoom(to: rectToZoomTo, animated: true)
    }
    
    @objc private func handleSingleTap(_ gesture: UITapGestureRecognizer) {
        singleTapCallback?()
    }
    
    // MARK: - Private Methods
    
    /// 图片缩放到合适的位置
    private func adjustFrameToCenter() {
        var frameToCenter = imageView.frame
        
        // 水平居中
        if frameToCenter.size.width < scrollView.bounds.size.width {
            frameToCenter.origin.x = (scrollView.bounds.size.width - frameToCenter.size.width) / 2.0
        } else {
            frameToCenter.origin.x = 0.0
        }
        
        // 垂直居中
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
        scrollView.zoomScale = 1.0
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
