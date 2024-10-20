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
    private var curves: [(key: Decimal, curve: Curve2D)]
    
    /// Initializes a new `CurveTable` with a given dictionary of curves.
    ///
    /// - Parameter curves: A dictionary where each key is a double value representing the curve's identifier,
    ///                     and the value is a `Curve2D` instance representing the curve itself.
    init(_ curves: [Decimal: Curve2D] = [:]) {
        self.curves = curves.map { (key: $0.key, curve: $0.value) }.sorted(by: { $0.key < $1.key })
    }
    
    /// A collection of all keys in the `curves` dictionary.
    /// This property provides access to the identifiers (keys) of all curves stored in the table.
    /// - Returns: An array of `Decimal` representing the unique identifiers for each curve in the table.
    public var keys: [Decimal] {
        curves.map { $0.key }
    }
    
    /// Accesses the `Curve2D` instance associated with the given key.
    ///
    /// If you read from this subscript by providing a key, it will return the `Curve2D` instance if it exists,
    /// or `nil` if the key is not found in the dictionary.
    /// When you assign a `Curve2D` instance to this subscript, it updates the dictionary with the given key and curve.
    ///
    /// - Parameter key: The decimal value that uniquely identifies a curve in the table.
    public subscript(key: Decimal) -> Curve2D? {
        get {
            curves.first(where: { $0.key == key })?.curve
        }
        set {
            if let index = curves.firstIndex(where: { $0.key == key }) {
                if let newValue = newValue {
                    curves[index] = (key: key, curve: newValue)
                } else {
                    curves.remove(at: index)
                }
            } else if let newValue = newValue {
                let insertIndex = curves.firstIndex(where: { $0.key > key }) ?? curves.endIndex
                curves.insert((key: key, curve: newValue), at: insertIndex)
            }
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
        let curveDesp = curves.map { key in "\(key)" }.joined(separator: ", ")
        return "Table with curves: [\(curveDesp)]"
    }
    
    public mutating func addCurve(_ curve: Curve2D, forKey key: Decimal) {
        self[key] = curve
    }
    
    public func interpolatedCurve(at key: Decimal) -> Curve2D? {
        guard !curves.isEmpty else { return nil }
        
        if let exactMatch = self[key] {
            return exactMatch
        }
        
        guard let upperIndex = curves.firstIndex(where: { $0.key > key }) else {
            return curves.last?.curve
        }
        
        guard upperIndex > 0 else {
            return curves.first?.curve
        }
        
        let lowerIndex = upperIndex - 1
        let lowerKey = curves[lowerIndex].key
        let upperKey = curves[upperIndex].key
        
        let t = (key - lowerKey) / (upperKey - lowerKey)
        let lowerCurve = curves[lowerIndex].curve
        let upperCurve = curves[upperIndex].curve
        
        return interpolateCurves(lowerCurve, upperCurve, t: t)
    }
    
    private func interpolateCurves(_ curve1: Curve2D, _ curve2: Curve2D, t: Decimal) -> Curve2D {
        let allX = Set(curve1.map { $0.x } + curve2.map { $0.x })
        let interpolatedPoints = allX.map { x -> (x: Decimal, y: Decimal) in
            let y1 = curve1.interpolatedValue(at: x) ?? 0
            let y2 = curve2.interpolatedValue(at: x) ?? 0
            let y = y1 + t * (y2 - y1)
            return (x: x, y: y)
        }
        return Curve2D(points: interpolatedPoints)
    }
}

extension CurveTable: Sequence {
    public func makeIterator() -> IndexingIterator<[(key: Decimal, curve: Curve2D)]> {
        return curves.makeIterator()
    }
}

extension CurveTable: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let curvesDictionary = Dictionary(uniqueKeysWithValues: curves.map { (String($0.key), $0.curve) })
        try container.encode(curvesDictionary)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let curvesDictionary = try container.decode([String: Curve2D].self)
        self.curves = curvesDictionary.compactMap { key, value in
            guard let decimalKey = Decimal(string: key) else { return nil }
            return (key: decimalKey, curve: value)
        }.sorted(by: { $0.key < $1.key })
    }
}
