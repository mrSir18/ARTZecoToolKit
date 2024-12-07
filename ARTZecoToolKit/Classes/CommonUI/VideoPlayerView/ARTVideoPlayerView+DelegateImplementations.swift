//
//  ARTVideoPlayerView+DelegateImplementations.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/11/2.
//

// MARK: - ARTVideoPlayerwrapperViewDelegate

extension ARTVideoPlayerView: ARTVideoPlayerWrapperViewDelegate {
    
    public func customScreenOrientation(for wrapperView: ARTVideoPlayerWrapperView) -> ScreenOrientation { // 自定义播放模式
        return delegate?.customScreenOrientation?(for: self) ?? .window
    }
    
    public func customTopBar(for wrapperView: ARTVideoPlayerWrapperView, screenOrientation: ScreenOrientation) -> ARTVideoPlayerTopbar? { // 自定义顶部工具栏视图
        return delegate?.customTopBar?(for: self, screenOrientation: screenOrientation)
    }
    
    public func customBottomBar(for wrapperView: ARTVideoPlayerWrapperView, screenOrientation: ScreenOrientation) -> ARTVideoPlayerBottombar? { // 自定义底部工具
        return delegate?.customBottomBar?(for: self, screenOrientation: screenOrientation)
    }
    
    
// MARK: - 弹幕视图 - 公共方法
    
    public func wrapperViewDidCreateDanmakuCell(for wrapperView: ARTVideoPlayerWrapperView) -> ARTDanmakuCell { // 创建弹幕
        return delegate?.playerViewDidCreateDanmakuCell?(for: self) ?? ARTDanmakuCell()
    }
    
    public func wrapperViewDidTapDanmakuCell(for wrapperView: ARTVideoPlayerWrapperView, danmakuCell: ARTDanmakuCell) { // 点击弹幕
        delegate?.playerViewDidTapDanmakuCell?(for: self, danmakuCell: danmakuCell)
    }
    
    public func wrapperViewWillDisplayDanmakuCell(for wrapperView: ARTVideoPlayerWrapperView, danmakuCell: ARTDanmakuCell) { // 弹幕开始显示
        delegate?.playerViewWillDisplayDanmakuCell?(for: self, danmakuCell: danmakuCell)
    }
    
    public func wrapperViewDidEndDisplayDanmakuCell(for wrapperView: ARTVideoPlayerWrapperView, danmakuCell: ARTDanmakuCell) { // 弹幕结束显示
        delegate?.playerViewDidEndDisplayDanmakuCell?(for: self, danmakuCell: danmakuCell)
    }
    
    public func wrapperViewDidEndDisplayAllDanmaku(for wrapperView: ARTVideoPlayerWrapperView) { // 所有弹幕显示完
        delegate?.playerViewDidEndDisplayAllDanmaku?(for: self)
    }
    
    
// MARK: - 顶部工具栏 - 公共方法
    
    public func wrapperViewDidTapBack(for wrapperView: ARTVideoPlayerWrapperView) { // 点击返回按钮
        delegate?.playerViewDidTapBack?(for: self)
    }
    
    public func wrapperViewDidTapFavorite(for wrapperView: ARTVideoPlayerWrapperView, isFavorited: Bool) { // 点击收藏按钮
        delegate?.playerViewDidTapFavorite?(for: self, isFavorited: isFavorited)
    }
    
    public func wrapperViewDidTapShare(for wrapperView: ARTVideoPlayerWrapperView) { // 点击分享按钮
        delegate?.playerViewDidTapShare?(for: self)
    }
    
    
// MARK: - 底部工具栏 - 公共方法
    
    public func wrapperViewDidBeginTouch(for wrapperView: ARTVideoPlayerWrapperView, slider: ARTVideoPlayerSlider) { // 暂停播放 (开始拖动滑块)
        delegate?.playerViewDidBeginTouch?(for: self, slider: slider)
    }
    
    public func wrapperViewDidChangeValue(for wrapperView: ARTVideoPlayerWrapperView, slider: ARTVideoPlayerSlider) { // 快进/快退 (拖动滑块)
        delegate?.playerViewDidChangeValue?(for: self, slider: slider)
    }
    
    public func wrapperViewDidEndTouch(for wrapperView: ARTVideoPlayerWrapperView, slider: ARTVideoPlayerSlider) { // 恢复播放 (结束拖动滑块)
        delegate?.playerViewDidEndTouch?(for: self, slider: slider)
    }
    
    public func wrapperViewDidTap(for wrapperView: ARTVideoPlayerWrapperView, slider: ARTVideoPlayerSlider) { // 指定播放时间 (点击滑块)
        delegate?.playerViewDidTap?(for: self, slider: slider)
    }
    
    public func wrapperViewDidTapPause(for wrapperView: ARTVideoPlayerWrapperView, isPlaying: Bool) { // 暂停播放 (点击暂停按钮)
        delegate?.playerViewDidTapPause?(for: self, isPlaying: isPlaying)
    }
    
    public func wrapperViewDidTapDanmakuToggle(for wrapperView: ARTVideoPlayerWrapperView, isDanmakuEnabled: Bool) { // 弹幕开关 (点击弹幕开关按钮)
        delegate?.playerViewDidTapDanmakuToggle?(for: self, isDanmakuEnabled: isDanmakuEnabled)
    }
    
    public func wrapperViewDidTapDanmakuSettings(for wrapperView: ARTVideoPlayerWrapperView) { // 弹幕设置 (点击弹幕设置按钮)
        delegate?.playerViewDidTapDanmakuSettings?(for: self)
    }
    
    public func wrapperViewDidTapDanmakuSend(for wrapperView: ARTVideoPlayerWrapperView, text: String) { // 发送弹幕 (点击发送弹幕按钮)
        delegate?.playerViewDidTapDanmakuSend?(for: self, text: text)
    }
    
    
// MARK: - 窗口模式 - 底部工具栏
    
    public func wrapperViewDidTransitionToFullscreen(for wrapperView: ARTVideoPlayerWrapperView, orientation: ScreenOrientation) { // 点击全屏按钮
        delegate?.playerViewDidTransitionToFullscreen?(for: self, orientation: orientation)
    }
    
    
// MARK: - 横屏模式 - 底部工具栏
    
    public func wrapperViewDidTapNext(for wrapperView: ARTVideoPlayerWrapperView) { // 点击下一个按钮
        delegate?.playerViewDidTapNext?(for: self)
    }
    
    public func wrapperViewDidTapSpeed(for wrapperView: ARTVideoPlayerWrapperView) { // 点击倍速按钮
        delegate?.playerViewDidTapSpeed?(for: self)
    }
    
    public func wrapperViewDidTapCollection(for wrapperView: ARTVideoPlayerWrapperView) { // 点击收藏按钮
        delegate?.playerViewDidTapCollection?(for: self)
    }
    
    
// MARK: - 竖屏模式 - 底部工具栏
    
    public func wrapperViewDidTapComment(for wrapperView: ARTVideoPlayerWrapperView) { // 点击评论按钮
        delegate?.playerViewDidTapComment?(for: self)
    }
}
