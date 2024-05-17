//
//  DateTransformer.swift
//  SmartCodable
//
//  Created by qixin on 2024/4/9.
//

import Foundation



/// Timestamp Date （timeIntervalSince1970）
public struct SmartDateTransformer: ValueTransformable {
    public typealias JSON = Double
    public typealias Object = Date
        
    public init() {}

    
    public func transformFromJSON(_ value: Any?) -> Date? {
        if let timeInt = value as? Double {
            return Date(timeIntervalSince1970: TimeInterval(timeInt))
        }

        if let timeStr = value as? String {
            return Date(timeIntervalSince1970: TimeInterval(atof(timeStr)))
        }

        return nil
    }
    
    public func transformToJSON(_ value: Date?) -> Double? {
        if let date = value {
            return Double(date.timeIntervalSince1970)
        }
        return nil
    }

}


/// DateFormat Date
public struct SmartDateFormatTransformer: ValueTransformable {
    public typealias JSON = String
    public typealias Object = Date
    
    let dateFormatter: DateFormatter

    public init(_ dateFormatter: DateFormatter) {
        self.dateFormatter = dateFormatter
    }

    public func transformFromJSON(_ value: Any?) -> Date? {
        if let dateString = value as? String {
            return dateFormatter.date(from: dateString)
        }
        return nil
    }

    public func transformToJSON(_ value: Date?) -> String? {
        if let date = value {
            return dateFormatter.string(from: date)
        }
        return nil
    }
}
