//
//  ARTVideoPlayerPortraitBarrageCell.swift
//  ARTZeco
//
//  Created by mrSir18 on 2024/11/7.
//

import ARTZecoToolKit

class ARTVideoPlayerPortraitBarrageCell: UICollectionViewCell {
    
    /// 触觉反馈发生器
    public var feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    /// 滑块选项
    private var option: ARTVideoPlayerGeneralDanmakuEntity.SliderOption!
    
    /// 标题标签
    private var titleLabel: UILabel!
    
    /// 百分比标签
    private var percentLabel: UILabel!
    
    /// 滑块视图
    public lazy var slider: ARTVideoPlayerSlider = {
        let view = ARTVideoPlayerSlider()
        view.minimumValue = 0.0
        view.maximumValue = 1.0
        view.minimumTrackTintColor = .art_color(withHEXValue: 0xFE5C01)
        view.maximumTrackTintColor = .art_color(withHEXValue: 0xE3E3E5, alpha: 0.6)
        view.trackHeight = ARTAdaptedValue(2.0)
        if let thumbImage = UIImage(named: "icon_video_slider_portrait_danmaku_thumb")?.art_scaled(to: ARTAdaptedSize(width: 14.0, height: 14.0)) {
            view.setThumbImage(thumbImage, for: .normal)
        }
        view.addTarget(self, action: #selector(handleSliderValueChanged(_:)), for: .valueChanged)
        view.addTarget(self, action: #selector(handleSliderTouchEnded(_:)), for: [.touchUpInside, .touchCancel, .touchUpOutside])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(sliderTapped(_:)))
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    /// 滑块值改变回调
    /// - Parameters:
    ///  - value: 当前滑块值
    ///  - shouldSave 是否需要保存
    public var sliderValueChanged: ((Int, Bool) -> Void)?
    
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        feedbackGenerator.prepare() // 准备好触觉反馈
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
        titleLabel.textColor            = .art_color(withHEXValue: 0x000000)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(ARTAdaptedValue(32.0))
            make.height.equalTo(ARTAdaptedValue(16.0))
        }
        
        // 创建百分比标签
        percentLabel = UILabel()
        percentLabel.textAlignment      = .center
        percentLabel.font               = .art_medium(ARTAdaptedValue(10.0))
        percentLabel.textColor          = .art_color(withHEXValue: 0x000000)
        contentView.addSubview(percentLabel)
        percentLabel.snp.makeConstraints { make in
            make.size.equalTo(ARTAdaptedSize(width: 44.0, height: 14.0))
            make.top.equalTo(titleLabel.snp.bottom).offset(ARTAdaptedValue(6.0))
            make.right.equalTo(-ARTAdaptedValue(24.0))
        }
        
        // 创建滑块视图
        contentView.addSubview(slider)
        slider.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.centerY.equalTo(percentLabel)
            make.right.equalTo(-ARTAdaptedValue(84.0))
            make.height.equalTo(ARTAdaptedValue(40.0))
        }
    }
    
    // MARK: - Private Methods
    
    private func addDotsToSlider(maxValue: Int) { // 添加圆点到滑动轨道
        guard maxValue > 1 else { return }
        self.layoutIfNeeded()
        let dotSize: CGFloat = ARTAdaptedValue(4.0)
        let trackWidth = self.slider.bounds.width
        let dotSpacing = trackWidth / CGFloat(maxValue)
        self.removeDotsFromSlider()
    
        for i in 0...maxValue {
            let dotX = CGFloat(i) * dotSpacing // 圆点的位置从轨道的最左侧开始
            let dotView = UIView()
            dotView.layer.cornerRadius = dotSize / 2
            dotView.frame = CGRect(
                x: dotX - dotSize / 2, // 圆点居中显示，修正X坐标
                y: (self.slider.bounds.height - dotSize) / 2,
                width: dotSize,
                height: dotSize
            )
            dotView.backgroundColor = (i <= Int(option.defaultValue)) ? UIColor.art_color(withHEXValue: 0xFE5C01) : UIColor.art_color(withHEXValue: 0xE3E3E5, alpha: 0.6)
            dotView.tag = 100 + i
            self.slider.addSubview(dotView)
        }
    }
    
    private func updateDotsColor(for value: Float) {
        let activeIndex = nearestSegmentIndex(for: value)
        self.slider.subviews.forEach { subview in
            if subview.tag >= 100 { // 只对圆点进行操作
                let index = subview.tag - 100
                let color: UIColor = index <= activeIndex ? UIColor.art_color(withHEXValue: 0xFE5C01) : UIColor.art_color(withHEXValue: 0xE3E3E5, alpha: 0.6)
                subview.backgroundColor = color
            }
        }
    }
    
    private func removeDotsFromSlider() { // 移除圆点
        self.slider.subviews.filter { $0.tag >= 100 }.forEach { $0.removeFromSuperview() }
    }
    
    // MARK: - Public Methods
    
    public func configureWithSliderOption(_ option: ARTVideoPlayerGeneralDanmakuEntity.SliderOption) {
        self.option = option
        titleLabel.text = option.title
        if option.optionType == .opacity {
            let percentValue = Int(option.defaultValue)
            percentLabel.text = "\(percentValue)%"
            slider.value = Float(option.defaultValue) / 100.0
            removeDotsFromSlider() // 移除圆点
            
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

extension ARTVideoPlayerPortraitBarrageCell {
    
    /// 滑块值改变事件
    @objc private func handleSliderValueChanged(_ slider: ARTVideoPlayerSlider) {
        updateSlider(for: slider.value, shouldSave: false)
        updateDotsColor(for: slider.value)
    }
    
    /// 滑块触摸结束事件
    @objc private func handleSliderTouchEnded(_ slider: ARTVideoPlayerSlider) {
        // 调整滑块到最接近的分段值
        let adjustedValue = adjustedSegmentValue(for: slider.value)
        slider.setValue(adjustedValue, animated: true)
        
        // 更新显示标签
        updateSlider(for: adjustedValue, shouldSave: true)
        updateDotsColor(for: adjustedValue)
        
        // 触发触觉反馈
        if option.optionType != .opacity { feedbackGenerator.impactOccurred() }
    }
    
    @objc private func sliderTapped(_ gesture: UITapGestureRecognizer) {
        // 计算点击位置的比例
        let locationRatio = gesture.location(in: slider).x / slider.bounds.width
        
        // 根据点击位置计算新的滑块值
        let tappedValue = Float(locationRatio) * (slider.maximumValue - slider.minimumValue) + slider.minimumValue
        
        // 调整滑块值到最接近的分段
        let adjustedValue = adjustedSegmentValue(for: tappedValue)
        slider.setValue(adjustedValue, animated: true)
        
        // 更新显示标签
        updateSlider(for: adjustedValue, shouldSave: true)
        updateDotsColor(for: adjustedValue)
        
        // 触发触觉反馈
        feedbackGenerator.impactOccurred()
    }
    
    /// 根据滑块值更新标签和回调
    /// - Parameters:
    ///   - value: 当前滑块值
    ///   - animated: 是否需要动画效果
    private func updateSlider(for value: Float, shouldSave: Bool) {
        var displayValue: String // 显示值
        var finalValue: Int // 索引值
        
        if option.optionType == .opacity { // 百分比模式
            finalValue = Int(value * 100.0) // 透明度模式下，直接转换为百分比
            displayValue = "\(finalValue)%"
        } else { // 分段模式
            let segmentIndex = nearestSegmentIndex(for: value)
            finalValue = segmentIndex // 分段值即为最接近的分段索引
            displayValue = option.segments[segmentIndex]
        }
        percentLabel.text = displayValue
        sliderValueChanged?(finalValue, shouldSave)
    }
    
    /// 计算最接近的分段值，若不适用分段则直接返回当前值
    /// - Parameter value: 当前滑块值
    /// - Returns: 调整后的分段值
    private func adjustedSegmentValue(for value: Float) -> Float {
        guard option.optionType != .opacity else { return value } // 如果是透明度设置，直接返回当前值
        return Float(nearestSegmentIndex(for: value)) * (slider.maximumValue / Float(option.segments.count - 1)) // 否则返回最接近的分段值
    }
    
    /// 获取最接近的分段索引
    /// - Parameter value: 当前滑块值
    /// - Returns: 最接近的分段索引
    private func nearestSegmentIndex(for value: Float) -> Int {
        let segmentWidth = slider.maximumValue / Float(option.segments.count - 1) // 计算每个分段的宽度
        return min(Int(round(value / segmentWidth)), option.segments.count - 1) // 返回最接近的分段索引，确保索引不超出范围
    }
}
