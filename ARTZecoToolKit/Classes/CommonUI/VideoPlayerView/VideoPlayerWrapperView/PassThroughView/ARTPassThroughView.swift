//
//  ARTPassThroughView.swift
//  Pods
//
//  Created by mrSir18 on 2024/10/21.
//

open class ARTPassThroughView: UIView {
    
    // MARK: - Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Touch Handling
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? { // 透传事件
        let hitView = super.hitTest(point, with: event)
        return (hitView === self) ? nil : hitView
    }
}
