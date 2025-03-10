//
//  ARTVideoPlayerControlsViewEnums.swift
//  ARTZeco
//
//  Created by mrSir18 on 2025/3/8.
//

class ARTVideoPlayerControls {}

// MARK: - Bottombar Button Type

extension ARTVideoPlayerControls {
    
    enum ButtonType: Int {
        
        /// 返回按钮
        case back
        
        /// 全屏按钮
        case fullscreen
        
        /// 暂停/播放按钮
        case pause
        
        /// 下一集按钮
        case next
        
        /// 弹幕开关按钮
        case danmakuToggle
        
        /// 弹幕设置按钮
        case danmakuSettings
        
        /// 发送弹幕按钮
        case danmakuSend
        
        /// 倍速按钮
        case speed
        
        /// 目录按钮
        case catalogue
        
        /// 收藏按钮
        case favorite
        
        /// 评论按钮
        case comment
        
        /// 分享按钮
        case share
        
        /// 更多按钮
        case more
    }
}
