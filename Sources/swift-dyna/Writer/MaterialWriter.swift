//
//  File.swift
//
//
//  Created by Aaron Ge on 2024/3/1.
//

import Foundation

/// A protocol defining methods for writing material data structures to a string representation.
///
/// This protocol is designed to facilitate the conversion of various material-related data structures,
/// such as points, curves, and curve tables, into arrays of strings or single string representations
/// suitable for serialization, logging, or exporting to text formats.
public protocol MaterialWriter {
    /// Writes the properties of a `DYNAMaterial` to an array of strings.
    ///
    /// - Parameter material: The `DYNAMaterial` instance to be written.
    /// - Returns: An array of strings representing the serialized form of the material.
    func write(material: DYNAMaterial) -> [String]
    
    /// Writes a `Point2D` structure to a string in a predefined format.
    ///
    /// - Parameter point: The `Point2D` instance to be written.
    /// - Returns: A string representing the `Point2D`, formatted according to the implementation.
    static func writePoint(point: Point2D) -> String
    
    /// Writes the properties of a `Curve2D` along with scale factor and identifier to an array of strings.
    ///
    /// - Parameters:
    ///   - curve: The `Curve2D` instance to be written.
    ///   - sfa: A `Double` representing the scale factor applied to the curve data.
    ///   - id: An `Int` serving as an identifier for the curve.
    /// - Returns: An array of strings representing the serialized form of the curve.
    static func writeCurve(curve: Curve2D, sfa: Double, id: Int) -> [String]
    
    /// Writes a `CurveTable` structure to an array of strings.
    ///
    /// - Parameter
    ///   - table: The `CurveTable` instance to be written.
    ///   - id: An `Int`  serving as an identifier for the tableCurves
    /// - Returns: An array of strings representing the serialized form of the curve table.
    static func writeCurveTable(table: CurveTable, id: Int) -> [String]
}

extension MaterialWriter {
    /// Default implementation of writing a `Point2D` structure to a string.
    ///
    /// This method formats the `x` and `y` coordinates of the point with a fixed floating-point notation,
    /// ensuring 7 decimal places and aligning the output into a 20-character wide column for each coordinate.
    ///
    /// - Parameter point: The `Point2D` instance to be written.
    /// - Returns: A string representation of the point, adhering to the specified format.
    static func writePoint(point: Point2D) -> String {
        return String(format: "%20.7f%20.7f", point.x, point.y)
    }
    
    /// Writes the representation of a `Curve2D` object into a formatted string array,
    /// including curve metadata and points in a specific layout.
    ///
    /// This method formats the entire curve, starting with a header line containing
    /// the curve's identifier (`id`), scale factor (`sfa`), and other predefined values.
    /// Each subsequent line represents a point on the curve, formatted according to
    /// the `writePoint` method's output. Points are indented for visual structure.
    ///
    /// The header line is formatted as follows:
    /// - The first value is the curve's identifier (`id`), right-aligned within a 10-character width.
    /// - The second value is always 0, following the `id`, aligned similarly.
    /// - The third value is the scale factor (`sfa`), formatted to one decimal place and right-aligned.
    /// - Following values are fixed (1.0, 0.0, 0.0), each right-aligned within 10-character widths,
    ///   and a final 0, aligning with the pattern established by the initial values.
    ///
    /// Each point from the curve is then formatted on its own line, with:
    /// - The `x` value in floating-point or scientific notation, depending on magnitude,
    ///   followed by the `y` value, both occupying a space of 20 characters with 7 decimal places.
    /// - A leading indent of 8 spaces is added for alignment with the header.
    ///
    /// - Parameters:
    ///   - curve: The `Curve2D` object containing the points to be written.
    ///   - sfa: A `Double` representing the scale factor applied to the curve data.
    ///   - id: An `Int` representing the curve's unique identifier.
    /// - Returns: An array of `String`, each representing a line in the formatted output of the curve.
    ///
    /// Example output for a single curve point:
    /// ```
    ///      32051         0       1.0       1.0       0.0       0.0         0
    ///              0.0           222.65385
    /// ```
    static func writeCurve(curve: Curve2D, sfa: Double, id: Int) -> [String] {
        var lines: [String] = [
            "*DEFINE_CURVE",
            String(format: "%10d%10d%10.1f%10.1f%10.1f%10.1f%10d", id, 0, sfa, 1.0, 0.0, 0.0, 0)
        ]
        
        for point in curve.points {
            let pointString = Self.writePoint(point: point)
            lines.append("        \(pointString)")
        }
        
        return lines
    }
    
    /// Writes the representation of a `CurveTable` object into a formatted string array,
    /// including table metadata and points in a specific layout.
    ///
    /// This method formats the curve table starting with a header line "*DEFINE_TABLE",
    /// followed by the table's unique identifier. Each subsequent line represents an entry
    /// in the curve table, formatted with the value (formatted to show significant digits
    /// with varying spaces for alignment) and its corresponding curve ID from `curveIds`.
    ///
    /// The format ensures each value is appropriately aligned, and each curve ID from `curveIds`
    /// is paired with the corresponding entry in the curve table based on the order.
    ///
    /// - Parameters:
    ///   - table: The `CurveTable` object containing the entries to be written.
    ///   - id: An `Int` representing the curve table's unique identifier.
    ///   - curveIds: An array of `Int`, where each element is a curve ID corresponding to each entry in the table.
    /// - Returns: An array of `String`, each representing a line in the formatted output of the curve table.
    ///
    /// Example output for a curve table entry:
    /// ```
    /// *DEFINE_TABLE
    ///     600909
    ///            0.001    600910
    /// ```
    static func writeCurveTable(table: CurveTable, id: Int) -> [String] {
        var lines: [String] = ["*DEFINE_TABLE", String(format: "%10d", id)]
        
        
        var curveId = id
        var curvePair = [Int: Curve2D] ()
        for index in table.keys.sorted(by: <)  {
            curveId += 1
            // Format the value with appropriate spacing and precision.
            let line = String(format: "%20.3f%10d", index, curveId)
            lines.append(line)
            curvePair[curveId] = table[index]
        }
        
        for index in curvePair.keys.sorted(by: <){
            let curveLines = Self.writeCurve(curve: curvePair[index]!, sfa: 1.0, id: index)
            lines.append(contentsOf: curveLines)
        }
        
        return lines
    }
}
