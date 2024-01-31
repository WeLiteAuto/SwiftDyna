//
//  File.swift
//  
//
//  Created by Aaron Ge on 2024/1/30.
//

import Foundation

public func parseMaterialProperty(value: String, curves: [Int], tables: [Int]) -> MaterialPropertyValue {
    guard let doubleValue = Double(value) else {
        return .directValue(0)
    }
    
    if doubleValue >= 0{
        return .directValue(doubleValue)
    }
    
    else{
        let curveID = Int(doubleValue)
        if curves.contains(curveID)
        {
            return .curveID(curveID)
        }
        
        else if tables.contains(curveID){
            return .curveTableID(curveID)
        }
        
        else {
            return .directValue(0)
        }
    }
}
