//
//  ARTVideoPlayerDanmakuCell.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/11/6.
//

class ARTVideoPlayerDanmakuCell: UICollectionViewCell {
    
    /// 标题标签
    private var titleLabel: UILabel!

    /// 百分比标签
    private var percentLabel: UILabel!
    
    /// 滑块
    public lazy var slider: ARTVideoPlayerSlider = {
        let view = ARTVideoPlayerSlider()
        view.minimumValue = 0.0
        view.maximumValue = 1.0
        view.minimumTrackTintColor = .art_color(withHEXValue: 0xFE5C01)
        view.maximumTrackTintColor = .art_color(withHEXValue: 0xC8C8CC, alpha: 0.5)
        view.trackHeight = ARTAdaptedValue(2.0)
        if let thumbImage = UIImage(named: "video_slider_danmaku_thumb")?.art_scaled(to: ARTAdaptedSize(width: 14.0, height: 14.0)) {
            view.setThumbImage(thumbImage, for: .normal)
        }
        view.addTarget(self, action: #selector(handleSliderTouchBegan(_:)), for: .touchDown)
        view.addTarget(self, action: #selector(handleSliderValueChanged(_:)), for: .valueChanged)
        view.addTarget(self, action: #selector(handleSliderTouchEnded(_:)), for: [.touchUpInside, .touchCancel, .touchUpOutside])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(sliderTapped(_:)))
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        // 创建标题标签
        titleLabel = UILabel()
        titleLabel.textAlignment        = .left
        titleLabel.font                 = .art_regular(ARTAdaptedValue(11.0))
        titleLabel.textColor            = .art_color(withHEXValue: 0xC8C8CC)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(ARTAdaptedValue(12.0))
            make.height.equalTo(ARTAdaptedValue(18.0))
        }
        
        // 创建百分比标签
        percentLabel = UILabel()
        percentLabel.text               = "适中"
        percentLabel.textAlignment      = .right
        percentLabel.font               = .art_medium(ARTAdaptedValue(10.0))
        percentLabel.textColor          = .art_color(withHEXValue: 0xFFFFFF)
        contentView.addSubview(percentLabel)
        percentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(ARTAdaptedValue(6.0))
            make.right.equalTo(-ARTAdaptedValue(12.0))
            make.height.equalTo(ARTAdaptedValue(14.0))
        }
        
        // 创建滑块视图
        contentView.addSubview(slider)
        slider.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.centerY.equalTo(percentLabel)
            make.right.equalTo(-ARTAdaptedValue(60.0))
            make.height.equalTo(ARTAdaptedValue(30.0))
        }
    }
    
    // MARK: - Private Methods

    private func addDotsToSlider(maxValue: Int) { // 添加圆点到滑动轨道
        guard maxValue > 1 else { return }
        self.layoutIfNeeded() // 确保滑块已经布局完成
        
        let dotSize: CGFloat = ARTAdaptedValue(4.0)
        let trackWidth = self.slider.bounds.width
        let dotSpacing = trackWidth / CGFloat(maxValue)

        // 移除已有的圆点
        self.slider.layer.sublayers?.removeAll { $0.name == "dotLayer" }

        // 添加新的圆点
        (0...maxValue).forEach { i in
            let dot = CALayer()
            dot.name = "dotLayer"
            dot.backgroundColor = UIColor.white.cgColor
            dot.cornerRadius = dotSize / 2
            dot.frame = CGRect(
                x: CGFloat(i) * dotSpacing - dotSize / 2,
                y: (self.slider.bounds.height - dotSize) / 2,
                width: dotSize,
                height: dotSize)
            self.slider.layer.addSublayer(dot)
        }
    }
    
    // MARK: - Public Methods

    func configureWithSliderOption(_ option: ARTVideoPlayerDanmakuView.SliderOption) {
        titleLabel.text = option.title
        if option.segments.isEmpty {
            let percentValue = Int(option.defaultValue)
            percentLabel.text = "\(percentValue)%"
            slider.value = Float(option.defaultValue) / 100.0
        } else {
            let value = option.defaultValue
            let segmentIndex = min(Int(value), option.segments.count - 1)
            percentLabel.text = option.segments[segmentIndex]
            slider.value = Float(value) / Float(option.maxValue)
            addDotsToSlider(maxValue: option.maxValue) // 添加圆点到滑动轨道
        }
    }
}

// MARK: - Slider Events

extension ARTVideoPlayerDanmakuCell {
    
    /// 触摸开始时调用的函数
    @objc private func handleSliderTouchBegan(_ slider: ARTVideoPlayerSlider) {
        print("开始触摸滑块")
    }
    
    /// 滑块值改变时调用的函数
    @objc private func handleSliderValueChanged(_ slider: ARTVideoPlayerSlider) {
        print("滑块值改变")
    }
    
    /// 触摸结束时调用的函数
    @objc private func handleSliderTouchEnded(_ slider: ARTVideoPlayerSlider) {
        print("结束触摸滑块")
    }
    
    /// 处理滑块被点击的手势
    @objc private func sliderTapped(_ gesture: UITapGestureRecognizer) {
        print("点击滑块")
    }
}
