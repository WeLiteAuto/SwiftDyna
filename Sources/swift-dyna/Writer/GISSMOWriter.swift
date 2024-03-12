//
//  File.swift
//  
//
//  Created by Aaron Ge on 2024/3/6.
//

import Foundation
class GISSMOWrite : MaterialWriter {
    func writeTonMmS(material: any DYNAMaterial, id: Int, type: MaterialCardType) throws -> [String] {
        guard let fracture = material.fracture
        else {throw fatalError()}
        var numfip: Double = switch fracture["numfip"]{
        case .none:
            1
        case .directValue(let value):
            value
        default:
            throw fatalError()
        }
        
        let firstLine = String(format: "%10d%10f%10.4f%10f%10f%10f%10.3e%10f",
                               id, 0, 0,  0, 0, 0, numfip, 0)
        let secondLine = String(format: "%10f%10f%10f%10f%10f%10f%10f%10f", 0,0,0,0,0,0,0,0)
        
        let lcsdg: MaterialPropertyValue = switch fracture["lcsdg"]{
        case .curveTableID(_, let table):
                .curveTableID(id+200, table)
        case .curveID(_, let curve):
                .curveID(id+200, curve)
        default:
            throw fatalError()
            
        }
        let sdgString = switch lcsdg{
        case .directValue(_):
            throw fatalError()
        case .curveID(let id, _):
            String(format: "%10d", id)
        case .curveTableID(let id, _):
            String(format: "%10d", id)
        }
        
        let lcecrit: MaterialPropertyValue = switch fracture["ecrit"]{
        case .directValue(let value):
                .directValue(value)
        case .curveID(_, let curve):
                .curveID(id+250, curve)
        default:
            throw fatalError()
        }
        
        let ecritString = switch lcecrit{
        case .curveID(let id, _):
            String(format: "%10d", -id)
        case .directValue(let value):
            String(format: "%10.3f", value)
        default:
            String(format: "%10.3f", 0)
            
        }
    
        
        let dmgexp: Double = switch fracture["dmgexp"]{
        case .directValue(let value):
            value
        default:
            1.0
        }
        
        
        let fadexp: Double = switch fracture["fadexp"]{
        case .directValue(let value):
            value
        default:
            1.0
        }
        
        let lcregd: MaterialPropertyValue = switch fracture["lcregd"]{
        case .curveID(_, let curve):
                .curveID(id+260, curve)
        default:
                .directValue(0)
            
        }
        
        let regdString = switch lcregd{
        case .curveID(let id, _):
            String(format: "%10d", id)
        case .directValue(let value):
            String(format: "%10.4f", value)
        default:
            String(format: "%10.4f", 0)
        }
        
        
        
        let thirdLine = String(format: "%10d%10.1f",
                               1, 1)
        + sdgString
        + ecritString
        + String(format: "%10.4f%10.4f%10.4f",
                 dmgexp, 0, fadexp)
        + regdString
        
        let nahsv: Int = switch fracture["nahsv"]{
        case .directValue(let value):
            Int(value)
        default:
            0
        }
        
        let lcsrs: MaterialPropertyValue = switch fracture["lcsrs"]{
        case .curveID(_, let curve):
                .curveID(id+270, curve)
        default:
                .directValue(0)
        }
        
        let srsString = switch lcsrs{
        case .curveID(let id, _):
            if type == .crashworthness{
                String(format: "%10d", id)
            }
            else {
                String(format: "%10d", 0)
            }
        default:
            String(format: "%10f", 0)
        }
        
        let shrf: Double = switch fracture["shrf"]{
        case .directValue(let value):
            value
        default:
            0
        }
        let biaxf: Double = switch fracture["biaxf"]{
        case .directValue(let value):
            value
        default:
            0
        }
        
        let forthLine =  String(format: "%10f%10f%10d", 0,0,nahsv)
        + srsString
        + String(format: "%10.4f%10.4f", shrf,biaxf)
        
        var lines = ["*MAT_ADD_EROSION",firstLine, secondLine, thirdLine, forthLine]
        
        switch lcsdg {
        case .curveID(let id, let curve):
            let sdg = Self.writeCurve(id: id, curve: curve, sfa: 1.0)
            lines.append(contentsOf: sdg)
        case .curveTableID(let id, let table):
            let sdg = switch table.keys.count{
            case 1:
                Self.writeCurve(id: id, curve: table[table.keys.first!]!)
            default:
                Self.writeCurveTable(id: id, table: table)
            }
            
            lines.append(contentsOf: sdg)
        case .directValue(_): break
        }
        
        switch lcecrit{
        case .curveID(let id, let curve):
            let ecrit = Self.writeCurve(id: id, curve: curve)
            lines.append(contentsOf: ecrit)
        default:
            break
        }
        
        switch lcregd{
        case .curveID(let id, let curve):
            let regd = Self.writeCurve(id: id, curve: curve)
            lines.append(contentsOf: regd)
        default:
            break
        }
        
        switch lcsrs{
        case .curveID(let id, let curve):
            let srs = Self.writeCurve(id: id, curve: curve)
            lines.append(contentsOf: srs)
        default:
            break
        }
        
        return lines
        
    }
    
    func writeKgMmMs(material: any DYNAMaterial, id: Int, type: MaterialCardType) throws -> [String] {
        guard let fracture = material.fracture
        else {throw fatalError()}
        var numfip: Double = switch fracture["numfip"]{
        case .none:
            1
        case .directValue(let value):
            value
        default:
            throw fatalError()
        }
        
        let firstLine = String(format: "%10d%10f%10.4f%10f%10f%10f%10.3e%10f",
                               id, 0, 0,  0, 0, 0, numfip, 0)
        let secondLine = String(format: "%10f%10f%10f%10f%10f%10f%10f%10f", 0,0,0,0,0,0,0,0)
        
        let lcsdg: MaterialPropertyValue = switch fracture["lcsdg"]{
        case .curveTableID(_, let table):
                .curveTableID(id+200, table)
        case .curveID(_, let curve):
                .curveID(id+200, curve)
        default:
            throw fatalError()
            
        }
        let sdgString = switch lcsdg{
        case .directValue(_):
            throw fatalError()
        case .curveID(let id, _):
            String(format: "%10d", id)
        case .curveTableID(let id, _):
            String(format: "%10d", id)
        }
        
        let lcecrit: MaterialPropertyValue = switch fracture["ecrit"]{
        case .directValue(let value):
                .directValue(value)
        case .curveID(_, let curve):
                .curveID(id+250, curve)
        default:
            throw fatalError()
        }
        
        let ecritString = switch lcecrit{
        case .curveID(let id, _):
            String(format: "%10d", -id)
        case .directValue(let value):
            String(format: "%10.3f", value)
        default:
            String(format: "%10.3f", 0)
            
        }
    
        
        let dmgexp: Double = switch fracture["dmgexp"]{
        case .directValue(let value):
            value
        default:
            1.0
        }
        
        
        let fadexp: Double = switch fracture["fadexp"]{
        case .directValue(let value):
            value
        default:
            1.0
        }
        
        let lcregd: MaterialPropertyValue = switch fracture["lcregd"]{
        case .curveID(_, let curve):
                .curveID(id+260, curve)
        default:
                .directValue(0)
            
        }
        
        let regdString = switch lcregd{
        case .curveID(let id, _):
            String(format: "%10d", id)
        case .directValue(let value):
            String(format: "%10.4f", value)
        default:
            String(format: "%10.4f", 0)
        }
        
        
        
        let thirdLine = String(format: "%10d%10.1f",
                               1, 1)
        + sdgString
        + ecritString
        + String(format: "%10.4f%10.4f%10.4f",
                 dmgexp, 0, fadexp)
        + regdString
        
        let nahsv: Int = switch fracture["nahsv"]{
        case .directValue(let value):
            Int(value)
        default:
            0
        }
        
        let lcsrs: MaterialPropertyValue = switch fracture["lcsrs"]{
        case .curveID(_, let curve):
                .curveID(id+270, curve)
        default:
                .directValue(0)
        }
        
        let srsString = switch lcsrs{
        case .curveID(let id, _):
            if type == .crashworthness{
                String(format: "%10d", id)
            }
            else {
                String(format: "%10d", 0)
            }
        default:
            String(format: "%10f", 0)
        }
        
        let shrf: Double = switch fracture["shrf"]{
        case .directValue(let value):
            value
        default:
            0
        }
        let biaxf: Double = switch fracture["biaxf"]{
        case .directValue(let value):
            value
        default:
            0
        }
        
        let forthLine =  String(format: "%10f%10f%10d", 0,0,nahsv)
        + srsString
        + String(format: "%10.4f%10.4f", shrf,biaxf)
        
        var lines = ["*MAT_ADD_EROSION",firstLine, secondLine, thirdLine, forthLine]
        
        switch lcsdg {
        case .curveID(let id, let curve):
            let sdg = Self.writeCurve(id: id, curve: curve)
            lines.append(contentsOf: sdg)
        case .curveTableID(let id, let table):
            let sdg = switch table.keys.count{
            case 1:
                Self.writeCurve(id: id, curve: table[table.keys.first!]!)
            default:
                Self.writeCurveTable(id: id, table: table)
            }
            
            lines.append(contentsOf: sdg)
        case .directValue(_): break
        }
        
        switch lcecrit{
        case .curveID(let id, let curve):
            let ecrit = Self.writeCurve(id: id, curve: curve)
            lines.append(contentsOf: ecrit)
        default:
            break
        }
        
        switch lcregd{
        case .curveID(let id, let curve):
            let regd = Self.writeCurve(id: id, curve: curve)
            lines.append(contentsOf: regd)
        default:
            break
        }
        
        switch lcsrs{
        case .curveID(let id, let curve):
            let srs = Self.writeCurve(id: id, curve: curve, sfa: 0.001)
            lines.append(contentsOf: srs)
        default:
            break
        }
        
        return lines
    }
    
    public func write(material: any DYNAMaterial, id: Int, type: MaterialCardType) throws -> [String] {
        let ton = try writeTonMmS(material: material, id: id, type: type)
        let kg = try writeKgMmMs(material: material, id: id+100_000, type: type)
        
        var lines = [String]()
        lines.append(contentsOf: ton)
        lines.append(contentsOf: kg)
        
        return lines
        
        
        
    }
}
