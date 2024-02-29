//
//  File.swift
//  
//
//  Created by Aaron Ge on 2024/2/29.
//

import Foundation


extension CurveTable: Codable {
    // Custom error for handling encoding and decoding errors specifically related to `CurveTable`.
    enum CodingError: Error {
        case encodingError(String)
    }
    
    /// Creates a new instance by decoding from the given decoder.
    ///
    /// This initializer decodes a dictionary from the provided decoder, where each key is a string that represents a double value,
    /// and each value is a `Curve2D` structure. It then converts the string keys back to `Double` types for internal storage.
    ///
    /// - Parameter decoder: The decoder to read data from.
    /// - Throws: An error if reading from the decoder fails, or if the encountered stored value cannot be decoded.
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let curvesDictionary = try container.decode([String: Curve2D].self)
        
        curves = try curvesDictionary.reduce(into: [:]) { accumulator, pair in
            guard let key = Double(pair.key) else {
                // If the string key cannot be converted back to Double, throw an error.
                throw CodingError.encodingError("Key '\(pair.key)' is not a valid Double")
            }
            accumulator[key] = pair.value
        }
    }
    
    /// Encodes this instance into the given encoder.
    ///
    /// This method encodes the `curves` dictionary into a format where each key is a string representing its double value,
    /// preserving the numeric identification of each curve in a string format suitable for JSON encoding.
    ///
    /// - Parameter encoder: The encoder to write data to.
    /// - Throws: An error if any values cannot be encoded.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        // Convert the Double keys to String for encoding.
        let stringDictionary = curves.reduce(into: [:]) { accumulator, pair in
            accumulator[String(pair.key)] = pair.value
        }
        
        try container.encode(stringDictionary)
    }
}
