//
//  ARTCustomDanmakuCell.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/11/9.
//

import ARTZecoToolKit


// 协议方法
//
// - NOTE: 可继承该协议方法，实现自定义的弹幕视图
@objc public protocol ARTCustomDanmakuCellDelegate: AnyObject {
    
}

class ARTCustomDanmakuCell: ARTDanmakuCell {
    
    /// 代理对象
    public weak var delegate: ARTCustomDanmakuCellDelegate?
    
    /// 弹幕头像
    public var avatarImageView: UIImageView!
    
    /// 弹幕内容
    public var danmakuLabel: UILabel!
    
    /// 头像数据
    private let avatars = [
        "https://iknow-pic.cdn.bcebos.com/a9d3fd1f4134970ad1e5e7b187cad1c8a6865d9e",
        "https://iknow-pic.cdn.bcebos.com/00e93901213fb80e6d7d024824d12f2eb8389484",
        "https://iknow-pic.cdn.bcebos.com/a08b87d6277f9e2f42dae8950d30e924b999f344",
        "https://iknow-pic.cdn.bcebos.com/96dda144ad34598256a6a80f1ef431adcbef847b",
        "https://iknow-pic.cdn.bcebos.com/b999a9014c086e063e9ee0d610087bf40ad1cb7d",
        "https://iknow-pic.cdn.bcebos.com/a71ea8d3fd1f4134e66901e0371f95cad0c85ed5",
        "https://img0.baidu.com/it/u=3859095577,4054514440&fm=253&fmt=auto&app=120&f=JPEG?w=800& h=800",
        "https://img0.baidu.com/it/u=3712328583,2534587902&fm=253&fmt=auto&app=120&f=JPEG?w=800&h=800",
        "https://img1.baidu.com/it/u=3398593938,3000538022&fm=253&fmt=auto&app=120&f=JPEG?w=800&h=800",
        "https://img1.baidu.com/it/u=2582590344,1308971812&fm=253&fmt=auto&app=120&f=JPEG?w=800&h=800"
    ]
    
    /// 弹幕数据
    private let danmakuContents = [
        "这款产品非常好，使用！🐺",
        "质量很不错。",
        "非常满意的一次购。ಥ_ಥ",
        "非常亮。",
        "收到商品比很高。",
        "给朋友买的，他很喜欢，赞一个！",
        "弹幕 😄",
        "这个视频太棒了！",
        "有点过于激烈了吧！",
        "真是太有趣了，哈哈哈！",
        "完全被这个剧情吸引了！",
        "感觉时间过得太快了！",
        "真是个经典之作！",
        "这歌我太喜欢了！",
        "想看更多类似的视频。🐒",
        "这画质太清晰了，赞！",
        "这场面太震撼了！",
        "原来是这个意思啊，懂了！☺️",
        "不得不说，这个很精彩！",
        "大家好像都很喜欢这部片！",
        "哈哈，太好笑了！😂",
        "这个场景真是美极了！",
        "不愧是大作，震撼！🔥",
        "看得我都快哭了，感动😭",
        "这部剧果然不负期望！",
        "这演员真是太有魅力了！",
        "这背景音乐好燃！🎶",
        "感觉又学到了一些新知识。",
        "没想到剧情发展竟然是这个样子！😱",
        "这特效做得太精细了！",
        "好想再看一次，太精彩了！",
        "真的很喜欢这种类型的影片！"
    ]
    
    
    // MARK: - Initialization
    
    init(_ delegate: ARTCustomDanmakuCellDelegate? = nil) {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Super Methods
    
    override func setupViews() {
        self.backgroundColor     = .art_randomColor()
        self.layer.cornerRadius  = ARTAdaptedValue(21.0)
        self.layer.masksToBounds = true
        
        // 创建弹幕头像
        avatarImageView = UIImageView()
        avatarImageView.layer.cornerRadius  = ARTAdaptedValue(15.0)
        avatarImageView.layer.masksToBounds = true
        avatarImageView.sd_setImage(with: URL(string: avatars.randomElement() ?? ""), completed: nil)
        addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { make in
            make.size.equalTo(ARTAdaptedSize(width: 30.0, height: 30.0))
            make.left.equalTo(ARTAdaptedValue(4.0))
            make.centerY.equalToSuperview()
        }
        
        // 创建弹幕内容
        danmakuLabel = UILabel()
        danmakuLabel.text       = danmakuContents.randomElement()
        danmakuLabel.textColor  = .white
        danmakuLabel.font       = .art_regular(ARTAdaptedValue(16.0))
        danmakuLabel.sizeToFit()
        addSubview(danmakuLabel)
        danmakuLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(ARTAdaptedValue(4.0))
            make.centerY.equalTo(avatarImageView)
        }
        layoutIfNeeded()
        
        // 设置弹幕尺寸
        danmakuSize = CGSize(width: danmakuLabel.bounds.size.width + ARTAdaptedValue(18.0) + avatarImageView.bounds.size.width, height: 0.0)
    }
}
