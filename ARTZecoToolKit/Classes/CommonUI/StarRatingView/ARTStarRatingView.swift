//
//  ARTStarRatingView.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/7/4.
//

import SnapKit

open class ARTStarRatingView: UIView {
    
    /// 默认配置
    public let configuration = ARTStarRatingStyleConfiguration.default()
    
    /// 存储星星按钮的数组
    private var starButtons = [UIButton]()
    
    /// 回调用户评分
    public var ratingCallback: ((String) -> Void)?
    
    
    // MARK: - Life Cycle
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupViews() {
        
        // 创建StackView视图
        let starStackView = UIStackView()
        starStackView.axis      = .horizontal
        starStackView.spacing   = 0.0
        starStackView.backgroundColor = configuration.backgroundColor
        addSubview(starStackView)
        starStackView.snp.makeConstraints { make in
            switch configuration.starAlignment {
            case .left:
                make.left.top.bottom.equalToSuperview()
                make.centerY.equalToSuperview()
            case .center:
                make.centerX.centerY.equalToSuperview()
            case .right:
                make.right.top.bottom.equalToSuperview()
                make.centerY.equalToSuperview()
            }
        }
        
        // 创建星星按钮
        for index in 0..<configuration.starCount {
            let starButton = ARTAlignmentButton(type: .custom)
            starButton.tag              = index
            starButton.imageAlignment   = .left
            starButton.titleAlignment   = .right
            starButton.imageSize        = configuration.starSize
            starButton.setImage(UIImage(named: configuration.starNormalImageName), for: .normal)
            starButton.setImage(UIImage(named: configuration.starSelectedImageName), for: .selected)
            setupGestures(for: starButton)
            starButtons.append(starButton)
            starStackView.addArrangedSubview(starButton)
            starButton.snp.makeConstraints { make in
                make.width.equalTo(configuration.starSize.width + configuration.starSpacing)
            }
        }
    }
    
    // 设置按钮的点击和拖动手势识别器
    private func setupGestures(for starButton: UIButton) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(starButtonTapped(_:)))
        starButton.addGestureRecognizer(tapGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(starButtonDragged(_:)))
        starButton.addGestureRecognizer(panGesture)
    }
    
    // MARK: - Actions
    
    // 处理星星按钮的点击事件
    @objc func starButtonTapped(_ gesture: UITapGestureRecognizer) {
        guard let starButton = gesture.view as? UIButton else { return }
        updateStarRating(selectedIndex: starButton.tag) // 更新星星评分
    }
    
    // 处理星星按钮的拖动事件
    @objc func starButtonDragged(_ gesture: UIPanGestureRecognizer) {
        guard let starButton = gesture.view as? UIButton else { return }
        
        switch gesture.state {
        case .began, .changed:
            let location = gesture.location(in: starButton.superview) // 获取手指在父视图中的位置
            let percentage = location.x / starButton.superview!.bounds.width // 计算手指位置的百分比
            let starIndex = min(max(0, Int(percentage * CGFloat(starButtons.count))), starButtons.count-1) // 根据百分比计算星星按钮的索引
            updateStarRating(selectedIndex: starIndex) // 更新星星评分
        default:
            break
        }
    }
    
    // MARK: - Update
    
    // 更新星星评分
    func updateStarRating(selectedIndex: Int) {
        for (index, button) in starButtons.enumerated() {
            button.isSelected = index <= selectedIndex // 设置按钮的选中状态
        }
        ratingCallback?("\(selectedIndex + 1)") // 输出用户评分
    }
}
