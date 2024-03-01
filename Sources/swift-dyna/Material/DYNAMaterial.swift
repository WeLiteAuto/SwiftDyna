import Foundation
import Collections

/// A structure representing a material with various properties.
///
/// `DynaMaterial` encapsulates properties of a material, such as density and other
/// characteristics, which can be direct values or references to curves or tables.
public protocol DYNAMaterial {
    /// The unique identifier of the material.
    var id: Int {get set}
    
    /// The type of the material
    var type: String { get set }

    /// The density of the material, which can be a direct value.
//    var density: Double { get set }
    
    /// The optional titie of the material.
    var title: String? {get set}

    /// Basic properties of the material, demonstrating the use of `Double`.
    var basic: [String: Double] { get set }
    
    /// Specific properties of the material, demonstrating the use of `MaterialPropertyValue`.
//    var properties: OrderedDictionary<String, MaterialPropertyValue> { get set }
    
//    var curves: OrderedDictionary<Int, Curve2D> { get set }
//    var tables: OrderedDictionary<Int, CurveTable> { get set }

    /// Generates a textual description of the material and its properties.
    /// - Returns: A `String` representing the material with its properties.
    func description() -> String 

}

// Other specific material types...
