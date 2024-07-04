//
//  UIView+ARTExtension.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/7/5.
//

extension UIView {
    
    /// 将视图转换为图片对象.
    ///
    /// - Returns: 生成的图片对象.
    public func asImageAsync(completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0.0)
            defer { UIGraphicsEndImageContext() }
            
            guard let context = UIGraphicsGetCurrentContext() else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            self.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}
