//
//  ARTViewController_AlignmentButton.swift
//  ARTZecoToolKit_Example
//
//  Created by mrSir18 on 2024/5/22.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import ARTZecoToolKit

class ARTViewController_AlignmentButton: ARTBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         固定布局：部分示例
         
         对齐方式：居中、垂直、上、下、左、右
         
         layoutType: LayoutType = .fixed 默认
         */
        
        // 默认按钮
        let firstButton = ARTAlignmentButton()
        firstButton.backgroundColor = .art_randomColor()
        firstButton.setTitle("默认", for: .normal)
        firstButton.setImage(UIImage(named: "2"), for: .normal)
        firstButton.setTitleColor(.art_randomColor(), for: .normal)
        firstButton.titleLabel?.font = .systemFont(ofSize: 16.0)
        firstButton.imageTitleSpacing = 10.0    //图片与文本间距
        firstButton.imageSize = CGSize(width: 100.0, height: 100.0) // 图片大小
        firstButton.addTarget(self, action: #selector(clickButtonAction), for: .touchUpInside)
        view.addSubview(firstButton)
        firstButton.snp.makeConstraints { make in
            make.left.equalTo(10.0)
            make.top.equalTo(art_navigationFullHeight()+20.0)
            make.right.equalTo(view.snp.centerX).offset(-10.0)
            make.height.equalTo(200.0)
        }
        
        
        // 左对齐，图片在内容右侧
        let secondButton = ARTAlignmentButton()
        secondButton.backgroundColor = .art_randomColor()
        secondButton.setTitle("左对齐", for: .normal)
        secondButton.setImage(UIImage(named: "1"), for: .normal)
        secondButton.setTitleColor(.art_randomColor(), for: .normal)
        secondButton.titleLabel?.font = .systemFont(ofSize: 16.0)
        secondButton.imageAlignment = .left //设置按钮图片左对齐
        secondButton.titleAlignment = .left //设置内容在图片左侧
        secondButton.imageTitleSpacing = 20.0  //图片与内容20px
        secondButton.imageSize = CGSize(width: 100.0, height: 100.0) // 图片大小
        secondButton.addTarget(self, action: #selector(clickButtonAction), for: .touchUpInside)
        view.addSubview(secondButton)
        secondButton.snp.makeConstraints { make in
            make.left.equalTo(view.snp.centerX).offset(10.0)
            make.top.equalTo(firstButton)
            make.right.equalTo(-10.0)
            make.height.equalTo(firstButton)
        }
        
        
        // 顶部对齐，图片在顶部，内容在底侧
        let thirdlyButton = ARTAlignmentButton()
        thirdlyButton.backgroundColor = .art_randomColor()
        thirdlyButton.setTitle("顶对齐", for: .normal)
        thirdlyButton.setImage(UIImage(named: "1"), for: .normal)
        thirdlyButton.setTitleColor(.art_randomColor(), for: .normal)
        thirdlyButton.titleLabel?.font = .systemFont(ofSize: 16.0)
        thirdlyButton.imageAlignment = .top //设置按钮图片顶部对齐
        thirdlyButton.titleAlignment = .bottom //设置内容在图片底部
        thirdlyButton.imageTitleSpacing = 30.0  //图片与内容30px
        thirdlyButton.imageSize = CGSize(width: 100.0, height: 100.0) // 图片大小
        thirdlyButton.addTarget(self, action: #selector(clickButtonAction), for: .touchUpInside)
        view.addSubview(thirdlyButton)
        thirdlyButton.snp.makeConstraints { make in
            make.left.right.equalTo(firstButton)
            make.top.equalTo(firstButton.snp.bottom).offset(30.0)
            make.height.equalTo(firstButton)
        }
        
        
        /*
         自有布局：部分示例
         
         对齐方式：左上、左下、右上、右下
         
         可在整个Button范围内随意调整，只是起点不同而已
         
         layoutType: LayoutType = .freeform
         */
        
        // 左上
        let fourthButton = ARTAlignmentButton()
        fourthButton.backgroundColor = .art_randomColor()
        fourthButton.setTitle("左上角", for: .normal)
        fourthButton.setImage(UIImage(named: "2"), for: .normal)
        fourthButton.setTitleColor(.art_randomColor(), for: .normal)
        fourthButton.titleLabel?.font = .systemFont(ofSize: 16.0)
        fourthButton.layoutType = .freeform  // 设置自由布局
        fourthButton.imageAlignment = .topLeft //设置按钮图片左上对齐时，imageEdgeInset与titleEdgeInset的bottom、right无效
        fourthButton.titleEdgeInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 0.0, right: 0.0) // 文本内边距
        fourthButton.imageEdgeInset = UIEdgeInsets(top: 40.0, left: 10.0, bottom: 0.0, right: 0.0) // 图片内边距
        fourthButton.imageSize = CGSize(width: 100.0, height: 100.0) // 图片大小
        fourthButton.addTarget(self, action: #selector(clickButtonAction), for: .touchUpInside)
        view.addSubview(fourthButton)
        fourthButton.snp.makeConstraints { make in
            make.left.right.equalTo(secondButton)
            make.top.equalTo(thirdlyButton)
            make.height.equalTo(firstButton)
        }
        
        // 左下
        let fifthButton = ARTAlignmentButton()
        fifthButton.backgroundColor = .art_randomColor()
        fifthButton.setTitle("左下角对齐", for: .normal)
        fifthButton.setImage(UIImage(named: "4"), for: .normal)
        fifthButton.setTitleColor(.black, for: .normal)
        fifthButton.titleLabel?.font = .systemFont(ofSize: 16.0)
        fifthButton.layoutType = .freeform  // 设置自由布局
        fifthButton.imageAlignment = .bottomLeft //设置按钮图片左上对齐时，imageEdgeInset与titleEdgeInset的top、right无效
        fifthButton.titleEdgeInset = UIEdgeInsets(top: 0.0, left: 35.0, bottom: 70.0, right: 0.0) // 文本内边距
        fifthButton.imageEdgeInset = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 20.0, right: 0.0) // 图片内边距
        fifthButton.imageSize = CGSize(width: 100.0, height: 100.0) // 图片大小
        fifthButton.addTarget(self, action: #selector(clickButtonAction), for: .touchUpInside)
        view.addSubview(fifthButton)
        fifthButton.snp.makeConstraints { make in
            make.left.right.equalTo(thirdlyButton)
            make.top.equalTo(thirdlyButton.snp.bottom).offset(30.0)
            make.height.equalTo(firstButton)
        }
        
        // 左上对齐，右下对齐方式依次类推
        let sixthButton = ARTAlignmentButton()
        sixthButton.backgroundColor = .art_randomColor()
        sixthButton.setTitle("右下角对齐", for: .normal)
        sixthButton.setImage(UIImage(named: "4"), for: .normal)
        sixthButton.setTitleColor(.black, for: .normal)
        sixthButton.titleLabel?.font = .systemFont(ofSize: 16.0)
        sixthButton.layoutType = .freeform  // 设置自由布局
        sixthButton.imageAlignment = .topRight //设置按钮图片左上对齐时，imageEdgeInset与titleEdgeInset的left、bottom无效
        sixthButton.titleEdgeInset = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 0.0, right: 20.0) // 文本内边距
        sixthButton.imageEdgeInset = UIEdgeInsets(top: 30.0, left: 0.0, bottom: 0.0, right: 40.0) // 图片内边距
        sixthButton.imageSize = CGSize(width: 100.0, height: 100.0) // 图片大小
        sixthButton.addTarget(self, action: #selector(clickButtonAction), for: .touchUpInside)
        view.addSubview(sixthButton)
        sixthButton.snp.makeConstraints { make in
            make.left.right.equalTo(fourthButton)
            make.top.equalTo(fourthButton.snp.bottom).offset(30.0)
            make.height.equalTo(firstButton)
        }
    }
    
    @objc func clickButtonAction(sender: UIButton) {
        print("点击了:\(String(describing: sender.titleLabel?.text))")
    }
}
