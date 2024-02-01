import Foundation

/// A structure representing a material with various properties.
///
/// `DynaMaterial` encapsulates properties of a material, such as density and other
/// characteristics, which can be direct values or references to curves or tables.
public struct DynaMaterial {
    /// The unique identifier of the material.
    var id: Int

    /// The density of the material, which can be a direct value.
    var density: Double
    
    /// The optional titie of the material.
    var title: String?

    /// Property of the material, demonstrating the use of `MaterialPropertyValue`.
    var property: MaterialPropertyValue?
    
    var curves: [Curve2D] = []
    var tables: [CurveTable] = []

    /// Generates a textual description of the material and its properties.
    /// - Returns: A `String` representing the material with its properties.
    func description() -> String {
        return "Material ID: \(id), Density: \(density), Other Property: \(property?.description() ?? "No properties")"
    }
}

// Other specific material types...
