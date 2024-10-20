//
//  File.swift
//
//
//  Created by Aaron Ge on 2024/1/28.
//
import Foundation
import Collections

/// A structure representing a curve defined by a collection of 2D points.
///
/// `Curve` is a collection of `Point2D` instances that, when taken together,
/// define the shape of a curve. This structure provides methods to manipulate
/// the curve by adding points and sorting them.
public struct Curve2D {
    private var points: [(x: Decimal, y: Decimal)]
    
    /// Initializes a new curve with the given points.
    ///
    /// - Parameter points: An array of `Point2D` instances to initialize the curve.
    public init(points: [(x: Decimal, y: Decimal)] = []) {
        self.points = points.sorted(by: { $0.x < $1.x })
    }
    
    /// Adds a new point to the curve.
    ///
    /// Appends the given `Point2D` instance to the end of the curve's points array.
    ///
    /// - Parameter point: A `Point2D` instance to add to the curve.
    public mutating func addPoint(x: Decimal, y: Decimal) {
        let newPoint = (x: x, y: y)
        if let insertIndex = points.firstIndex(where: { $0.x > x }) {
            points.insert(newPoint, at: insertIndex)
        } else {
            points.append(newPoint)
        }
    }
    
    /// Generates a textual description of the curve and its points.
    /// This method provides a detailed representation of the curve, including
    /// the coordinates of each point in the curve.
    /// - Returns: A `String` representing the detailed description of the curve.
    func description() -> String {
        let pointDescriptions = points.map { "(\($0.x), \($0.y))" }.joined(separator: ", ")
        return "Curve2D with points: [\(pointDescriptions)]"
    }
    
    /// Interpolated value at a given x-coordinate.
    public func interpolatedValue(at x: Decimal) -> Decimal? {
        guard let i = points.firstIndex(where: { $0.x > x }) else {
            return points.last?.y
        }
        guard i > 0 else {
            return points.first?.y
        }
        let p1 = points[i-1]
        let p2 = points[i]
        let slope = (p2.y - p1.y) / (p2.x - p1.x)
        return p1.y + slope * (x - p1.x)
    }
}

public extension Curve2D{
    /// Accesses the `Point2D` at the specified index.
    subscript(index: Int) -> Point2D {
        get {
            // Ensure the index is within bounds before attempting to access the array
            assert(index >= 0 && index < points.count, "Index out of range")
            return points[index]
        }
        set {
            // Similarly, ensure the index is within bounds before attempting to modify the array
            assert(index >= 0 && index < points.count, "Index out of range")
            points[index] = newValue
        }
    }
}





