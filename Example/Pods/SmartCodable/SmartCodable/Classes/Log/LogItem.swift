//
//  LogItem.swift
//  SmartCodable
//
//  Created by qixin on 2024/4/23.
//

import Foundation


extension LogItem: Equatable {
    static func ==(lhs: LogItem, rhs: LogItem) -> Bool {
        return lhs.fieldName == rhs.fieldName &&
        lhs.logType == rhs.logType &&
        lhs.logDetail == rhs.logDetail &&
        areCodingKeysEqual(lhs.codingPath, rhs.codingPath)
    }
    
    static func areCodingKeysEqual(_ lhs: [CodingKey], _ rhs: [CodingKey]) -> Bool {
        guard lhs.count == rhs.count else { return false }
        return zip(lhs, rhs).allSatisfy {
            
            let key0 = $0.intValue != nil ? "Index X" : $0.stringValue
            let key1 = $1.intValue != nil ? "Index X" : $1.stringValue
            return key0 == key1
        }
    }
}

struct LogItem {
    var level: SmartConfig.DebugMode
    /// 字段名称
    var fieldName: String
    /// 错误类型
    private var logType: String
    /// 错误原因
    private var logDetail: String
    
    private(set) var codingPath: [CodingKey]
    
    
    init(level: SmartConfig.DebugMode, fieldName: String, logType: String, logDetail: String, codingPath: [CodingKey]) {
        self.level = level
        self.fieldName = fieldName
        self.logType = logType
        self.logDetail = logDetail
        self.codingPath = codingPath
    }
    
    
    var formartMessage: String {
         """
         \(fieldName): \(logDetail)\n
         """
    }
}


extension LogItem {
    
    
    static func make(with error: DecodingError) -> LogItem? {
        
        switch error {
        case .keyNotFound(let key, let context):
            // 获取属性对应的Model的路径
            let codingPath = context.codingPath.removeFromEnd(1) ?? []
            return LogItem(level: .debug, fieldName: key.stringValue, logType: "MISSING KEY", logDetail: "No value associated with key.", codingPath: codingPath)
            
        case .valueNotFound( _, let context):
            // 获取属性对应的Model的路径
            let codingPath = context.codingPath.removeFromEnd(1) ?? []
            let key = context.codingPath.last?.stringValue ?? ""
            return LogItem(level: .debug, fieldName: key, logType: "NULL VALUE", logDetail: context.debugDescription, codingPath: codingPath)
            
        case .typeMismatch( _, let context):
            // 获取属性对应的Model的路径
            let codingPath = context.codingPath.removeFromEnd(1) ?? []
            let key = context.codingPath.last?.stringValue ?? ""
            return LogItem(level: .debug, fieldName: key, logType: "TYPE MISMATCH", logDetail: context.debugDescription, codingPath: codingPath)
            
        case .dataCorrupted(let context):
            // 获取属性对应的Model的路径
            let codingPath = context.codingPath.removeFromEnd(1) ?? []
            let key = context.codingPath.last?.stringValue ?? ""
            return LogItem(level: .debug, fieldName: key, logType: "DATA CORRUPTED", logDetail: context.debugDescription, codingPath: codingPath)
        default:
            break
        }
        
        return nil
    }
    
}
