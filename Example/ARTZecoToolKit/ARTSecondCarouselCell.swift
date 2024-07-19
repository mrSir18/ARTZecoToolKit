//
//  ARTSecondCarouselCell.swift
//  ARTZecoToolKit_Example
//
//  Created by mrSir18 on 2024/7/18.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import ARTZecoToolKit

class ARTSecondCarouselCell: UICollectionViewCell {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .art_randomColor()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {

        // 创建标题标签
        let titleLabel = UILabel()
        titleLabel.font      = .art_medium(24.0)
        titleLabel.textColor = .art_randomColor()
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    // MARK: - Public Methods
    
    func updateTitle(_ title: String) {
        guard let label = contentView.subviews.first as? UILabel else { return }
        label.text = title
    }
}
