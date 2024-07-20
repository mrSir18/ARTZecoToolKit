//
//  ARTFirstCarouselCell.swift
//  ARTZecoToolKit_Example
//
//  Created by mrSir18 on 2024/7/18.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import ARTZecoToolKit

class ARTFirstCarouselCell: UICollectionViewCell {
    
    /// 图片显示视图
    private var imageView: UIImageView!
    
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {

        // 创建图片视图
        imageView = UIImageView()
        imageView.contentMode   = .scaleAspectFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Public Methods

    func loadImage(_ imageURL: String?) {
        guard let imageURL = imageURL else { return }
        imageView.sd_setImage(with: URL(string: imageURL))
    }
}
