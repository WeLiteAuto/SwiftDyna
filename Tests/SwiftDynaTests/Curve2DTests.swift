//
//  File.swift
//
//
//  Created by Aaron Ge on 2024/2/4.
//

import XCTest
import Collections
@testable import SwiftDyna

final class Curve2DTests: XCTestCase {
    
    
    let path = "/Users/aaronge/Downloads/demo.txt"
    
    var parser: DYNAMaterialFileParser? = nil
    var sections: [String: [[String]]] = [:]
    
    override func setUpWithError() throws {
        
        parser = DYNAMaterialFileParser()
        let contents = parser!.readFileContents(atPath: path)
        sections = parser!.parseContents2Sections(contents: contents!)
    }
    
    
    
    func testDifferential() throws{
        
        var curves: [[String]] = []
//        var tables: [[String]] = []
        if sections.keys.contains(where: {$0 == "*DEFINE_CURVE"}){
            curves.append(contentsOf: sections["*DEFINE_CURVE"]!)
        }
        
        if sections.keys.contains(where: {$0 == "*DEFINE_CURVE_TITLE"}){
            curves.append(contentsOf: sections["*DEFINE_CURVE_TITLE"]!)
        }
        
        var lcCurves : OrderedDictionary<Int, Curve2D> = [:]
        
        for curve in curves {
            XCTAssertNotNil(parser!.parseCurveData(curve))
            let (key, curve) = parser!.parseCurveData(curve)!
            lcCurves[key] = curve
        }
        
        let curve0 = lcCurves.values[0]
        let dev = curve0.derivative()
        
        XCTAssertNotNil(curve0.firstIntersection(with: dev))

    }
    
    func testPointCoding() throws{
        let point = Point2D(x: 210, y: 1000)
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        XCTAssertNoThrow(try encoder.encode(point))
        
        let jsonData = try encoder.encode(point)
        let jsonString = String(data: jsonData, encoding: .utf8)
        XCTAssertNotNil(jsonString)
        let newJsonData = Data(jsonString!.utf8)

        XCTAssertNoThrow(try JSONDecoder().decode(Point2D.self, from: newJsonData))
        let newPoint = try JSONDecoder().decode(Point2D.self, from: newJsonData)
        print(newPoint)

    }
    
    func testCurveEncoding() throws {
        let curve = Curve2D(points: [Point2D(x: 0.0, y: 1000), Point2D(x: 0.1, y: 1100), Point2D(x: 0.3, y: 1200)])
       

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        do {
            let jsonData = try encoder.encode(curve)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
            }
        } catch {
            print("Error encoding CurveTable: \(error)")
        }
        
    }
    
    func testCurveTableEncoding() throws {
        let curve1 = Curve2D(points: [Point2D(x: 0.0, y: 1000), Point2D(x: 0.1, y: 1100), Point2D(x: 0.3, y: 1200)])
        let curve2 = Curve2D(points: [Point2D(x: 0.0, y: 1100), Point2D(x: 0.1, y: 1200), Point2D(x: 0.2, y: 1300)])
        let curveTable: CurveTable = [0.1: curve1, 1.0: curve2]

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        do {
            let jsonData = try encoder.encode(curveTable)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
            }
        } catch {
            print("Error encoding CurveTable: \(error)")
        }
        
    }
}
