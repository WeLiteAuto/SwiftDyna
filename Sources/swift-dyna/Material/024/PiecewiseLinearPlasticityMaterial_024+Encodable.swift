//
//  File.swift
//  
//
//  Created by Aaron Ge on 2024/2/18.
//

import Foundation

extension Mat_024: Encodable {
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
