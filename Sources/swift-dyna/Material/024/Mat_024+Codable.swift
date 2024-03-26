//
//  File.swift
//
//
//  Created by Aaron Ge on 2024/2/18.
//

import Foundation

extension Mat_024: Codable {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
//        if let iid = try? container.decode(Int.self, forKey: .id) {
//            id = iid
//        }
//        else {id = 192}
        id = 0
        type = try container.decodeIfPresent(String.self, forKey: .type) ?? "steel"
        density = try container.decode(Double.self, forKey: .density)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        basic = try container.decode([String: Double].self, forKey: .basic)
        guard let table = try? container.decode(CurveTable.self, forKey: .hardenCurves)
        else {
            throw fatalError()
        }
        hardenCurves = .curveTableID(0, table)
//        guard let fractureTable = try? container.decodeIfPresent(.self, forKey: .fracture)
//        else {
//            throw fatalError()
//        }
        fracture = try container.decodeIfPresent([String: MaterialPropertyValue].self, forKey: .fracture)
    }
    
    enum CodingKeys: String, CodingKey {
        case type, density, title, basic, hardenCurves, fracture
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        // Encode simple properties
        //        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encode(density, forKey: .density)
        try container.encode(title, forKey: .title)
        try container.encode(basic, forKey: .basic)
        try container.encode(hardenCurves, forKey: .hardenCurves)
        if  fracture != nil{
            try container.encode(fracture, forKey: .fracture)
        }
        
    }
    
    
    
}
