//
//  File.swift
//
//
//  Created by Aaron Ge on 2024/2/18.
//

import Foundation
import Collections

/// A structure representing a table of 2D curves, where each curve is associated with a unique double value.
public struct CurveTable {
    /// A dictionary mapping double values to `Curve2D` instances.
    /// Each key-value pair represents a curve identified by a double value.
    var curves: OrderedDictionary<Double, Curve2D> = [:]
    
    /// Initializes a new `CurveTable` with a given dictionary of curves.
    ///
    /// - Parameter curves: A dictionary where each key is a double value representing the curve's identifier,
    ///                     and the value is a `Curve2D` instance representing the curve itself.
    init(_ curves: [Double: Curve2D] = [:]) {
        self.curves = curves.keys.sorted().reduce(into: [:], { 
            $0[$1] = curves[$1]
        })
    }
    
    /// A collection of all keys in the `curves` dictionary.
    /// This property provides access to the identifiers (keys) of all curves stored in the table.
    /// - Returns: An array of `Double` representing the unique identifiers for each curve in the table.
    var keys: [Double] {
        return Array(curves.keys)
    }
    
    /// Accesses the `Curve2D` instance associated with the given key.
    ///
    /// If you read from this subscript by providing a key, it will return the `Curve2D` instance if it exists,
    /// or `nil` if the key is not found in the dictionary.
    /// When you assign a `Curve2D` instance to this subscript, it updates the dictionary with the given key and curve.
    ///
    /// - Parameter key: The double value that uniquely identifies a curve in the table.
    subscript(key: Double) -> Curve2D? {
        get {
            return curves[key]
        }
        set {
            curves[key] = newValue
        }
    }
    
    /// Generates a textual description of the curve table and its points.
    /// This method provides a detailed representation of the curve table, including
    /// the identifiers of each curve.
    ///
    /// - Returns: A `String` representing the detailed description of the curve table.
    ///            The format is "Table with curves: [key1, key2, ...]" where key1, key2, ...
    ///            are the identifiers of the curves in the table.
    func description() -> String {
        let curveDesp = curves.keys.map { key in "\(key)" }.joined(separator: ", ")
        return "Table with curves: [\(curveDesp)]"
    }
}

