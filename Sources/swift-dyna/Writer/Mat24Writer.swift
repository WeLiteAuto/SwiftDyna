//
//  File.swift
//  
//
//  Created by Aaron Ge on 2024/3/1.
//

import Foundation

class Mat24Writer: MaterialWriter{
    
    func writeTonMmS(material: any DYNAMaterial, id: Int, type: MaterialCardType) throws -> [String] {
        let material = material as! Mat_024
        
        var lines = ["*MAT_PIECEWISE_LINEAR_PLASTICITY"]
       
    
        
        

        guard let youngs  = material.basic["1.Youngs"],
              let poison = material.basic["2.Poison"]
        else{
            throw fatalError()
        }
        
        
        let firstLine = String(format: "%10d%10.3e%10.4f%10f%10f%10f%10.3e%10f",
                               id, material.density, youngs,  poison, 0, 0, 1.0e21, 0)
        let secondLine = String(format: "%10f%10f%10d%10f%10f%10f%10f%10f", 0,0,id,0,0,0,0,0)
        let thirdLine =  String(format: "%10f%10f%10f%10f%10f%10f%10f%10f", 0,0,0,0,0,0,0,0)
        let forthLine =  String(format: "%10f%10f%10f%10f%10f%10f%10f%10f", 0,0,0,0,0,0,0,0)
        
        var curves = CurveTable()
        switch material.hardenCurves{
        case .directValue(_):
            throw(fatalError())
        case .curveID(_, _):
            throw(fatalError())
        case .curveTableID(_, let table):
            curves = table
        }
        
        lines.append(contentsOf: [firstLine, secondLine, thirdLine, forthLine])
        
        var curvesString: [String]
        switch type{
        case .structure:
//            let curves = material.hardenCurves as!
            guard let lowestKey = curves.keys.min() else {throw(fatalError())}
            let lowest = curves[lowestKey]!
            curvesString = Self.writeCurve(id: id, curve: lowest, sfa: 1)
        case .crashworthness:
            curvesString = Self.writeCurveTable(id: id, table: curves)
        }
        
        lines.append(contentsOf: curvesString)
        
        return lines
    }
    
    func writeKgMmMs(material: any DYNAMaterial, id: Int, type: MaterialCardType) throws -> [String] {
        let material = material as! Mat_024
        
        var lines = ["*MAT_PIECEWISE_LINEAR_PLASTICITY"]
       
        
        
        
        guard let youngs  = material.basic["1.Youngs"],
              let poison = material.basic["2.Poison"]
        else{
            throw fatalError()
        }
        
        
        let firstLine = String(format: "%10d%10.3e%10.4f%10f%10f%10f%10.3e%10f",
                               id, material.density*1_000, youngs/1_000,  poison, 0, 0, 1.0e21, 0)
        let secondLine = String(format: "%10f%10f%10d%10f%10f%10f%10f%10f", 0,0,id,0,0,0,0,0)
        let thirdLine =  String(format: "%10f%10f%10f%10f%10f%10f%10f%10f", 0,0,0,0,0,0,0,0)
        let forthLine =  String(format: "%10f%10f%10f%10f%10f%10f%10f%10f", 0,0,0,0,0,0,0,0)
        
        var curves = CurveTable()
        switch material.hardenCurves{
        case .directValue(_):
            throw(fatalError())
        case .curveID(_, _):
            throw(fatalError())
        case .curveTableID(_, let table):
            curves = table
        }
        
        lines.append(contentsOf: [firstLine, secondLine, thirdLine, forthLine])
        
        var curvesString: [String]
        switch type{
        case .structure:
            guard let lowestKey = curves.keys.min() else {throw(fatalError())}
            let lowest = curves[lowestKey]!
            curvesString = Self.writeCurve(id: id, curve: lowest, sfa: 1, sfo: 0.001)
        case .crashworthness:
            curvesString = Self.writeCurveTable(id: id, table: curves, sfa: 0.001, sfo: 0.001)
        }
        
        lines.append(contentsOf: curvesString)
        return lines
    }
    
    func write(material: DYNAMaterial, id: Int, type: MaterialCardType = .structure) throws -> [String] {
        let material = material as! Mat_024
        
        var lines = ["*KEYWORD"]
        
        
        var matId = 0
        switch type {
        case .structure:
             matId = 620000 + id
        case .crashworthness:
            matId = 610000 + id
        }
        
        
        let ton = try writeTonMmS(material: material, id: matId, type: type)
        let kg = try writeKgMmMs(material: material, id: matId+100_000, type: type)
        
        lines.append(contentsOf: ton)
        lines.append(contentsOf: kg)
        
        guard let _ = material.fracture else {
            lines.append("*END")
            return lines
        }
        
        let gissmoWriter = GISSMOWrite()
        let gissmo = try gissmoWriter.write(material: material, id: matId, type: type)
        
        lines.append(contentsOf: gissmo)
        lines.append("*END")
        return lines
    }
    
    
    
    
    
}
