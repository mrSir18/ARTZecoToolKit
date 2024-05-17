//
//  SmartSONUnkeyedDecodingContainer+decode.swift
//  SmartCodable
//
//  Created by qixin on 2024/2/28.
//
import Foundation

struct SmartSONUnkeyedDecodingContainer : UnkeyedDecodingContainer {
    // MARK: Properties
    
    /// A reference to the decoder we're reading from.
    let decoder: _SmartJSONDecoder
    
    /// A reference to the container we're reading from.
    let container: [Any]
    
    /// The path of coding keys taken to get to this point in decoding.
    internal(set) public var codingPath: [CodingKey]
    
    /// The index of the element we're about to decode.
    internal(set) public var currentIndex: Int
    
    // MARK: - Initialization
    
    /// Initializes `self` by referencing the given decoder and container.
    init(referencing decoder: _SmartJSONDecoder, wrapping container: [Any]) {
        self.decoder = decoder
        self.container = container
        self.codingPath = decoder.codingPath
        self.currentIndex = 0
    }
    
    // MARK: - UnkeyedDecodingContainer Methods
    
    public var count: Int? {
        return self.container.count
    }
    
    public var isAtEnd: Bool {
        return self.currentIndex >= self.count!
    }
    @inlinable
    public mutating func decodeNil() throws -> Bool {
        guard !self.isAtEnd else {
            throw DecodingError.valueNotFound(
                Any?.self,
                DecodingError.Context(
                    codingPath: self.decoder.codingPath + [SmartCodingKey(index: self.currentIndex)],
                    debugDescription: "Unkeyed container is at end.")
            )
        }
        
        
        /** 为什么是null的时候 需要currentIndex加一？
         如果使用func decode(_ type: Bool.Type)前，都进行decodeNil的判断。 self.container[self.currentIndex]的值如果是null，就不需要decode了。 如果强行decode，就会抛出异常throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.decoder.codingPath + [_JSONKey(index: self.currentIndex)], debugDescription: "Expected \(type) but found null instead."))。
         
         所以在null的时候，应该加一。 维护了currentIndex的准确性。
         */
        if self.container[self.currentIndex] is NSNull {
            self.currentIndex += 1
            return true
        } else {
            return false
        }
    }
    
    @inlinable
    public mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> {
        self.decoder.codingPath.append(SmartCodingKey(index: self.currentIndex))
        defer { self.decoder.codingPath.removeLast() }
        
        guard !self.isAtEnd else {
            throw DecodingError.valueNotFound(KeyedDecodingContainer<NestedKey>.self, DecodingError.Context(codingPath: self.codingPath, debugDescription: "Cannot get nested keyed container -- unkeyed container is at end.")
            )
        }
        
        let value = self.container[self.currentIndex]
        guard !(value is NSNull) else {
            self.currentIndex += 1
            return nestedContainer(wrapping: [:])
        }
        
        guard let dictionary = value as? [String : Any] else {
            self.currentIndex += 1
            return nestedContainer(wrapping: [:])
        }
        
        self.currentIndex += 1
        return nestedContainer(wrapping: dictionary)
    }
    
    private func nestedContainer<NestedKey>(wrapping dictionary: [String: Any] = [:]) -> KeyedDecodingContainer<NestedKey> {
        let container = SmartJSONKeyedDecodingContainer<NestedKey>(referencing: self.decoder, wrapping: dictionary)
        return KeyedDecodingContainer(container)
    }
    @inlinable
    public mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        self.decoder.codingPath.append(SmartCodingKey(index: self.currentIndex))
        defer { self.decoder.codingPath.removeLast() }
        
        guard !self.isAtEnd else {
            throw DecodingError.valueNotFound(
                UnkeyedDecodingContainer.self,
                DecodingError.Context(codingPath: self.codingPath,
                                      debugDescription: "Cannot get nested keyed container -- unkeyed container is at end."))
        }
        
        let value = self.container[self.currentIndex]
        guard !(value is NSNull) else {
            self.currentIndex += 1
            return SmartSONUnkeyedDecodingContainer(referencing: self.decoder, wrapping: [])
        }
        
        guard let array = value as? [Any] else {
            self.currentIndex += 1
            return SmartSONUnkeyedDecodingContainer(referencing: self.decoder, wrapping: [])
        }
        
        self.currentIndex += 1
        return SmartSONUnkeyedDecodingContainer(referencing: self.decoder, wrapping: array)
    }
    @inlinable
    public mutating func superDecoder() throws -> Decoder {
        self.decoder.codingPath.append(SmartCodingKey(index: self.currentIndex))
        defer { self.decoder.codingPath.removeLast() }
        
        guard !self.isAtEnd else {
            throw DecodingError.valueNotFound(Decoder.self, DecodingError.Context(
                codingPath: self.codingPath, debugDescription: "Cannot get superDecoder() -- unkeyed container is at end."))
        }
        
        let value = self.container[self.currentIndex]
        self.currentIndex += 1
        return _SmartJSONDecoder(referencing: value, at: self.decoder.codingPath, options: self.decoder.options)
    }
}
