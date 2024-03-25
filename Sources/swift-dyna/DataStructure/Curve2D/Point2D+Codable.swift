//
//  File.swift
//
//
//  Created by Aaron Ge on 2024/2/18.
//

import Foundation

extension Point2D: Codable{
    /// Initializes a new `Point2D` instance by decoding from a single string value.
    ///
    /// This initializer decodes a `Point2D` instance from a string representation that is expected to be in the format `"x: y"`, where `x` and `y` are the point's coordinates.
    ///
    /// - Parameter decoder: The decoder to read data from.
    /// - Throws: `DecodingError.dataCorruptedError` if the string is not in the expected format or if the coordinates cannot be converted to `Double`.
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let dictionary = try container.decode([String: Double].self)
        guard let firstKey = dictionary.keys.first, let xValue = Double(firstKey), let yValue = dictionary[firstKey] else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode Point2D")
        }
        
        
//        let y = Double(String(format:"%.7f", yValue))
//        let formattedValue = Double(String(format: "%.7f", yValue))!
        self.init(x: xValue, y: yValue)
    }
    
    /// Encodes this `Point2D` into a single string value.
    ///
    /// This method encodes the `Point2D` instance into a string representation using the format `"x: y"`, where `x` and `y` are the point's coordinates.
    ///
    /// - Parameter encoder: The encoder to write data to.
    /// - Throws: An error if any values cannot be encoded.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
//        encoder.
//        encoder.
        try container.encode([String(x): Decimal(y)])
    }
}
