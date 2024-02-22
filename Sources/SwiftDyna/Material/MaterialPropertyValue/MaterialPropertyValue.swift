//
//  File.swift
//  
//
//  Created by Aaron Ge on 2024/1/30.
//

import Foundation

/// An enumeration to represent the different types of material property values.
///
/// `MaterialPropertyValue` can hold a direct double value, a reference to a curve ID,
/// or a reference to a curve table ID, accommodating various ways material properties
/// might be defined.
public enum MaterialPropertyValue {
    /// Represents a direct numerical value.
    /// - Parameter value: A `Double` value of the material property.
    case directValue(Double)

    /// Represents an identifier for a curve.
    /// - Parameter id: An `Int` representing the ID of the curve.
    case curveID(Int, Curve2D)

    /// Represents an identifier for a curve table.
    /// - Parameter id: An `Int` representing the ID of the curve table.
    case curveTableID(Int, CurveTable)

    /// Provides a textual description of the material property value.
    /// - Returns: A `String` description of the value.
    func description() -> String {
        switch self {
        case .directValue(let value):
            return "Value: \(value)"
        case .curveID(let id, _):
            return "Curve ID: \(id)"
        case .curveTableID(let id, _):
            return "Curve Table ID: \(id)"
        }
    }
}
