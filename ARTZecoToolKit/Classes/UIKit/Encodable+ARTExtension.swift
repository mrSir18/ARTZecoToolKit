//
//  Encodable+ARTExtension.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/6/23.
//

extension Encodable {
    
    /// 将对象转换为 JSON 对象.
    ///
    /// - Returns:
    ///  如果转换成功，则返回 JSON 对象，否则返回 nil.
    public func art_encode() -> Any? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(self)
            guard let value = String(data: data, encoding: .utf8) else { return nil }
            return value
        } catch {
            print(error)
        }
        return nil
    }
}
