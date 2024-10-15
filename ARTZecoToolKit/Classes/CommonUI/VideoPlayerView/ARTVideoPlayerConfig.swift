//
//  ARTVideoPlayerConfig.swift
//  Pods
//
//  Created by mrSir18 on 2024/10/15.
//

/// 视频播放器配置模型
public struct ARTVideoPlayerConfig {
    
    // MARK: - 基础配置
    var url: URL?                               // 视频地址
    var isAutoPlay: Bool = true                 // 是否自动播放
    var isLoop: Bool = false                    // 是否循环播放
    var isMuted: Bool = false                   // 是否静音
    var isFullScreen: Bool = false              // 是否全屏播放
    var isShowCoverView: Bool = true            // 是否显示封面视图
    var isShowPreviewView: Bool = true          // 是否显示预览视图
    
    
    // MARK: - 顶部栏状态
    var isShowTopBar: Bool = true               // 是否显示顶部工具栏
    var isShowBackButton: Bool = true           // 是否显示返回按钮
    var isShowTitle: Bool = true                // 是否显示标题
    var isShowDesc: Bool = true                 // 是否显示描述
    var isShowShareButton: Bool = true          // 是否显示分享按钮
    var isShowFavoriteButton: Bool = true       // 是否显示收藏按钮
    
    
    // MARK: - 中间栏状态
    var isShowLoading: Bool = true              // 是否显示加载动画
    var isShowVolumeSlider: Bool = true         // 是否显示音量调节条
    var isShowBrightnessSlider: Bool = true     // 是否显示亮度调节条
    var isShowPlayButton: Bool = true           // 是否显示【播放/暂停/重播】按钮
    var isShowLockButton: Bool = true           // 是否显示锁定按钮
    var isShowMuteButton: Bool = false          // 是否显示静音按钮
    var isShowScreenshotButton: Bool = false    // 是否显示截图按钮
    var isShowSubtitleButton: Bool = false      // 是否显示字幕按钮
    
    
    // MARK: - 底部栏状态
    var isShowBottomBar: Bool = true            // 是否显示底部工具栏
    var isShowCurrentTime: Bool = true          // 是否显示当前播放时间
    var isShowFullScreenButton: Bool = true     // 是否显示全屏按钮
    var isShowProgressSlider: Bool = true       // 是否显示进度条
    var isShowBufferProgress: Bool = true       // 是否显示缓冲进度
    var isShowNextButton: Bool = true           // 是否显示下一集按钮
    var isShowDanmakuList: Bool = true          // 是否显示弹幕列表
    var isShowDanmakuButton: Bool = true        // 是否显示弹幕按钮
    var isShowDanmakuSettingButton: Bool = true // 是否显示弹幕设置按钮
    var isShowDanmakuSendInput: Bool = true     // 是否显示弹幕发送输入框
    var isShowMoreButton: Bool = true           // 是否显示更多按钮
    var isShowDownloadButton: Bool = false      // 是否显示下载按钮
    var isShowCommentButton: Bool = true        // 是否显示评论按钮
    var isShowRateButton: Bool = true           // 是否显示倍速按钮
    var isShowDefinitionButton: Bool = false    // 是否显示清晰度按钮
    var isShowPlaylistButton: Bool = true       // 是否显示合集按钮
}
