//
//  File.swift
//  
//
//  Created by Aaron Ge on 2024/3/1.
//

import Foundation

class Mat24Writer: MaterialWriter{
    
    
    func write(material: SwiftDyna.DYNAMaterial) -> [String] {
        let material = material as! PiecewiseLinearPlasticityMaterial_024
        
        
        switch material.hardenCurves{
        case .curveTableID(_, let table):
            return Self.writeCurveTable(table: table, id: 6000)
        case .directValue(let value):
            return ["\(value)"]
        case .curveID(_, let curve):
            return Self.writeCurve(curve: curve, sfa: 1, id: 1)
        }
        
    }
    
    
}
