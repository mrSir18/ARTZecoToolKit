//
//  SmartAny.swift
//  SmartCodable
//
//  Created by qixin on 2023/12/1.
//

import Foundation

/// SmartAny represents any type for Codable parsing, which can be simply understood as Any.
///
/// Codable does not support parsing of the Any type. Consequently, corresponding types like dictionary [String: Any], array [Any], and [[String: Any]] cannot be parsed.
/// By wrapping it with SmartAny, it achieves the purpose of enabling parsing for Any types.
///
/// To retrieve the original value, call '.peel' to unwrap it.
public enum SmartAny {
    
    
    
    
    /// In Swift, NSNumber is a composite type that can accommodate various numeric types:
    ///  - All integer types: Int, Int8, Int16, Int32, Int64, UInt, UInt8, UInt16, UInt32, UInt64
    ///  - All floating-point types: Float, Double
    ///  - Boolean type: Bool
    ///
    /// Due to its dynamic nature, it can store different types of numbers and query their specific types at runtime.
    /// This provides a degree of flexibility but also sacrifices the type safety and performance advantages of Swift's native types.
    ///
    /// In the initial implementation, these basic data types were handled separately. For example:
    ///  - case bool(Bool)
    ///  - case double(Double), cgFloat(CGFloat), float(Float)
    ///  - case int(Int), int8(Int8), int16(Int16), int32(Int32), int64(Int64)
    ///  - case uInt(UInt), uInt8(UInt8), uInt16(UInt16), uInt32(UInt32), uInt64(UInt64)
    /// However, during parsing, a situation arises: the data type is forcibly specified, losing the flexibility of NSNumber. For instance, `as? Double` will fail when the data is 5.
    case number(NSNumber)
    case string(String)
    case dict([String: SmartAny])
    case array([SmartAny])
    case null(NSNull)
    
    
    public init(from value: Any) {
        self = .convertToSmartAny(value)
    }
}

extension Dictionary where Key == String {
    /// Converts from [String: Any] type to [String: SmartAny]
    public var cover: [String: SmartAny] {
        mapValues { SmartAny(from: $0) }
    }
    
    /// Unwraps if it exists, otherwise returns itself.
    public var peelIfPresent: [String: Any] {
        if let dict = self as? [String: SmartAny] {
            return dict.peel
        } else {
            return self
        }
    }
}

extension Array {
    public var cover: [ SmartAny] {
        map { SmartAny(from: $0) }
    }
    
    /// Unwraps if it exists, otherwise returns itself.
    public var peelIfPresent: [Any] {
        if let arr = self as? [[String: SmartAny]] {
            return arr.peel
        } else if let arr = self as? [SmartAny] {
            return arr.peel
        } else {
            return self
        }
    }
}


extension Dictionary where Key == String, Value == SmartAny {
    /// The parsed value will be wrapped by SmartAny. Use this property to unwrap it.
    public var peel: [String: Any] {
        mapValues { $0.peel }
    }
}
extension Array where Element == SmartAny {
    /// The parsed value will be wrapped by SmartAny. Use this property to unwrap it.
    public var peel: [Any] {
        map { $0.peel }
    }
}

extension Array where Element == [String: SmartAny] {
    /// The parsed value will be wrapped by SmartAny. Use this property to unwrap it.
    public var peel: [Any] {
        map { $0.peel }
    }
}


extension SmartAny {
    /// The parsed value will be wrapped by SmartAny. Use this property to unwrap it.
    public var peel: Any {
        switch self {
        case .number(let v):  return v
        case .string(let v):  return v
        case .dict(let v):    return v.peel
        case .array(let v):   return v.peel
        case .null:           return NSNull()
        }
    }
}



extension SmartAny: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        guard let decoder = decoder as? _SmartJSONDecoder else {
            throw DecodingError.typeMismatch(SmartAny.self, DecodingError.Context(
                codingPath: decoder.codingPath, debugDescription: "Expected \(Self.self) value，but an exception occurred！Please report this issue（请上报该问题）")
            )
        }
        
        if container.decodeNil() {
            self = .null(NSNull())
        } else if let value = try? decoder.unbox(decoder.storage.topContainer, as: SmartAny.self) {
            self = value
        } else if let value = try? decoder.unbox(decoder.storage.topContainer, as: [String: SmartAny].self) {
            self = .dict(value)
        } else if let value = try? decoder.unbox(decoder.storage.topContainer, as: [SmartAny].self) {
            self = .array(value)
        } else {
            throw DecodingError.typeMismatch(SmartAny.self, DecodingError.Context(
                codingPath: decoder.codingPath, debugDescription: "Expected \(Self.self) value，but an exception occurred！Please report this issue（请上报该问题）")
            )
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .null:
            try container.encodeNil()
        case .string(let value):
            try container.encode(value)
        case .dict(let dictValue):
            try container.encode(dictValue)
        case .array(let arrayValue):
            try container.encode(arrayValue)
        case .number(let value):
            /**
             Swift为了与Objective-C的兼容性，提供了自动桥接功能，允许Swift的数值类型和NSNumber之间的无缝转换。这包括：
             所有的整数类型：Int, Int8, Int16, Int32, Int64, UInt, UInt8, UInt16, UInt32, UInt64
             所有的浮点类型：Float, Double
             布尔类型：Bool
             */
            
            if let bool = value as? Bool {
                try container.encode(bool)
            }  else if let double = value as? Double {
                try container.encode(double)
            } else if let float = value as? Float {
                try container.encode(float)
            } else if let cgfloat = value as? CGFloat {
                try container.encode(cgfloat)
            } else if let int = value as? Int {
                try container.encode(int)
            } else if let int8 = value as? Int8 {
                try container.encode(int8)
            } else if let int16 = value as? Int16 {
                try container.encode(int16)
            } else if let int32 = value as? Int32 {
                try container.encode(int32)
            } else if let int64 = value as? Int64 {
                try container.encode(int64)
            } else if let uInt = value as? UInt {
                try container.encode(uInt)
            } else if let uInt8 = value as? UInt8 {
                try container.encode(uInt8)
            } else if let uInt16 = value as? UInt16 {
                try container.encode(uInt16)
            } else if let uInt32 = value as? UInt32 {
                try container.encode(uInt32)
            } else if let uInt64 = value as? UInt64 {
                try container.encode(uInt64)
            } else {
                throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "NSNumber contains unsupported type"))
            }
        }
    }
}



extension SmartAny {
    private static func convertToSmartAny(_ value: Any) -> SmartAny {
        switch value {
        case let v as NSNumber:      return .number(v)
        case let v as String:        return .string(v)
        case let v as [String: Any]: return .dict(v.mapValues { convertToSmartAny($0) })
        case let v as [Any]:         return .array(v.map { convertToSmartAny($0) })
        case is NSNull:              return .null(NSNull())
        default:                     return .null(NSNull())
        }
    }
}
