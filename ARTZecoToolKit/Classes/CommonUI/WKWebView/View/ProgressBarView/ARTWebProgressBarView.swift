//
//  ARTProgressBarView.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/8/20.
//

/// `ARTProgressBarViewProtocol` 协议用于提供 `ARTProgressBarView` 的配置。
/// 通过实现这个协议，可以定制进度条的颜色、隐藏状态等属性。
@objc public protocol ARTProgressBarViewProtocol: AnyObject {
    
    /// 返回进度条的自定义颜色。
    ///
    /// - Parameter progressBar: 进度条视图。
    /// - Returns: 进度条的颜色。
    func tintColor(for progressBar: ARTProgressBarView) -> UIColor
    
    /// 进度条是否应隐藏。
    ///
    /// - Parameter progressBar: 进度条视图。
    /// - Returns: `true` 表示隐藏进度条，`false` 表示显示进度条。
    func shouldHideProgressBar(for progressBar: ARTProgressBarView) -> Bool
}

open class ARTProgressBarView: UIView {
    
    /// 代理对象
    private weak var delegate: ARTProgressBarViewProtocol?
    
    /// 进度条视图
    private var progressView: UIView!
    
    /// 是否隐藏进度条
    private var shouldHideProgressBar: Bool = false
    
    /// 进度条的颜色
    private var progressColor: UIColor!
    
    /// 标记首次布局完成
    private var isFirstLayout = true
 
    
    // MARK: - Initialization
    
    convenience init(_ delegate: ARTProgressBarViewProtocol) {
        self.init()
        self.delegate = delegate
        self.progressColor = delegate_tintColor()
        self.shouldHideProgressBar = delegate_shouldHideProgressBar()
        self.isHidden = shouldHideProgressBar
        setupViews()
    }
    
    private func setupViews() {
        // 创建进度条视图
        progressView = UIView()
        progressView.backgroundColor = progressColor
        progressView.layer.masksToBounds = true
        addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
            make.width.equalTo(0)
        }
    }
    
    open override func layoutSubviews() { /// 布局子视图
        super.layoutSubviews()
        guard isFirstLayout else { return }
        isFirstLayout = false
        progressView.layer.cornerRadius = bounds.height/2
    }
    
    /// 设置进度条的进度。
    func setProgress(_ progress: Float, animated: Bool, completion: (() -> Void)? = nil) {
        guard !shouldHideProgressBar else { return }
        let targetWidth = self.frame.width * CGFloat(progress)
        let animationBlock = {
            self.progressView.snp.updateConstraints { make in
                make.width.equalTo(targetWidth)
            }
            self.layoutIfNeeded()
        }
        
        if animated {
            UIView.animate(withDuration: 0.3, animations: animationBlock, completion: { _ in
                completion?()
            })
        } else {
            animationBlock()
            completion?()
        }
    }
    
    // MARK: - Private Delegate Methods
    
    private func delegate_tintColor() -> UIColor { // 进度条的颜色
        return delegate?.tintColor(for: self) ?? .art_color(withHEXValue: 0xFE5C01)
    }
    
    private func delegate_shouldHideProgressBar() -> Bool { // 进度条是否应隐藏
        return delegate?.shouldHideProgressBar(for: self) ?? false
    }
}
