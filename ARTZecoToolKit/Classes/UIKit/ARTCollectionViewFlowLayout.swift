//
//  ARTCollectionViewFlowLayout.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2023/11/22.
//

import UIKit
import AlamofireImage

private let ART_CollectionReusableViewDecoration = "com.ART_CollectionReusableViewDecoration"

// MARK: - ART_CollectionReusableView
private class ART_CollectionReusableView: UICollectionReusableView {
    
    //初始化布局模型
    private lazy var attributes: ARTCollectionViewLayoutAttributes = {
        let attributes = ARTCollectionViewLayoutAttributes()
        return attributes
    }()
    
    //懒加载背景图片
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        self.addSubview(imageView)
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundImageView.frame = bounds
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        guard let att = layoutAttributes as? ARTCollectionViewLayoutAttributes else {
            return
        }
        self.attributes = att
        self.toChangeCollectionReusableView(self.attributes)
    }
    
    /*!自定义装饰视图*/
    private func toChangeCollectionReusableView(_ layoutAttributes: ARTCollectionViewLayoutAttributes) {
        if let model = layoutAttributes.configModel {
            let containerView: UIView = self
            containerView.layer.borderWidth     = model.borderWidth
            containerView.layer.borderColor     = model.borderColor?.cgColor
            containerView.layer.backgroundColor = model.backgroundColor?.cgColor
            containerView.layer.shadowColor     = model.shadowColor?.cgColor
            containerView.layer.shadowOffset    = model.shadowOffset
            containerView.layer.shadowOpacity   = model.shadowOpacity
            containerView.layer.shadowRadius    = model.shadowRadius
            containerView.layer.cornerRadius    = model.cornerRadius
            containerView.clipsToBounds         = model.clipsToBounds
            if let maskedCorners = model.maskedCorners {
                containerView.layer.maskedCorners   = maskedCorners
            }
            
            /*!网络请求图片加载*/
            if let imageURLString = model.imageURLString, !imageURLString.isEmpty {
                self.backgroundImageView.contentMode = model.contentMode
                if isValidHttpUrl(imageURLString) {
                    self.backgroundImageView.af.setImage(withURL: URL(string: imageURLString)!)
                } else {
                    self.backgroundImageView.image  = UIImage(named: imageURLString)
                }
            }
        }
    }
    
    /*!验证图片地址是否有效*/
    private func isValidHttpUrl(_ urlString: String) -> Bool {
        return urlString.hasPrefix("http://") || urlString.hasPrefix("https://")
    }
}

// MARK: - ARTCollectionViewLayoutAttributes
private class ARTCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    
    var configModel: ARTCollectionViewConfigModel? //自定义装饰模型
}

// MARK: - ARTCollectionViewDelegateFlowLayout
@objc public protocol ARTCollectionViewDelegateFlowLayout: UICollectionViewDelegateFlowLayout {
    
    /*!
     * @brief 装饰类视图:（默认为无装饰）
     * @returns 自定义装饰视图model
     */
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, configModelForSectionAt section: Int) -> ARTCollectionViewConfigModel?
    
    /*!
     * @brief 装饰类视图:（必选）
     * @returns 自定义item高度
     */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, heightForItemAt indexPath: IndexPath) -> CGFloat
    
    /*!
     * @brief 装饰类视图:（默认为1列）
     * @returns 自定义section列数
     */
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, columnForSectionAt section: Int) -> Int
    
    /*!
     * @brief 装饰类视图:（默认为0px）
     * @returns 自定义Section头部Header与上个Section尾部Footer间距
     */
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, spacingBetweenFooterAndNextHeaderForSectionAt section: Int) -> CGFloat
}

// MARK: - ARTCollectionViewFlowLayout
public class ARTCollectionViewFlowLayout: UICollectionViewLayout {
    
    weak var art_delegate: ARTCollectionViewDelegateFlowLayout? //代理对象
    private var art_configModel: ARTCollectionViewConfigModel?  // 装饰视图模型
    private var art_headerWithfooterLineSpacing: CGFloat = 0.0  // 页眉和页脚之间的间距
    private var art_columnCount: Int = 1                        // 单元格列数
    private var art_sectionInset: UIEdgeInsets = .zero          // 最小内边距
    private var art_minimumLineSpacing: CGFloat = 0.0           // 最小行间距
    private var art_minimumInteritemSpacing: CGFloat = 0.0      // 最小列间距
    private var art_headerReferenceSize: CGSize = .zero         // 页眉视图的大小
    private var art_footerReferenceSize: CGSize = .zero         // 页脚视图的大小
    private var art_decorationAttributes : [UICollectionViewLayoutAttributes] = [] //存放自定义Attr数组
    private var art_columnsLastHeights : [CGFloat] = [] //存放每个Section最后一个高度
    private var art_collectionHeight: CGFloat = 0.0 //collection内容高度
    private var art_lastItemHeight: CGFloat = 0.0 //最后一个Item内容高度
    
    public init(_ delegate: ARTCollectionViewDelegateFlowLayout?) {
        super.init()
        self.art_delegate = delegate
        self.register(ART_CollectionReusableView.self, forDecorationViewOfKind: ART_CollectionReusableViewDecoration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ARTCollectionViewFlowLayout {
    
    public override func prepare() {
        super.prepare()
        
        if let collectionView = self.collectionView {
            self.art_decorationAttributes.removeAll()
            self.art_columnsLastHeights.removeAll()
            self.art_collectionHeight = 0.0
            self.art_lastItemHeight = 0.0
            let numberOfSections = collectionView.numberOfSections
            
            for section in 0..<numberOfSections {
                self.art_configModel                    = self.delegate_configModelForSectionAt(section)
                self.art_headerWithfooterLineSpacing    = self.delegate_spacingBetweenFooterAndNextHeaderForSectionAt(section)
                self.art_columnCount                    = self.delegate_columnForSectionAt(section)
                self.art_sectionInset                   = self.delegate_insetForSectionAt(section)
                self.art_minimumLineSpacing             = self.delegate_minimumLineSpacingForSectionAt(section)
                self.art_minimumInteritemSpacing        = self.delegate_minimumInteritemSpacingForSectionAt(section)
                self.art_headerReferenceSize            = self.delegate_referenceSizeForHeaderInSectionAt(section)
                self.art_footerReferenceSize            = self.delegate_referenceSizeForFooterInSectionAt(section)
                
                /*!自定义装饰header*/
                let indexPath = IndexPath(item: 0, section: section)
                let headerAttributes = self.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: indexPath)
                if let headerAttributes = headerAttributes {
                    self.art_decorationAttributes.append(headerAttributes)
                    self.art_columnsLastHeights.removeAll()
                }
                self.art_lastItemHeight = self.art_collectionHeight
                self.art_columnsLastHeights = Array(repeating: self.art_collectionHeight, count: self.art_columnCount)
                
                /*!item数量*/
                let numberOfItems  = collectionView.numberOfItems(inSection: section)
                let itemIndexPaths = (0..<numberOfItems).map { IndexPath(item: $0, section: section) }
                let itemAttributes = itemIndexPaths.compactMap { self.layoutAttributesForItem(at: $0) }
                self.art_decorationAttributes.append(contentsOf: itemAttributes)
                
                /*!自定义装饰footer*/
                let footerAttributes = self.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, at: indexPath)
                if let footerAttributes = footerAttributes {
                    self.art_decorationAttributes.append(footerAttributes)
                }
                
                /*!自定义装饰model*/
                let groupWidth = collectionView.frame.size.width - self.art_sectionInset.left - self.art_sectionInset.right
                let groupHeight = footerAttributes!.frame.maxY - headerAttributes!.frame.minY
                var groupFrame = CGRect(x: self.art_sectionInset.left, y: headerAttributes!.frame.minY, width: groupWidth, height: groupHeight)
                //如果是全屏模式，调整组框架
                if self.art_configModel?.isFullScreen == true {
                    groupFrame = CGRect(x: 0, y: headerAttributes!.frame.minY, width: collectionView.frame.size.width, height: groupHeight)
                }
                let groupAttributes = ARTCollectionViewLayoutAttributes(forDecorationViewOfKind: ART_CollectionReusableViewDecoration, with: indexPath)
                groupAttributes.frame = groupFrame
                groupAttributes.zIndex = -1
                groupAttributes.configModel = self.art_configModel
                self.art_decorationAttributes.append(groupAttributes)
            }
        }
    }
    
    public override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let layoutAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
        if elementKind == UICollectionView.elementKindSectionHeader {
            self.art_collectionHeight += self.art_headerWithfooterLineSpacing
            layoutAttributes.frame = CGRect(x: 0, y: self.art_collectionHeight, width: self.art_headerReferenceSize.width, height: self.art_headerReferenceSize.height)
            self.art_collectionHeight = self.art_collectionHeight + self.art_headerReferenceSize.height + self.art_sectionInset.top
            
        } else if (elementKind == UICollectionView.elementKindSectionFooter) {
            self.art_collectionHeight += self.art_sectionInset.bottom
            layoutAttributes.frame = CGRect(x: 0, y: self.art_collectionHeight, width: self.art_footerReferenceSize.width, height: self.art_footerReferenceSize.height)
            self.art_collectionHeight += self.art_footerReferenceSize.height
            
        }
        return layoutAttributes
    }
    
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = self.collectionView else {
            return nil
        }
        let layoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        let interitemSpacing = CGFloat(self.art_columnCount - 1) * self.art_minimumInteritemSpacing
        let collectionWidth  = collectionView.frame.size.width - self.art_sectionInset.left - interitemSpacing - self.art_sectionInset.right
        let itemWidth        = collectionWidth / CGFloat(self.art_columnCount)
        let itemHeight       = self.art_delegate?.collectionView(collectionView, layout: self, heightForItemAt: indexPath) ?? 0.0
        
        if let (minColumn, minColumnHeight) = self.art_columnsLastHeights.enumerated().min(by: {$0.element < $1.element}) {
            let itemX = self.art_sectionInset.left + CGFloat(minColumn) * (itemWidth + self.art_minimumInteritemSpacing)
            let itemY = minColumnHeight + (minColumnHeight != self.art_lastItemHeight ? self.art_minimumLineSpacing : 0.0)
            
            self.art_collectionHeight = max(self.art_collectionHeight, itemY + itemHeight)
            layoutAttributes.frame = CGRect(x: itemX, y: itemY, width: itemWidth, height: itemHeight)
            self.art_columnsLastHeights[minColumn] = layoutAttributes.frame.maxY
        }
        return layoutAttributes
    }
    
    public override var collectionViewContentSize: CGSize {
        return CGSize(width: self.collectionView!.frame.size.width, height: self.art_collectionHeight)
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.art_decorationAttributes
    }
}

// MARK: - Private自定义方法: ARTCollectionViewDelegateFlowLayout
extension ARTCollectionViewFlowLayout {
    
    /*!装饰视图模型*/
    private func delegate_configModelForSectionAt(_ section: Int) -> ARTCollectionViewConfigModel {
        return self.art_delegate?.collectionView?(collectionView!, layout: self, configModelForSectionAt: section) ?? ARTCollectionViewConfigModel()
    }
    
    /*!单元格高度*/
    private func delegate_heightForItemAt(_ indexPath: IndexPath) -> CGFloat {
        return self.art_delegate?.collectionView(collectionView!, layout: self, heightForItemAt: indexPath) ?? 0.0
    }
    
    /*!单元格列数*/
    private func delegate_columnForSectionAt(_ section: Int) -> Int {
        return self.art_delegate?.collectionView?(collectionView!, layout: self, columnForSectionAt: section) ?? 1
    }
    
    /*!页脚和页眉之间的间距*/
    private func delegate_spacingBetweenFooterAndNextHeaderForSectionAt(_ section: Int) -> CGFloat {
        return self.art_delegate?.collectionView?(collectionView!, layout: self, spacingBetweenFooterAndNextHeaderForSectionAt: section) ?? 0.0
    }
}

// MARK: - Private系统方法: UICollectionViewDelegateFlowLayout
extension ARTCollectionViewFlowLayout {
    
    /*!最小内边距*/
    private func delegate_insetForSectionAt(_ section: Int) -> UIEdgeInsets {
        return self.art_delegate?.collectionView?(collectionView!, layout: self, insetForSectionAt: section) ?? .zero
    }
    
    /*!最小行间距*/
    private func delegate_minimumLineSpacingForSectionAt(_ section: Int) -> CGFloat {
        return self.art_delegate?.collectionView?(collectionView!, layout: self, minimumLineSpacingForSectionAt: section) ?? 0.0
    }
    
    /*!最小列间距*/
    private func delegate_minimumInteritemSpacingForSectionAt(_ section: Int) -> CGFloat {
        return self.art_delegate?.collectionView?(collectionView!, layout: self, minimumInteritemSpacingForSectionAt: section) ?? 0.0
    }
    
    /*!组页头视图的大小*/
    private func delegate_referenceSizeForHeaderInSectionAt(_ section: Int) -> CGSize {
        return self.art_delegate?.collectionView?(collectionView!, layout: self, referenceSizeForHeaderInSection: section) ?? .zero
    }
    
    /*!组页脚视图的大小*/
    private func delegate_referenceSizeForFooterInSectionAt(_ section: Int) -> CGSize {
        return self.art_delegate?.collectionView?(collectionView!, layout: self, referenceSizeForFooterInSection: section) ?? .zero
    }
}
