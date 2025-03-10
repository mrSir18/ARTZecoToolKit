//
//  ARTPagView.swift
//  ARTZeco
//
//  Created by mrSir18 on 2024/6/26.
//

class ARTPagView: PAGView {

    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
    }
    
    // MARK: - Public Methods
    
    func playAnimation(_withFileName fileName: String?, repeatCount: Int32 = 1) {
        if let filePath = Bundle.main.path(forResource: fileName, ofType: "pag"),
           let pagFile = PAGFile.load(filePath) {
            setComposition(pagFile)
            setRepeatCount(repeatCount)
        }
    }
}
