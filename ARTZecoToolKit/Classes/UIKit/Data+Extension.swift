//
//  Data+Extension.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/6/23.
//

extension Data {

    /// 将数据转换为字符串.
    ///
    /// - Returns:
    ///    如果转换成功，则返回字符串对象，否则返回 nil
    public func art_toString() -> String? {
        return String(data: self, encoding: .utf8)
    }
    
    /// 将 JSON 数据转换为字典.
    ///
    /// - Returns:
    ///    如果转换成功，则返回字典对象，否则返回 nil.
    public func art_toDictionary() -> Dictionary<String, Any>? {
        do {
            if let dictionary = try JSONSerialization.jsonObject(with: self, options: []) as? [String: Any] {
                return dictionary
            }
        } catch {
            return nil
        }
        return nil
    }
    
    /// 将 JSON 数据转换为数组.
    ///
    /// - Returns:
    ///    如果转换成功，则返回数组对象，否则返回 nil.
    public func art_toArray() -> Array<Any>? {
        do {
            if let array = try JSONSerialization.jsonObject(with: self, options: []) as? [Any] {
                return array
            }
        } catch {
            return nil
        }
        return nil
    }
}
