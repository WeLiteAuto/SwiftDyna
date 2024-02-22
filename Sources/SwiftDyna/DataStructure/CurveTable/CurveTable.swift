//
//  File.swift
//
//
//  Created by Aaron Ge on 2024/2/18.
//

//import Collections
import Foundation

public typealias CurveTable = KVFormatedOrderedDictionary<Double, Curve2D>


//public struct CurveTable : Encodable{
//    var curves: OrderedDictionary<Double, Curve2D>
//    init(curves: OrderedDictionary<Double, Curve2D> = [:]) {
//        self.curves = curves
//    }
//    
//    // Computed property to access the keys
//    var keys: OrderedSet<Double> {
//        return curves.keys
//    }
//    
//    // Computed property to access the values
//    var values: OrderedDictionary<Double, Curve2D>.Values {
//        return curves.values
//    }
//    
//    
//    subscript(key: Double) -> Curve2D? {
//        get {
//            return curves[key]
//        }
//        set {
//            curves[key] = newValue
//        }
//    }
//    
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
//        
//        for (key, curve) in curves {
//            // Convert the outer dictionary's key to a string for JSON encoding
//            let keyString = "\(key)"
//            let curveKey = DynamicCodingKeys(stringValue: keyString)!
//            
//            var nestedContainer = container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: curveKey)
//            for point in curve {
//                // Each point in the curveData is encoded with its x value as the key
//                let xKey = DynamicCodingKeys(stringValue: "\(point.x)")!
//                try nestedContainer.encode(point.y, forKey: xKey)
//            }
//        }
//    }
//}
//

