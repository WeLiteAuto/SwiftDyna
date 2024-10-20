//
//  File.swift
//  
//
//  Created by Aaron Ge on 2024/2/29.
//

import Foundation


extension CurveTable: Codable {
    private enum CodingKeys: String, CodingKey {
        case curves
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        let encodableCurves = curves.reduce(into: [String: Curve2D]()) { result, pair in
            result[pair.key.description] = pair.curve
        }
        
        try container.encode(encodableCurves, forKey: .curves)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let decodedCurves = try container.decode([String: Curve2D].self, forKey: .curves)
        
        self.curves = decodedCurves.compactMap { key, curve in
            guard let decimalKey = Decimal(string: key) else { return nil }
            return (key: decimalKey, curve: curve)
        }.sorted(by: { $0.key < $1.key })
    }
}

// Custom encoding/decoding for Decimal to ensure precision
extension Decimal: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)
        guard let decimal = Decimal(string: stringValue) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid Decimal value")
        }
        self = decimal
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.description)
    }
}
