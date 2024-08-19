//
//  ARTProgressBarView.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/8/20.
//

/// `ARTProgressBarViewProtocol` 协议用于提供 `ARTProgressBarView` 的配置。
/// 通过实现这个协议，可以定制进度条的颜色、隐藏状态等属性。
protocol ARTProgressBarViewProtocol: AnyObject {
    
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
    private var progressView: UIProgressView?
    
    /// 是否隐藏进度条
    private var shouldHideProgressBar: Bool = false
    
    
    // MARK: - Life Cycle
    
    convenience init(_ delegate: ARTProgressBarViewProtocol) {
        self.init()
        self.delegate = delegate
        setupViews()
    }
    
    private func setupViews() {
        shouldHideProgressBar = delegate_shouldHideProgressBar()
        
        // 创建进度条视图
        progressView = UIProgressView()
        progressView?.progressTintColor = tintColor()
        progressView?.trackTintColor    = .clear
        progressView?.isHidden          = shouldHideProgressBar
        progressView?.transform         = CGAffineTransformMakeScale(1.0, 1.0)
        progressView?.setProgress(0.0, animated: true)
        addSubview(progressView!)
        progressView?.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Public Methods
    
    /// 设置进度条的进度。
    ///
    /// - Parameters:
    ///  - progress: 进度值。
    ///  - animated: 是否动画。
    ///  - completion: 动画完成回调。
    func setProgress(_ progress: Float, animated: Bool, completion: (() -> Void)? = nil) {
        if shouldHideProgressBar { return }
        progressView?.isHidden = progress < 1.0 ? false : true
        progressView?.setProgress(progress, animated: animated)
        completion?()
    }
    
    // MARK: - Private Delegate Methods
    
    private func tintColor() -> UIColor { // 进度条的颜色
        return delegate?.tintColor(for: self) ?? .art_color(withHEXValue: 0xFE5C01)
    }
    
    private func delegate_shouldHideProgressBar() -> Bool { // 进度条是否应隐藏
        return delegate?.shouldHideProgressBar(for: self) ?? false
    }
}
