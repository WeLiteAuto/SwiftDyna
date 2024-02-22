//
//  File.swift
//
//
//  Created by Aaron Ge on 2024/2/18.
//

import Foundation
extension Curve2D: Encodable{
    // Custom encode function for Curve2D
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        
        for point in points
        {
            // Convert x-value to a DynamicCodingKey
            let key = DynamicCodingKeys(stringValue: "\(point.x)")!
            // Encode y-value using the x-value as the key
            try container.encode(point.y, forKey: key)
        }
    }
    
    
}
