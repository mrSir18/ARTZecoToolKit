
import Foundation

class JSONEncoderImpl {
    let options: SmartJSONEncoder._Options
    let codingPath: [CodingKey]
    var userInfo: [CodingUserInfoKey: Any] {
        options.userInfo
    }
    
    /// 记录当前keyed容器的各个属性的初始化值， 不支持Unkey容器的记录。
    var cache: EncodingCache

    var singleValue: JSONValue?
    var array: JSONFuture.RefArray?
    var object: JSONFuture.RefObject?

    var value: JSONValue? {
        if let object = self.object {
            return .object(object.values)
        }
        if let array = self.array {
            return .array(array.values)
        }
        return self.singleValue
    }

    init(options: SmartJSONEncoder._Options, codingPath: [CodingKey]) {
        self.options = options
        self.codingPath = codingPath
        self.cache = EncodingCache()

    }
}

extension JSONEncoderImpl: Encoder {
    func container<Key>(keyedBy _: Key.Type) -> KeyedEncodingContainer<Key> where Key: CodingKey {
        if let _ = object {
            let container = JSONKeyedEncodingContainer<Key>(impl: self, codingPath: codingPath)
            return KeyedEncodingContainer(container)
        }

        guard self.singleValue == nil, self.array == nil else {
            preconditionFailure()
        }

        self.object = JSONFuture.RefObject()
        let container = JSONKeyedEncodingContainer<Key>(impl: self, codingPath: codingPath)
        return KeyedEncodingContainer(container)
    }

    func unkeyedContainer() -> UnkeyedEncodingContainer {
        if let _ = array {
            return JSONUnkeyedEncodingContainer(impl: self, codingPath: self.codingPath)
        }

        guard self.singleValue == nil, self.object == nil else {
            preconditionFailure()
        }

        self.array = JSONFuture.RefArray()
        return JSONUnkeyedEncodingContainer(impl: self, codingPath: self.codingPath)
    }

    func singleValueContainer() -> SingleValueEncodingContainer {
        guard self.object == nil, self.array == nil else {
            preconditionFailure()
        }

        return JSONSingleValueEncodingContainer(impl: self, codingPath: self.codingPath)
    }
}

// this is a private protocol to implement convenience methods directly on the EncodingContainers

extension JSONEncoderImpl: _SpecialTreatmentEncoder {
    var impl: JSONEncoderImpl {
        return self
    }

    // untyped escape hatch. needed for `wrapObject`
    func wrapUntyped(_ encodable: Encodable) throws -> JSONValue {
        switch encodable {
        case let date as Date:
            return try self.wrapDate(date, for: nil)
        case let data as Data:
            return try self.wrapData(data, for: nil)
        case let url as URL:
            return .string(url.absoluteString)
        case let decimal as Decimal:
            return .number(decimal.description)
        case let object as [String: Encodable]: // this emits a warning, but it works perfectly
            return try self.wrapObject(object, for: nil)
        default:
            try encodable.encode(to: self)
            return self.value ?? .object([:])
        }
    }
}

