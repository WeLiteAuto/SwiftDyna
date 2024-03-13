//
//  File.swift
//
//
//  Created by Aaron Ge on 2024/2/1.
//

import Collections



/// A parser for handling curve and material data from a structured text file.
public class DYNAMaterialFileParser {
    
    public typealias SectionData = [String: [[String]]]
    
    var lcCurves:  OrderedDictionary<Int, Curve2D> = [:]  //[Int: Curve2D]
    var lcCurveTables:  OrderedDictionary<Int, CurveTable> = [:]   //[Int: CurveTable]
    var material: DYNAMaterial?
    var fracture: [String: MaterialPropertyValue]?
    
    
    public func parseFile(path: String) throws -> (any DYNAMaterial)?{
        guard let contents = readFileContents(atPath: path) 
        else {throw fatalError("404. File not found ")}
        
        return try parseContent(contents)
    }
    
    public func parseCurveSections(_ sections: SectionData) throws{
        var curves: [[String]] = []

        if sections.keys.contains(where: {$0 == "*DEFINE_CURVE"}){
            curves.append(contentsOf: sections["*DEFINE_CURVE"]!)
        }
        
        if sections.keys.contains(where: {$0 == "*DEFINE_CURVE_TITLE"}){
            
            curves.append(contentsOf: sections["*DEFINE_CURVE_TITLE"]!)
        }
        
        for curve in curves {
            guard let (key, curve) = parseCurveData(curve) 
            else {throw fatalError("Bad Curve Data")}
            lcCurves[key] = curve
        }
    }
    
    public func parseTableSections(_ sections: SectionData) throws{
        var tables: [[String]] = []
        if sections.keys.contains(where: {$0 == "*DEFINE_TABLE"}){
            tables.append(contentsOf:  sections["*DEFINE_TABLE"]!)
        }
        
        else if sections.keys.contains(where: {$0 == "*DEFINE_TABLE_TITLE"}){
            tables.append(contentsOf:  sections["*DEFINE_TABLE_TITLE"]!)
        }
        
        for table in tables {
            guard let (key, table) = try? parseCurveTableData(table) 
            else {throw fatalError("Bad Curve Table Data")}
            
            lcCurveTables[key] = table
        }
    }
    
    public func parseMaterialSetion(_ sections: SectionData) throws{
        let materialSections = sections.keys.filter {
            $0.hasPrefix("*MAT_")
        }
//        var material: DYNAMaterial?
        for materialSection in materialSections {
            if materialSection.contains("EROSION")
            {
                fracture = try Mat24_Parser.shared.parseGISSMO(lines: sections[materialSection]![0], curves: lcCurves, tables: lcCurveTables)
            }
            else{
                material = parseMaterial(materialSection,
                                         withData: sections[materialSection]![0])
            }
        }
        
        guard material != nil 
        else  {throw fatalError("Parse Material format error")}
        if fracture != nil {
            material!.fracture = fracture
        }

    }
    
    public func parseContent(_ contents: String) throws -> (any DYNAMaterial)?{
        let sections = parseContents2Sections(contents: contents)
        try parseCurveSections(sections)
        try parseTableSections(sections)
        try parseMaterialSetion(sections)
        return material
    }
    
    public func readFileContents(atPath path: String) -> String?{
        do {
            let contents = try String(contentsOfFile: path, encoding: .utf8)
            return contents
        } catch {
            print("Error reading file: \(error)")
            return nil
        }
    }
    
    /// Parses the file and processes its data.
    func parseContents2Sections(contents: String) -> SectionData{
        
        let lines = contents.components(separatedBy: .newlines)
        
        var sectionData: SectionData = [:]
        var currentSection = ""
        var currentSectionData: [String] = []
        
        for line in lines {
            if line.starts(with: "$") {
                continue // Skip comment lines
            }
            
            if line.starts(with: "*") {
                if !currentSection.isEmpty {
                    if sectionData[currentSection] == nil {
                        sectionData[currentSection] = [currentSectionData]
                    } else {
                        sectionData[currentSection]?.append(currentSectionData)
                    }
                    currentSectionData = []
                }
                currentSection = line
            } else if !currentSection.isEmpty && !line.isEmpty{
                currentSectionData.append(line) // Accumulate data for the current section
            }
        }
        
        // Add the last section data
        if !currentSection.isEmpty && !currentSectionData.isEmpty {
            if sectionData[currentSection] == nil {
                sectionData[currentSection] = [currentSectionData]
            } else {
                sectionData[currentSection]?.append(currentSectionData)
            }
        }
        
        return sectionData
    }
    
    
    /// Parses curve data from a given section.
    ///
    /// This function should be implemented to extract curve points
    /// or other relevant information from the data array.
    /// - Parameter data: An array of strings, each representing a line of curve data.
    /// - Returns: An instance of `Curve2D` created from the parsed data.
    func parseCurveData(_ data: [String]) -> (Int, Curve2D)?{
        guard !data.isEmpty else {return nil}
        // Implement parsing logic
        var points: [Point2D] = []
        
        var key = 0
        var SFA = 1.0
        var SFO = 1.0
        var OFFA = 0.0
        var OFFO = 0.0
        
        
        var transfered = false
        
        for line in data {
//            let components = line.split(separator: " ")
            let components = line.components(separatedBy: .whitespaces).filter{!$0.isEmpty}
            if !transfered{
                if components.count > 2{
                    key = Int(components[0]) ?? 0
                    SFA = Double(components[2]) ?? 1
                    SFO = Double(components[3]) ?? 1
                    OFFA = Double(components[4]) ?? 0
                    OFFO = Double(components[5]) ?? 0
                    
                    SFA = SFA == 0.0 ? 1.0 : SFA
                    SFO = SFO == 0.0 ? 1.0 : SFO
                }
                transfered = true
            }
            
            
            if components.count == 2 {
                guard let x = Double(components[0]),
                      let y = Double(components[1])
                else {
                    return nil
                }
                let point = Point2D(x: x, y: y)
                points.append(point)
            }
        }
        
        let truePoints = points.map {
            Point2D(x: $0.x * SFA + OFFA, y: $0.y * SFO + OFFO)
        }
        
        return (key, Curve2D(points: truePoints))
    }
    
    /// Parses a curve table section from the provided lines of text.
    /// - Parameter data: An array of strings representing lines of a curve table section.
    /// - Returns: An instance of `(Int, CurveTable)` containing the parsed data.
    public func parseCurveTableData(_ data: [String])  throws -> (Int, CurveTable)? {
        
        guard  !data.isEmpty else {return nil}
        
        var table = CurveTable()
        
        var tableId = 0
        var SFA = 1.0
        var OFFA = 0.0
        
        for line in data {
            
            
            let components = line.split(separator: " ", omittingEmptySubsequences: true)
            
            if components.count == 1,
               let id = Int(components[0]){
                tableId = id
            }
            
            else if components.count == 3{
                guard let id = Int(components[0]) else {return nil}
                tableId = id
                guard let sf = Double(components[1]) else {return nil }
                SFA = sf
                guard let off = Double(components[2]) else {return nil}
                OFFA = off
            }
            
            else if components.count == 2{
                guard var value = Double(components[0]),
                      let curveID = Int(components[1]) else {return nil}
                value = value * SFA + OFFA
                guard let curve = lcCurves[curveID]
                else {throw fatalError("Bad Curve Table Data")}
                table[value] = curve
            }
        }
        return (tableId, table)
    }
    
    /// Processes the accumulated data for a specific section.
    ///
    /// Based on the section's keyword, this function delegates the processing
    /// of the accumulated data to the appropriate parsing function.
    /// - Parameters:
    ///   - section: The keyword identifying the section.
    ///   - data: An array of strings containing the data for the section.
    func parseMaterial(_ section: String, withData data: [String]) -> (any DYNAMaterial)? {
        let defaultMaterial: ElasticMaterial_001? = nil
        var section = section
        guard section.hasPrefix("*MAT_") 
        else {return defaultMaterial}
        if section.hasSuffix("_TITLE") {
            section = section.dropFirst(5).dropLast(6).uppercased()
        }
        else{
            section = section.dropFirst(5).uppercased()
        }
        //        var currentMaterial: DYNAMaterial?
//        print(section)
        switch section {
        case "PIECEWISE_LINEAR_PLASTICITY":
            let matParser = Mat24_Parser.shared
            var material = matParser.parser(data, curves: lcCurves, tables: lcCurveTables) as! Mat_024
            guard fracture != nil 
            else {return material}
            material.fracture = fracture
            return material
            
        default:
            return defaultMaterial
        }
    }
}
