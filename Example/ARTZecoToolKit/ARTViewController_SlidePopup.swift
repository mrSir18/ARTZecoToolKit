//
//  ARTViewController_SlidePopup.swift
//  ARTZecoToolKit_Example
//
//  Created by mrSir18 on 2024/5/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import ARTZecoToolKit

class ARTViewController_SlidePopup: ARTBaseViewController {
    
    /// 按钮
    private lazy var slidePopupButton: ARTAlignmentButton = {
        let button = ARTAlignmentButton(type: .custom)
        button.titleLabel?.font = .art_regular(16.0)
        button.backgroundColor  = .art_randomColor()
        button.setTitle("这是滑动弹窗", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(slidePopupButtonAction), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(slidePopupButton)
        slidePopupButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 150.0, height: 150.0))
            make.center.equalToSuperview()
        }
    }
    
    @objc private func slidePopupButtonAction () {
        /*
         设置滑动弹窗样式
         
         ARTSlidePopupStyleConfiguration.default()
             .containerHeight(300)
             .cornerRadius(60)
             .containerBackgroundColor(.red)
         */
        
        /// 创建滑动弹窗
        let slidePopupView = ARTChildSlidePopupView(self)
        slidePopupView.showSlidePopupView()
    }
}

extension ARTViewController_SlidePopup: ARTChildSlidePopupViewProtocol {
    
    func didPerformSomeAction(_ view: ARTChildSlidePopupView) {
        view.hideSlidePopupView()
        print("点击了按钮")
    }
}












// MARK: - Child 自定义样式

protocol ARTChildSlidePopupViewProtocol: AnyObject {
    func didPerformSomeAction(_ view: ARTChildSlidePopupView)
}

class ARTChildSlidePopupView: ARTSlidePopupView {

    /// 代理对象
    weak var delegate: ARTChildSlidePopupViewProtocol?
    
    // 继承自ARTSlidePopupView，使用示例
    public convenience init(_ delegate: ARTChildSlidePopupViewProtocol?) {
        self.init(frame: .zero)
        self.delegate = delegate
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {

        let button = ARTAlignmentButton(type: .system)
        button.backgroundColor = .art_randomColor()
        button.setTitle("Perform Action", for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        addViewToContainer(button)
        button.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 150.0, height: 50.0))
            make.top.equalTo(configuration.headerHeight + 30.0) //获取header高度
            make.centerX.equalToSuperview()
        }
        
        /*
         支持自定义头部视图 - 移除原始头部视图
         
         removeHeaderView()
         */
    }
    
    @objc private func buttonTapped() {
        delegate?.didPerformSomeAction(self)
    }
    
    // MARK: - 重写父类代理方法
    
    override func didTapPackUpButton(_ headerView: ARTSlidePopupHeaderView) {
        super.didTapPackUpButton(headerView)
        print("子类重写：点击了收起按钮")
    }
    
    override func titleName(with headerView: ARTSlidePopupHeaderView) -> String {
        return "子类重写：标题名称"
    }
}
