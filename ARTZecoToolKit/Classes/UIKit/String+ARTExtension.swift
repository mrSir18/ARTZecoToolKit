//
//  String+ARTExtension.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/6/23.
//

extension String {
    
    /// 将字符串转换为 JSON 对象.
    ///
    /// - Returns:
    ///   如果转换成功，则返回 JSON 对象，否则返回 nil.
    ///   如果 JSON 对象是字典，则返回 `[String: Any]` 类型.
    public func art_decode<T: Decodable>(type: T.Type) -> T? {
        guard let jsonData = self.data(using: .utf8) else { return nil }
        
        do {
            let decoder = JSONDecoder()
            let feed = try decoder.decode(type, from: jsonData)
            return feed
        } catch let error {
            print(error)
            return nil
        }
    }
    
    /// 将 String 数据转换为字典..
    ///
    /// - Returns:
    ///   如果转换成功，则返回字典对象，否则返回 nil.
    public func art_toDictionary() -> [String: Any]? {
        if let jsonData = data(using: .utf8) {
            do {
                // 尝试反序列化JSON数据到字典
                if let dictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                    return dictionary
                }
            } catch {
                return nil
            }
        }
        return nil
    }
    
    /// 将 String 数据转换为数组.
    ///
    /// - Returns:
    ///   如果转换成功，则返回数组对象，否则返回 nil.
    public func art_toArray() -> [[String: Any]]? {
        if let jsonData = data(using: .utf8) {
            do {
                // 尝试反序列化JSON数据到数组
                if let array = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] {
                    return array
                }
            } catch {
                return nil
            }
        }
        return nil
    }
}