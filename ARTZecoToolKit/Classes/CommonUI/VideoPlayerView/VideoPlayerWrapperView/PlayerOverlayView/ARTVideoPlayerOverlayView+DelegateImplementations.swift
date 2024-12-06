//
//  ARTVideoPlayerOverlayView+DelegateImplementations.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/12/6.
//

// MARK: - ARTDanmakuViewDelegate

extension ARTVideoPlayerOverlayView: ARTDanmakuViewDelegate {
    
    public func danmakuViewCreateCell(_ danmakuView: ARTDanmakuView) -> ARTDanmakuCell { // 创建弹幕
        return delegate?.overlayViewDidCreateDanmakuCell?(for: self) ?? ARTDanmakuCell()
    }
    
    public func danmakuView(_ danmakuView: ARTDanmakuView, didClickDanmakuCell danmakuCell: ARTDanmakuCell) { // 点击弹幕
        delegate?.overlayViewDidTapDanmakuCell?(for: self, danmakuCell: danmakuCell)
    }
    
    public func danmakuView(_ danmakuView: ARTDanmakuView, willDisplayDanmakuCell danmakuCell: ARTDanmakuCell) { // 弹幕开始显示
        delegate?.overlayViewWillDisplayDanmakuCell?(for: self, danmakuCell: danmakuCell)
    }
    
    public func danmakuView(_ danmakuView: ARTDanmakuView, didEndDisplayDanmakuCell danmakuCell: ARTDanmakuCell) { // 弹幕结束显示
        delegate?.overlayViewDidEndDisplayDanmakuCell?(for: self, danmakuCell: danmakuCell)
    }
    
    public func danmakuViewDidEndDisplayAllDanmaku(_ danmakuView: ARTDanmakuView) { // 所有弹幕显示完
        delegate?.overlayViewDidEndDisplayAllDanmaku?(for: self)
    }
}
