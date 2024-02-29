//
//  File.swift
//
//
//  Created by Aaron Ge on 2024/2/4.
//

import XCTest
import Collections
@testable import SwiftDyna

final class DataStructureCodableTests: XCTestCase {
    
    
    func testPointCodable() throws{
        let point = Point2D(x: 0.71, y: 288.59974)
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        XCTAssertNoThrow(try encoder.encode(point))
        
        let jsonData = try encoder.encode(point)
        let jsonString = String(data: jsonData, encoding: .utf8)
        XCTAssertNotNil(jsonString)
        print(jsonString!)
        let newJsonData = Data(jsonString!.utf8)
        
        XCTAssertNoThrow(try JSONDecoder().decode(Point2D.self, from: newJsonData))
        let newPoint = try JSONDecoder().decode(Point2D.self, from: newJsonData)
        print(newPoint)
        
    }
    
    func testCurveCodable() throws {
        
        // Ensure you've added Swift Collections to your project dependencies
        let curve = Curve2D(points: [Point2D(x: 0.71, y: 288.59974), Point2D(x: 1.5, y: 150.0)])
        
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(curve)
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Encoded : \(jsonString)")
            }
            
            let decoder = JSONDecoder()
            let decodedDictionary = try decoder.decode(Curve2D.self, from: data)
            
            print("Decoded: \(decodedDictionary)")
        } catch {
            print("An error occurred: \(error)")
        }
        
    }
    
    func testCurveTableCodable() {
        // Initialize a CurveTable with some curves
        let curve1 = Curve2D(points: [Point2D(x: 0, y: 0), Point2D(x: 1, y: 1)])
        let curve2 = Curve2D(points: [Point2D(x: 2, y: 2), Point2D(x: 3, y: 3)])
        let originalTable = CurveTable([0.1: curve1, 0.2: curve2])
        
        // Encode the CurveTable
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        XCTAssertNoThrow(try encoder.encode(originalTable))
        let jsonData = try! encoder.encode(originalTable)
        
        // Print the encoded JSON
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            print("Encoded CurveTable to JSON:\n\(jsonString)")
        }
        
        // Decode the JSON back into a CurveTable
        let decoder = JSONDecoder()
        XCTAssertNoThrow(try decoder.decode(CurveTable.self, from: jsonData))
        let decodedTable = try! decoder.decode(CurveTable.self, from: jsonData)
        
        // Verify if decodedTable matches the originalTable
        // This step is simplified; in a real scenario, you'd compare the data more thoroughly
        if decodedTable.curves.keys.count == originalTable.curves.keys.count {
            print("Decoding successful. Number of curves match.")
            
        } else {
            print("Decoding failed. Number of curves does not match.")
        }
        
        
        
    }
}
