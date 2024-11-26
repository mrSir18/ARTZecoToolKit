//
//  ARTCustomDanmakuCell.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/11/9.
//

import ARTZecoToolKit

class ARTCustomDanmakuCell: ARTDanmakuCell {
    
    public var bulletLabel: UILabel!
    
    // MARK: - Override Super Methods
    
    override func setupViews() {
        
        let contents: [String] = [
            "这款产品非常好，使用！",
            "质量很不错。",
            "非常满意的一次购。",
            "非常亮。",
            "收到商品比很高。",
            "给朋友买的，他很喜欢，赞一个！",
            "弹幕 😄 \(arc4random())"
        ]
        bulletLabel = UILabel()
        bulletLabel.text = contents.randomElement()
        bulletLabel.textColor = .white
        bulletLabel.font = UIFont.systemFont(ofSize: 16)
        bulletLabel.backgroundColor = .art_randomColor()
        bulletLabel.sizeToFit()
        addSubview(bulletLabel)
        danmakuSize = bulletLabel.bounds.size
    }
}
