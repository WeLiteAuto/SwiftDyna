//
//  WriterTest.swift
//  
//
//  Created by Aaron Ge on 2024/3/1.
//

import XCTest
@testable import SwiftDyna

class TempWriter: MaterialWriter{
    
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

final class WriterTest: XCTestCase {
    
    let path = "/Users/aaronge/Downloads/demo.txt"
    var parser: DYNAMaterialFileParser? = nil
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        parser = DYNAMaterialFileParser()
        let contents = parser!.readFileContents(atPath: path)
        let sections = parser!.parseContents2Sections(contents: contents!)
        
        try parser!.parseCurveSections(sections)
        try parser!.parseTableSections(sections)
        try parser!.parseMaterialSetion(sections)
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWrite() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        
//        let material = parser!.material
        let writer = TempWriter()
        let result = writer.write(material: parser!.material! )
        
        let combinedString = result.joined(separator: "\n")

        // Get the path to the Documents directory
        guard let documentsDirectory = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first else {
            fatalError("Documents directory not found")
        }

        // Specify the file name and path
        let fileName = "MyFile.txt"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)

        // Write the combined string to the file
        do {
            try combinedString.write(to: fileURL, atomically: true, encoding: .utf8)
            print("File saved: \(fileURL)")
        } catch {
            print("Failed to save file: \(error)")
        }
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
