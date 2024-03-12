import XCTest
@testable import SwiftDyna

final class Mat24Tests: XCTestCase {
    let path = "/Users/aaronge/Downloads/mat.key"
    
    var parser: DYNAMaterialFileParser? = nil
    var contents: String? = nil
    var sections: [String: [[String]]] = [:]
    
    override func setUpWithError() throws {
        parser = DYNAMaterialFileParser()
        
        contents = parser!.readFileContents(atPath: path)
        sections = parser!.parseContents2Sections(contents: contents!)
    }
    
    
    func testReadFileContents() throws {
        let parser =  DYNAMaterialFileParser()
        XCTAssertNoThrow(try parser.parseContent(contents!))
    }
    
    func testParseCurves() throws{
        XCTAssertNoThrow(try parser!.parseCurveSections(sections))
    }
    
    func testParseCurveTables() throws {
        
        XCTAssertNoThrow(try parser!.parseCurveSections(sections))
        XCTAssertNoThrow(try parser!.parseTableSections(sections))
    }
    
    func testParseMaterial_024() throws{
        try parser!.parseCurveSections(sections)
        try parser!.parseTableSections(sections)
        XCTAssertNoThrow(try parser!.parseMaterialSetion(sections))
        XCTAssertNotNil(parser!.material)
    }
    
    
    func testParseMaterial_024Encoding() throws{
        try parser!.parseCurveSections(sections)
        try parser!.parseTableSections(sections)
        try parser!.parseMaterialSetion(sections)
        
//        parser!.material
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        do {
            let jsonData = try encoder.encode(parser!.material as! Mat_024)
            let fileURL = FileManager.default.homeDirectoryForCurrentUser
                .appendingPathComponent("Downloads")
                .appendingPathComponent("mat24.json")

            do {
                try jsonData.write(to: fileURL, options: .atomicWrite)
                print("File saved to \(fileURL)")
            } catch {
                print("Error writing JSON data to file: \(error)")
            }

        } catch {
            print("Error encoding CurveTable: \(error)")
        }
    }
    
    func testDecodeGISSMO() throws{
        let path = "gissmo.json"
        let documentDirectory = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!
        let fileURL = documentDirectory.appendingPathComponent(path)
//        print(fileURL)
        
        XCTAssertNoThrow(try Data(contentsOf: fileURL))
        let data = try Data(contentsOf: fileURL)
        let decoder = JSONDecoder()
        
        XCTAssertNoThrow(try decoder.decode([String: MaterialPropertyValue].self, from: data))
        let gissmo = try decoder.decode([String: MaterialPropertyValue].self, from: data)
        print(gissmo)
    }
}

