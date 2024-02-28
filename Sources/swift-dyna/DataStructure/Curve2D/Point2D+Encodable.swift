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
            let values = try decoder.container(keyedBy: DynamicCodingKeys.self)
            let keys = values.allKeys
            
            guard let xKey = keys.first, let yKey = keys.last,
                  let xValue = Double(xKey.stringValue), let yValue = Double(yKey.stringValue) else {
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Cannot decode Point2D"))
            }
            
            self.x = xValue
            self.y = yValue
        }
    
    /// Encodes this `Point2D` into a single string value.
    ///
    /// This method encodes the `Point2D` instance into a string representation using the format `"x: y"`, where `x` and `y` are the point's coordinates.
    ///
    /// - Parameter encoder: The encoder to write data to.
    /// - Throws: An error if any values cannot be encoded.
    public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: DynamicCodingKeys.self)
            
            let xKey = DynamicCodingKeys(stringValue: String(x))!
            let yKey = DynamicCodingKeys(stringValue: String(y))!
            
            try container.encode(1000, forKey: xKey)
            try container.encode(1000, forKey: yKey)
        }
}
