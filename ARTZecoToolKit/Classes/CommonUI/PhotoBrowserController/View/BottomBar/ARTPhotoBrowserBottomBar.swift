//
//  ARTPhotoBrowserBottomBar.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/7/15.
//

public protocol ARTPhotoBrowserBottomBarDelegate: AnyObject {
    /// 协议方法
    ///
    /// - NOTE: 可继承该协议方法
}

open class ARTPhotoBrowserBottomBar: UIView {
    
    /// 代理对象
    public weak var delegate: ARTPhotoBrowserBottomBarDelegate?
    
    /// 默认配置
    private let configuration = ARTPhotoBrowserStyleConfiguration.default()
    
    /// 页码容器视图
    private var pageIndexContainerView: UIView!
    
    /// 页码标签
    public var pageIndexLabel: UILabel!
    
    
    // MARK: - Life Cycle
    
    public init(_ delegate: ARTPhotoBrowserBottomBarDelegate? = nil) {
        super.init(frame: .zero)
        self.delegate = delegate
        self.backgroundColor = .art_randomColor()
        self.isUserInteractionEnabled = configuration.enableBottomBarUserInteraction
        setupViews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 重写父类方法，设置子视图
    ///
    /// - Note: 由于子类需要自定义视图，所以需要重写该方法
    open func setupViews() {
        
        // 创建容器视图
        let containerView = UIView()
        containerView.backgroundColor = .clear
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(-art_safeAreaBottom())
        }
        
        pageIndexContainerView = UIView()
        pageIndexContainerView.backgroundColor       = .art_color(withHEXValue: 0x000000, alpha: 0.3)
        pageIndexContainerView.layer.cornerRadius    = ARTAdaptedValue(9.0)
        pageIndexContainerView.layer.masksToBounds   = true
        containerView.addSubview(pageIndexContainerView)
        pageIndexContainerView.snp.makeConstraints { make in
            make.right.equalTo(-ARTAdaptedValue(12.0))
            make.centerY.equalToSuperview()
            make.width.equalTo(ARTAdaptedValue(32.0))
            make.height.equalTo(ARTAdaptedValue(18.0))
        }
        
        // 创建页码标签
        pageIndexLabel = UILabel()
        pageIndexLabel.textAlignment    = .center
        pageIndexLabel.font             = .art_regular(ARTAdaptedValue(11.0))
        pageIndexLabel.textColor        = .white
        pageIndexContainerView.addSubview(pageIndexLabel)
        pageIndexLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Public Methods
    
    /// 更新页码
    /// - Parameters:
    ///  - index: 页码
    ///  - pageCount: 总页数
    public func updatePageIndex(_ startIndex: Int, pageCount: Int) {
        pageIndexLabel.text = "\(startIndex+1)/\(pageCount)"
        let minWidth: CGFloat = ARTAdaptedValue(32.0)
        let size = pageIndexLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: pageIndexLabel.frame.size.height))
        pageIndexContainerView.snp.updateConstraints { make in
            make.width.equalTo(max(size.width + ARTAdaptedValue(10.0), minWidth))
        }
    }
}
