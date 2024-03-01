//
//  File.swift
//
//
//  Created by Aaron Ge on 2024/2/18.
//


extension MaterialPropertyValue: Codable {
    enum MaterialPropertyValueCodingError: Error {
        case unknownType
        case decodingCaseFailure(String)
        case encodingCaseFailure(String)
        
        var localizedDescription: String {
            switch self {
            case .unknownType:
                return "Unknown type encountered during decoding: "
            case .decodingCaseFailure(let description):
                return "Failed to decode MaterialPropertyValue: \(description)"
            case .encodingCaseFailure(let description):
                return "Failed to encode MaterialPropertyValue: \(description)"
            }
        }
    }
    
    /// Creates a new instance by decoding from the given decoder.
    ///
    /// This initializer allows for the decoding of `MaterialPropertyValue` from an external representation,
    /// such as JSON, by manually specifying how each case is decoded based on a `type` field.
    /// - Parameter decoder: The decoder to read data from.
    /// - Throws: An error if decoding fails.
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(Double.self){
            
            self = .directValue(value)
        }
        
        else if let value = try? container.decode(Curve2D.self){
            self = .curveID(0, value)
        }
        
        else if let value = try? container.decode(CurveTable.self){
            self = .curveTableID(0, value)
        }
        else{
            throw MaterialPropertyValueCodingError.unknownType
        }
        
    }
    /// Encodes this value into the given encoder.
    ///
    /// This method allows `MaterialPropertyValue` to be encoded to an external representation,
    /// such as JSON, by manually specifying how each case is encoded.
    /// - Parameter encoder: The encoder to write data to.
    /// - Throws: An error if encoding fails.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .directValue(let value):
            try container.encode(value)
        case .curveID(_, let curve):
            try container.encode(curve)
        case .curveTableID(_, let table):
            try container.encode(table)
        }
    }
    
}


