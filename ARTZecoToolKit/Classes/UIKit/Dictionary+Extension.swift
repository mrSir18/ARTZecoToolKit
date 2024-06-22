//
//  Dictionary+Extension.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/6/23.
//

extension Dictionary {
    
    /// 将字典转换为 JSON 对象.
    ///
    /// - Returns:
    ///  如果转换成功，则返回 JSON 对象，否则返回 nil.
    public func art_decode<T: Decodable>(type: T.Type) -> T? {
        do {
            guard let jsonStr = art_toJSONString() else { return nil }
            guard let jsonData = jsonStr.data(using: .utf8) else { return nil }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .deferredToDate
            let obj = try decoder.decode(type, from: jsonData)
            return obj
        } catch let error {
            print(error)
            return nil
        }
    }
    
    /// 将字典转换为 JSON 字符串.
    ///
    /// - Returns:
    ///  如果转换成功，则返回 JSON 字符串，否则返回 nil.
    private func art_toJSONString() -> String? {
        if (!JSONSerialization.isValidJSONObject(self)) {
            print("无法解析出JSONString")
            return nil
        }
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: [])
            let json = String(data: data, encoding: String.Encoding.utf8)
            return json
        } catch {
            return nil
        }
    }
}
