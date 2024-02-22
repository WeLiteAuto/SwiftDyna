//
//  File.swift
//  
//
//  Created by Aaron Ge on 2024/2/18.
//

import Foundation
struct DynamicCodingKeys: CodingKey {
        var stringValue: String
        var intValue: Int? = nil
        
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        init?(intValue: Int) {
            self.stringValue = String(intValue)
            self.intValue = intValue
        }
    }
