//
//  ARTVideoPlayerConfig.swift
//  Pods
//
//  Created by mrSir18 on 2024/10/15.
//

/// 视频播放器配置模型
public struct ARTVideoPlayerConfig {

    public init() {}
    
    // MARK: - 基础配置
    public var url: URL?                                // 视频地址
    public var isAutoPlay: Bool = true                  // 是否自动播放
    public var isLoop: Bool = false                     // 是否循环播放
    public var isMuted: Bool = false                    // 是否静音
    public var isFullScreen: Bool = false               // 是否全屏播放
    public var isLockScreen: Bool = false               // 是否锁定屏幕
    public var isLandscape: Bool = true                 // 是否横屏播放
    public var isShowCoverView: Bool = true             // 是否显示封面视图
    public var isShowPreviewView: Bool = true           // 是否显示预览缩略图
    
    
    // MARK: - 顶部栏状态
    public var isShowTopBar: Bool = true                // 是否显示顶部工具栏
    public var isShowBackButton: Bool = true            // 是否显示返回按钮
    public var isShowTitle: Bool = true                 // 是否显示标题
    public var isShowDesc: Bool = true                  // 是否显示描述
    public var isShowShareButton: Bool = true           // 是否显示分享按钮
    public var isShowFavoriteButton: Bool = true        // 是否显示收藏按钮
    
    
    // MARK: - 中间栏状态
    public var isShowLoading: Bool = true               // 是否显示加载动画
    public var isShowVolumeSlider: Bool = true          // 是否显示音量调节条
    public var isShowBrightnessSlider: Bool = true      // 是否显示亮度调节条
    public var isShowPlayButton: Bool = true            // 是否显示【播放/暂停/重播】按钮
    public var isShowLockButton: Bool = true            // 是否显示锁定按钮
    public var isShowMuteButton: Bool = false           // 是否显示静音按钮
    public var isShowScreenshotButton: Bool = false     // 是否显示截图按钮
    public var isShowSubtitleButton: Bool = false       // 是否显示字幕按钮
    
    
    // MARK: - 底部栏状态
    public var isShowBottomBar: Bool = true             // 是否显示底部工具栏
    public var isShowCurrentTime: Bool = true           // 是否显示当前播放时间
    public var isShowFullScreenButton: Bool = true      // 是否显示全屏按钮
    public var isShowProgressSlider: Bool = true        // 是否显示进度条
    public var isShowBufferProgress: Bool = true        // 是否显示缓冲进度
    public var isShowNextButton: Bool = true            // 是否显示下一集按钮
    public var isShowDanmakuList: Bool = true           // 是否显示弹幕列表
    public var isShowDanmakuButton: Bool = true         // 是否显示弹幕按钮
    public var isShowDanmakuSettingButton: Bool = true  // 是否显示弹幕设置按钮
    public var isShowDanmakuSendInput: Bool = true      // 是否显示弹幕发送输入框
    public var isShowMoreButton: Bool = true            // 是否显示更多按钮
    public var isShowDownloadButton: Bool = false       // 是否显示下载按钮
    public var isShowCommentButton: Bool = true         // 是否显示评论按钮
    public var isShowRateButton: Bool = true            // 是否显示倍速按钮
    public var isShowDefinitionButton: Bool = false     // 是否显示清晰度按钮
    public var isShowPlaylistButton: Bool = true        // 是否显示合集按钮
}
