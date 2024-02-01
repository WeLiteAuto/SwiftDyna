import XCTest
@testable import SwiftDyna

final class SwiftDynaTests: XCTestCase {
    func testReadFileContents() throws {
        // XCTest Documentation
        // https://developer.apple.com/documentation/xctest
        
        // Defining Test Cases and Test Methods
        // https://developer.apple.com/documentation/xctest/defining_test_cases_and_test_methods
        
        let filePath = "/Users/aaronge/Downloads/demo.txt"
        XCTAssertNotNil(readFileContents(atPath: filePath))
        
        
        let contents = readFileContents(atPath: filePath)!
        print(contents)
    }
    
    func testParseCurves() throws {
        // XCTest Documentation
        // https://developer.apple.com/documentation/xctest
        
        // Defining Test Cases and Test Methods
        // https://developer.apple.com/documentation/xctest/defining_test_cases_and_test_methods
        
        let filePath = "/Users/aaronge/Downloads/demo.txt"
        let contents = readFileContents(atPath: filePath)!
        let sectionDatas = parseContents(contents: contents)
        
        
        var curves: [[String]] = []
        if sectionDatas.keys.contains(where: {$0 == "*DEFINE_CURVE"}){
            curves = sectionDatas["*DEFINE_CURVE"]!
        }
        
        
        else if sectionDatas.keys.contains(where: {$0 == "*DEFINE_CURVE_TITLE"}){
            curves = sectionDatas["*DEFINE_CURVE_TITLE"]!
        }
        
        XCTAssertFalse(curves.isEmpty)
        
        for curve in curves {
            let (key, curve) = parseCurveData(curve)
            print(key, curve)
        }
        
    }
}
