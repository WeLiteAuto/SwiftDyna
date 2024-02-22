//
//  File.swift
//  
//
//  Created by Aaron Ge on 2024/2/18.
//

import Foundation
extension Point2D: Encodable{
    
    public func encode(to encoder: Encoder) throws {
        //            var container = encoder.singleValueContainer()
        //            let formattedString = "\(x): \(y)"
        //            try container.encode(formattedString)
        //        }
        
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        
      
        let key = DynamicCodingKeys(stringValue: "\(x)")!
        // Encode y-value using the x-value as the key
        try container.encode(y, forKey: key)
    }
//    }
}
