//
//  ARTAlignmentButton.swift
//  Alamofire
//
//  Created by mrSir18 on 2024/5/22.
//

import UIKit

/// 布局类型枚举
public enum LayoutType {
    /// 自由布局
    case freeform
    /// 固定布局
    case fixed
}

/// 图片对齐方式枚举
public enum ImageAlignment {
    /// 水平居中
    case centerX
    /// 垂直居中
    case centerY
    /// 顶部对齐
    case top
    /// 底部对齐
    case bottom
    /// 左侧对齐
    case left
    /// 右侧对齐
    case right
    /// 左上对齐
    case topLeft
    /// 右上对齐
    case topRight
    /// 左下对齐
    case bottomLeft
    /// 右下对齐
    case bottomRight
}

/// 标题对齐方式枚举
public enum TitleAlignment {
    /// 顶部对齐
    case top
    /// 底部对齐
    case bottom
    /// 左侧对齐
    case left
    /// 右侧对齐
    case right
}

public class ARTAlignmentButton: UIButton {
    
    /// 布局类型，默认为固定布局
    ///
    /// 需要设置布局类型，即（左上、左下、右上、右下）任意才能生效
    /// NOTE:imageEdgeInset、titleEdgeInset设置任意布局（freeform 配合使用）
    /// NOTE: 当固定布局时，imageAlignment（水平居中、垂直居中、上、下、左、右）、titleAlignment（上、下、左、右）imageTitleSpacing无效
    /// NOTE: 仅topLeft、topRight、bottomLeft、bottomRight有效
    public var layoutType: LayoutType = .fixed
    
    // 图片对齐方式，默认为水平居中
    public var imageAlignment: ImageAlignment = .centerX
    
    // 标题对齐方式，默认为右对齐
    public var titleAlignment: TitleAlignment = .right
    
    // 图片尺寸，默认为18.0*18.0
    public var imageSize: CGSize = CGSize(width: 18.0, height: 18.0)
    
    // 图片和标题之间的间距，默认为0.0
    public var imageTitleSpacing: CGFloat = 0.0
    
    // 图片边距，默认为UIEdgeInsets.zero
    public var imageEdgeInset: UIEdgeInsets = .zero
    
    // 标题边距，默认为UIEdgeInsets.zero
    public var titleEdgeInset: UIEdgeInsets = .zero
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        // 获取标题标签和图像视图
        guard let titleLabel = titleLabel, let imageView = imageView else {
            return
        }
        
        // 图片和标题的矩形框
        var imageRect: CGRect = .zero
        var titleRect: CGRect = .zero
        
        // 计算标题的大小
        var titleSize = titleLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        titleSize.height = titleLabel.font.pointSize
        
        if layoutType == .freeform {
            // 自有布局 - 图片与标题，坐标默认xy=0为起点, 以左上角为原点
            layoutFreeform(titleSize: titleSize, imageRect: &imageRect, titleRect: &titleRect)
        } else {
            
            // 固定布局 - 图像和标题
            switch imageAlignment {
            case .centerX:
                layoutCenterX(titleSize: titleSize, imageRect: &imageRect, titleRect: &titleRect)
            case .centerY:
                layoutCenterY(titleSize: titleSize, imageRect: &imageRect, titleRect: &titleRect)
            case .top:
                layoutTop(titleSize: titleSize, imageRect: &imageRect, titleRect: &titleRect)
            case .bottom:
                layoutBottom(titleSize: titleSize, imageRect: &imageRect, titleRect: &titleRect)
            case .left:
                layoutLeft(titleSize: titleSize, imageRect: &imageRect, titleRect: &titleRect)
            case .right:
                layoutRight(titleSize: titleSize, imageRect: &imageRect, titleRect: &titleRect)
            default:
                break
            }
        }
        
        // 设置图像和标题的框架
        imageView.frame = imageRect.integral
        titleLabel.frame = titleRect.integral
    }
    
    // 固定布局 - 居中
    private func layoutCenterX(titleSize: CGSize, imageRect: inout CGRect, titleRect: inout CGRect) {
        let left = (bounds.width - imageSize.width - titleSize.width - imageTitleSpacing) / 2
        imageRect = CGRect(x: left, y: (bounds.height - imageSize.height) / 2, width: imageSize.width, height: imageSize.height)
        titleRect = CGRect(x: imageRect.maxX + imageTitleSpacing, y: (bounds.height - titleSize.height) / 2, width: titleSize.width, height: titleSize.height)
    }
    
    // 固定布局 - 垂直
    private func layoutCenterY(titleSize: CGSize, imageRect: inout CGRect, titleRect: inout CGRect) {
        let top = (bounds.height - imageSize.height - titleSize.height - imageTitleSpacing) / 2
        imageRect = CGRect(x: (bounds.width - imageSize.width) / 2, y: top, width: imageSize.width, height: imageSize.height)
        titleRect = CGRect(x: (bounds.width - titleSize.width) / 2, y: imageRect.maxY + imageTitleSpacing, width: titleSize.width, height: titleSize.height)
    }
    
    // 固定布局 - 图片在上方
    private func layoutTop(titleSize: CGSize, imageRect: inout CGRect, titleRect: inout CGRect) {
        let commonX = (bounds.width - imageSize.width - titleSize.width - imageTitleSpacing) / 2
        switch titleAlignment {
        case .top:
            titleRect = CGRect(x: (bounds.width - titleSize.width) / 2, y: 0.0, width: titleSize.width, height: titleSize.height)
            imageRect = CGRect(x: (bounds.width - imageSize.width) / 2, y: titleRect.maxY + imageTitleSpacing, width: imageSize.width, height: imageSize.height)
        case .bottom:
            imageRect = CGRect(x: (bounds.width - imageSize.width) / 2, y: 0.0, width: imageSize.width, height: imageSize.height)
            titleRect = CGRect(x: (bounds.width - titleSize.width) / 2, y: imageRect.maxY + imageTitleSpacing, width: titleSize.width, height: titleSize.height)
        case .left:
            titleRect = CGRect(x: commonX, y: (imageSize.height - titleSize.height) / 2, width: titleSize.width, height: titleSize.height)
            imageRect = CGRect(x: titleRect.maxX + imageTitleSpacing, y: 0.0, width: imageSize.width, height: imageSize.height)
        case .right:
            imageRect = CGRect(x: commonX, y: 0.0, width: imageSize.width, height: imageSize.height)
            titleRect = CGRect(x: imageRect.maxX + imageTitleSpacing, y: (imageSize.height - titleSize.height) / 2, width: titleSize.width, height: titleSize.height)
        }
    }
    
    // 固定布局 - 图片在底部
    private func layoutBottom(titleSize: CGSize, imageRect: inout CGRect, titleRect: inout CGRect) {
        let commonX = (bounds.width - imageSize.width - titleSize.width - imageTitleSpacing) / 2
        let top = bounds.height - imageSize.height
        switch titleAlignment {
        case .top:
            titleRect = CGRect(x: (bounds.width - titleSize.width) / 2, y: top - titleSize.height - imageTitleSpacing, width: titleSize.width, height: titleSize.height)
            imageRect = CGRect(x: (bounds.width - imageSize.width) / 2, y: titleRect.maxY + imageTitleSpacing, width: imageSize.width, height: imageSize.height)
        case .bottom:
            imageRect = CGRect(x: (bounds.width - imageSize.width) / 2, y: top - (titleSize.height + imageTitleSpacing), width: imageSize.width, height: imageSize.height)
            titleRect = CGRect(x: (bounds.width - titleSize.width) / 2, y: imageRect.maxY + imageTitleSpacing, width: titleSize.width, height: titleSize.height)
        case .left:
            titleRect = CGRect(x: commonX, y: top + (imageSize.height - titleSize.height) / 2, width: titleSize.width, height: titleSize.height)
            imageRect = CGRect(x: titleRect.maxX + imageTitleSpacing, y: top, width: imageSize.width, height: imageSize.height)
        case .right:
            imageRect = CGRect(x: commonX, y: top, width: imageSize.width, height: imageSize.height)
            titleRect = CGRect(x: imageRect.maxX + imageTitleSpacing, y: top + (imageSize.height - titleSize.height) / 2, width: titleSize.width, height: titleSize.height)
        }
    }
    
    // 固定布局 - 图片在左侧
    private func layoutLeft(titleSize: CGSize, imageRect: inout CGRect, titleRect: inout CGRect) {
        let commonY = (bounds.height - titleSize.height - imageSize.height - imageTitleSpacing) / 2
        switch titleAlignment {
        case .top:
            titleRect = CGRect(x: (imageSize.width - titleSize.width) / 2, y: commonY, width: titleSize.width, height: titleSize.height)
            imageRect = CGRect(x: 0.0, y: titleRect.maxY + imageTitleSpacing, width: imageSize.width, height: imageSize.height)
        case .bottom:
            imageRect = CGRect(x: 0.0, y: commonY, width: imageSize.width, height: imageSize.height)
            titleRect = CGRect(x: (imageSize.width - titleSize.width) / 2, y: imageRect.maxY + imageTitleSpacing, width: titleSize.width, height: titleSize.height)
        case .left:
            titleRect = CGRect(x: 0.0, y: (bounds.height - titleSize.height) / 2, width: titleSize.width, height: titleSize.height)
            imageRect = CGRect(x: titleRect.maxX + imageTitleSpacing, y: (bounds.height - imageSize.height) / 2, width: imageSize.width, height: imageSize.height)
        case .right:
            imageRect = CGRect(x: 0.0, y: (bounds.height - imageSize.height) / 2, width: imageSize.width, height: imageSize.height)
            titleRect = CGRect(x: imageRect.maxX + imageTitleSpacing, y: (bounds.height - titleSize.height) / 2, width: titleSize.width, height: titleSize.height)
        }
    }
    
    // 固定布局 - 图片在右侧
    private func layoutRight(titleSize: CGSize, imageRect: inout CGRect, titleRect: inout CGRect) {
        let commonY = (bounds.height - titleSize.height - imageSize.height - imageTitleSpacing) / 2
        let left = bounds.width - imageSize.width
        switch titleAlignment {
        case .top:
            titleRect = CGRect(x: left + (imageSize.width - titleSize.width) / 2, y: commonY, width: titleSize.width, height: titleSize.height)
            imageRect = CGRect(x: left, y: titleRect.maxY + imageTitleSpacing, width: imageSize.width, height: imageSize.height)
        case .bottom:
            imageRect = CGRect(x: left, y: commonY, width: imageSize.width, height: imageSize.height)
            titleRect = CGRect(x: left + (imageSize.width - titleSize.width) / 2, y: imageRect.maxY + imageTitleSpacing, width: titleSize.width, height: titleSize.height)
        case .left:
            titleRect = CGRect(x: bounds.width - imageSize.width - titleSize.width - imageTitleSpacing, y: (bounds.height - titleSize.height) / 2, width: titleSize.width, height: titleSize.height)
            imageRect = CGRect(x: bounds.width - imageSize.width, y: (bounds.height - imageSize.height) / 2, width: imageSize.width, height: imageSize.height)
        case .right:
            titleRect = CGRect(x: bounds.width - titleSize.width, y: (bounds.height - titleSize.height) / 2, width: titleSize.width, height: titleSize.height)
            imageRect = CGRect(x: bounds.width - titleSize.width - imageTitleSpacing - imageSize.width, y: (bounds.height - imageSize.height) / 2, width: imageSize.width, height: imageSize.height)
        }
    }
    
    // 自由布局 - 左上布局
    private func layoutFreeform(titleSize: CGSize, imageRect: inout CGRect, titleRect: inout CGRect) {
        switch imageAlignment {
        case .topLeft:
            titleRect = CGRect(x: titleEdgeInset.left, y: titleEdgeInset.top, width: titleSize.width, height: titleSize.height)
            imageRect = CGRect(x: imageEdgeInset.left, y: imageEdgeInset.top, width: imageSize.width, height: imageSize.height)
        case .bottomLeft:
            imageRect = CGRect(x: imageEdgeInset.left, y: bounds.height - imageSize.height - imageEdgeInset.bottom, width: imageSize.width, height: imageSize.height)
            titleRect = CGRect(x: titleEdgeInset.left, y: bounds.height - titleSize.height - titleEdgeInset.bottom, width: titleSize.width, height: titleSize.height)
        case .topRight:
            titleRect = CGRect(x: bounds.width - titleSize.width - titleEdgeInset.right, y: titleEdgeInset.top, width: titleSize.width, height: titleSize.height)
            imageRect = CGRect(x: bounds.width - imageSize.width - imageEdgeInset.right, y: imageEdgeInset.top, width: imageSize.width, height: imageSize.height)
        case .bottomRight:
            imageRect = CGRect(x: bounds.width - imageSize.width - imageEdgeInset.right, y: bounds.height - imageSize.height - imageEdgeInset.bottom, width: imageSize.width, height: imageSize.height)
            titleRect = CGRect(x: bounds.width - titleSize.width - titleEdgeInset.right, y: bounds.height - titleSize.height - titleEdgeInset.bottom, width: titleSize.width, height: titleSize.height)
        default:
            break
        }
    }
}
