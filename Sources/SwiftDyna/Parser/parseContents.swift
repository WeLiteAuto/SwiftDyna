//
//  File.swift
//
//
//  Created by Aaron Ge on 2024/1/31.
//

import Foundation
import Collections

typealias SectionData = [String: [[String]]]
/// Parses the contents of a file structured in sections marked by specific keywords.
///
/// This function reads through each line of the file content, identifies the section
/// based on keywords starting with "*", accumulates data for each section,
/// and processes the data using designated parsing functions.
/// - Parameter contents: The entire content of the file as a String.
/// - Returns: A dictionary where each key is a section type and the value is an array
///            of instances of that section, each instance being an array of strings.
func parseContents(contents: String) -> SectionData{
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

/// Processes the accumulated data for a specific section.
///
/// Based on the section's keyword, this function delegates the processing
/// of the accumulated data to the appropriate parsing function.
/// - Parameters:
///   - section: The keyword identifying the section.
///   - data: An array of strings containing the data for the section.
func processSection(_ section: String, withData data: [String]) {
    
    var curves: [Int: Curve2D] = [: ]
    switch section {
    case "*MAT_PIECEWISE_LINEAR_PLASTICITY_TITLE":
        parseMaterialData(data)
    case "*DEFINE_CURVE":
        let (key, curve) = parseCurveData(data)
        curves[key] = curve
        
    default:
        break
    }
    print(curves)
}

/// Parses material data from a given section.
///
/// This function should be implemented to extract material properties
/// from each line of the data array.
/// - Parameter data: An array of strings, each representing a line of material data.
func parseMaterialData(_ data: [String]) {
    // Implement parsing logic
}

/// Parses curve data from a given section.
///
/// This function should be implemented to extract curve points
/// or other relevant information from the data array.
/// - Parameter data: An array of strings, each representing a line of curve data.
/// - Returns: An instance of `Curve2D` created from the parsed data.
func parseCurveData(_ data: [String]) -> (Int, Curve2D){
    // Implement parsing logic
    var points: [Point2D] = []
    
    var key = 0
    var SFA = 1.0
    var SFO = 1.0
    var OFFA = 0.0
    var OFFO = 0.0
    
    var title: String?
    var transfered = false
    
    for line in data {
        let components = line.split(separator: " ")
        if !transfered{
            if components.count == 8{
                key = Int(components[0]) ?? 0
                SFA = Double(components[2]) ?? 1
                SFO = Double(components[3]) ?? 1
                OFFA = Double(components[4]) ?? 0
                OFFO = Double(components[5]) ?? 0
            }
            transfered = true
        }
        
        if components.count == 1{
            title = components[0].base
        }
        if components.count == 2 {
            let point = Point2D(x: Double(components[0]) ?? 0, y: Double(components[1]) ?? 0)
            points.append(point)
        }
    }
    
    let truePoints = points.map {
        Point2D(x: $0.x * SFA + OFFA, y: $0.y * SFO + OFFO)
    }
    
    return (key, Curve2D(points: truePoints)
    )
}
