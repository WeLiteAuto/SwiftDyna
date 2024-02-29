//
//  Curve2DTests.swift
//  
//
//  Created by Aaron Ge on 2024/2/29.
//

import XCTest
import Collections
@testable import SwiftDyna

final class Curve2DTests: XCTestCase {
    
    let path = "/Users/aaronge/Downloads/demo.txt"

    var parser: DYNAMaterialFileParser? = nil
    var sections: [String: [[String]]] = [:]
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        parser = DYNAMaterialFileParser()
        let contents = parser!.readFileContents(atPath: path)
        sections = parser!.parseContents2Sections(contents: contents!)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
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

}
