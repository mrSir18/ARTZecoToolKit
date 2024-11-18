//
//  ARTCustomDanmakuCell.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/11/9.
//

import ARTZecoToolKit

class ARTCustomDanmakuCell: ARTVideoPlayerDanmakuCell {
    
    // MARK: - Override Super Methods
    
    override func setupViews() {
        
        self.backgroundColor = .art_randomColor()
        self.layer.cornerRadius = ARTAdaptedValue(20.0)
        self.layer.masksToBounds = true
        
        self.danmakuSize = CGSize(width: ARTAdaptedValue(200.0), height: ARTAdaptedValue(40.0))
    }
}
