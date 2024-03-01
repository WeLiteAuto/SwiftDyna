//
//  File.swift
//  
//
//  Created by Aaron Ge on 2024/3/1.
//

import Foundation

class Mat24Writer: MaterialWriter{
    func write(material: DYNAMaterial, id: Int, type: MaterialCardType) throws -> [String] {
        let material = material as! PiecewiseLinearPlasticityMaterial_024
        
        var lines = ["KEYWORD", "MAT_PIECEWISE_LINEAR_PLASTICITY"]
        var matId = 0
        switch type {
        case .structure:
             matId = 610000 + id
        case .crashworthness:
            matId = 620000 + id
        }
        

        guard let youngs  = material.basic["Youngs"],
              let poison = material.basic["Poison"]
        else{
            throw fatalError()
        }
        
//        switch basi
        
        let firstLine = String(format: "%10d%10f%10f%10f%10f%10f%10f%10f%",
                               matId, material.density, youngs,  poison, 0, 0, 1.0e21, 0)
        let secondLine = String(format: "%10f%10f%10d%10f%10f%10f%10f%10f%", 0,0,matId,0,0,0,0,0)
        let thirdLine =  String(format: "%10f%10f%10f%10f%10f%10f%10f%10f%", 0,0,0,0,0,0,0,0)
        let forthLine =  String(format: "%10f%10f%10f%10f%10f%10f%10f%10f%", 0,0,0,0,0,0,0,0)
        
        var curves : [String]
        switch type{
        case .structure
            let curves
        case .crashworthness:
            <#code#>
        }
    }
    
    
    
    
    
}
