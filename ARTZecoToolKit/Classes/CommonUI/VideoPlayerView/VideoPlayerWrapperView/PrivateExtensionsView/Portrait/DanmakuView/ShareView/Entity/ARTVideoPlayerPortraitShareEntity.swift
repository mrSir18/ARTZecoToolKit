//
//  ARTVideoPlayerPortraitShareEntity.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/11/7.
//

struct ARTVideoPlayerPortraitShareEntity {

    // 分享选项类型
    enum ShareOptionType {
        case wechatFriend     // 微信好友
        case wechatMoments    // 微信朋友圈
        case copyLink         // 复制链接
        case savePhoto        // 保存照片
    }
    
    // 分享选项
    struct ShareOption {
        let icon: String       // 图标
        let title: String      // 标题
        let type: ShareOptionType // 选项类型
    }
    
    // 分享选项数组
    var shareOptions: [ShareOption] = [
        ShareOption(icon: "share_session_icon", title: "微信好友", type: .wechatFriend),
        ShareOption(icon: "share_timeline_icon", title: "微信朋友圈", type: .wechatMoments),
        ShareOption(icon: "share_copy_icon", title: "复制链接", type: .copyLink),
        ShareOption(icon: "share_download_icon", title: "保存照片", type: .savePhoto)
    ]
    
    // 初始化
    init() {}
}
