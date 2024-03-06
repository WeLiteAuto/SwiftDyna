//
//  File.swift
//
//
//  Created by Aaron Ge on 2024/2/21.
//

import Foundation
import Collections


public extension MaterialParser {
    func parseGISSMO(lines: [String],
                     curves:  OrderedDictionary<Int, Curve2D>,
                     tables:  OrderedDictionary<Int, CurveTable>) throws -> [String: MaterialPropertyValue]? {
        guard !lines.isEmpty else{throw fatalError("Parse GISSMO error")}
        var lines = lines
        var erosion = [String: MaterialPropertyValue]()
        
        if splitByWhitespace(lines[0]).count == 1 {
            _ = lines.removeFirst()
        }
        
        let line0 = splitDataEvery10Characters(lines[0])
        erosion["numfip"] = .directValue(Double(line0[6].trimmingCharacters(in: .whitespaces)) ?? 1.0)
        
        let line2 = splitDataEvery10Characters(lines[2])
        
        guard let lcsdg = Int(line2[2].trimmingCharacters(in: .whitespaces))
        else {throw fatalError("Parser errosion error")}
        if curves.keys.contains(lcsdg){
            let table = CurveTable([0.001: curves[lcsdg]!])
            erosion["lcsdg"] = .curveTableID(lcsdg, table)
        }
        else if tables.keys.contains(lcsdg){
            erosion["lcsdg"] = .curveTableID(lcsdg, tables[lcsdg]!)
        }
        else{throw fatalError("Parse GISSMO error")}
        
        guard let ecrit = Double(line2[3].trimmingCharacters(in: .whitespaces)),
              ecrit.isInteger
        else {throw fatalError("Parser errosion error")}
        if curves.keys.contains(Int(-ecrit)){
            erosion["ecrit"] = .curveID(Int(-ecrit), curves[Int(-ecrit)]!)
        }
        else {
            erosion["ecrit"] = .directValue(0)
        }
        
        guard let dmgexp = Double(line2[4].trimmingCharacters(in: .whitespaces))
        else {throw fatalError("Parser errosion error")}
        erosion["dmgexp"] = .directValue(dmgexp)
        
        guard let dcrit = Double(line2[5].trimmingCharacters(in: .whitespaces))
        else {throw fatalError("Parser errosion error")}
        switch erosion["ecrit"] {
        case .directValue(_):
            erosion["dcrit"] = .directValue(dcrit)
        default:
            erosion["dcrit"] = .directValue(0)
        }
        
        guard let fadexp = Double(line2[6].trimmingCharacters(in: .whitespaces))
        else {throw fatalError("Parser errosion error")}
        erosion["fadexp"] = .directValue(fadexp)
        
        guard let lcregd = Double(line2[7].trimmingCharacters(in: .whitespaces)),
              lcregd.isInteger
        else {throw fatalError("Parser errosion error")}
        if curves.keys.contains(Int(lcregd))
        {
            erosion["lcregd"] = .curveID(Int(lcregd), curves[Int(lcregd)]!)
        }
        else{
            erosion["lcregd"] = .directValue(0)
        }
        
        
        let line3 = splitDataEvery10Characters(lines[3])
        
        guard let nahsv = Double(line3[2].trimmingCharacters(in: .whitespaces))
        else {throw fatalError("Parser errosion error")}
        erosion["nahsv"] = .directValue(nahsv)
        
        guard let lcsrs = Double(line3[3].trimmingCharacters(in: .whitespaces)),
              lcsrs.isInteger
        else {throw fatalError("Parser errosion error")}
        if curves.keys.contains(Int(lcsrs))
        {
            erosion["lcsrs"] = .curveID(Int(lcsrs), curves[Int(lcsrs)]!)
        }
        else{
            erosion["lcsrs"] = .directValue(0)
        }
        
        guard let shrf = Double(line3[4].trimmingCharacters(in: .whitespaces))
        else {throw fatalError("Parser errosion error")}
        erosion["shrf"] = .directValue(shrf)
        guard let biaxf = Double(line3[5].trimmingCharacters(in: .whitespaces))
        else {throw fatalError("Parser errosion error")}
        erosion["biaxf"] = .directValue(biaxf)
        return erosion
        
    }
}


