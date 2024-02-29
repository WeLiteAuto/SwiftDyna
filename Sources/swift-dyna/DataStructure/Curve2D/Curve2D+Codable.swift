//
//  File.swift
//
//
//  Created by Aaron Ge on 2024/2/18.
//

import Foundation
extension Curve2D: Codable {
    enum CodingError: Error {
        case encodingError
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let pointsDictionary = try container.decode([String: Double].self)
        
        let tempPoints = pointsDictionary.compactMap { key, value -> Point2D? in
            guard let xValue = Double(key) else { return nil }
            return Point2D(x: xValue, y: value)
        }
        
        self.points = tempPoints.sorted(by: { $0.x < $1.x })
    }
    
    
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        let pointsDictionary = points
            .sorted(by: {
            $0.x > $1.x
        }) 
            .reduce(into: [String: Double]()) { (dict, point) in
            // Convert `x` to a String to use it as a JSON key
            dict[String(point.x)] = point.y
        }
        
        try container.encode(pointsDictionary)
    }
}
