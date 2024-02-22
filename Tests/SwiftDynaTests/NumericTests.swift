//
//  File.swift
//  
//
//  Created by Aaron Ge on 2024/2/18.
//

import XCTest
@testable import SwiftDyna


final class NumericTests: XCTestCase {
    
    
    
    
    func testDouble() throws{
        let string = "2.70000E-9"
        XCTAssertNotNil(Double(string))
        let value = Double(string)
        print(value)
    }
    
    func testInt() throws{
        let string = "      1003".trimmingCharacters(in: .whitespaces)
        XCTAssertNotNil(Int(string))
        let value = Int(string)
        print(value)
    }
}
