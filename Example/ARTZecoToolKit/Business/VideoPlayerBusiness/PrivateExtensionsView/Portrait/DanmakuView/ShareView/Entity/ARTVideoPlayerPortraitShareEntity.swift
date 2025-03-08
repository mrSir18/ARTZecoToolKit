//
//  ARTVideoPlayerPortraitShareEntity.swift
//  ARTZeco
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
        ShareOption(icon: "icon_share_session", title: "微信好友", type: .wechatFriend),
        ShareOption(icon: "icon_share_timeline", title: "微信朋友圈", type: .wechatMoments),
        ShareOption(icon: "icon_share_copy", title: "复制链接", type: .copyLink),
        ShareOption(icon: "icon_share_download", title: "保存照片", type: .savePhoto)
    ]
    
    // 初始化
    init() {}
}
