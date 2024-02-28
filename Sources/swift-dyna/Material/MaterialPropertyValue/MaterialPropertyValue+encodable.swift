//
//  File.swift
//  
//
//  Created by Aaron Ge on 2024/2/18.
//


extension MaterialPropertyValue: Encodable {
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
