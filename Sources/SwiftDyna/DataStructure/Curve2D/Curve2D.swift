//
//  File.swift
//
//
//  Created by Aaron Ge on 2024/1/28.
//
import Foundation
import Collections
/// A structure representing a 2D point.
///
/// This structure provides a basic representation of a point in a two-dimensional space,
/// with `x` and `y` coordinates.
public struct Point2D {
    /// The x-coordinate of the point.
    var x: Double
    
    /// The y-coordinate of the point.
    var y: Double
}

/// A structure representing a curve defined by a collection of 2D points.
///
/// `Curve` is a collection of `Point2D` instances that, when taken together,
/// define the shape of a curve. This structure provides methods to manipulate
/// the curve by adding points and sorting them.
public struct Curve2D {
    /// An array of `Point2D` instances that define the curve.
    var points: [Point2D]
    
    /// Initializes a new curve with the given points.
    ///
    /// - Parameter points: An array of `Point2D` instances to initialize the curve.
    init(points: [Point2D] = []) {
        self.points = points
    }
    
    /// Adds a new point to the curve.
    ///
    /// Appends the given `Point2D` instance to the end of the curve's points array.
    ///
    /// - Parameter point: A `Point2D` instance to add to the curve.
    mutating func addPoint(_ point: Point2D) {
        points.append(point)
    }
    
    /// Sorts the points of the curve based on their x-coordinate.
    ///
    /// This method sorts the points array in ascending order by the x-coordinate
    /// of each point. It modifies the order of points in the curve's points array.
    mutating func sortByX() {
        points.sort { $0.x < $1.x }
    }
    
    /// Generates a textual description of the curve and its points.
    /// This method provides a detailed representation of the curve, including
    /// the coordinates of each point in the curve.
    /// - Returns: A `String` representing the detailed description of the curve.
    func description() -> String {
        let pointDescriptions = points.map { "(\($0.x), \($0.y))" }.joined(separator: ", ")
        return "Curve2D with points: [\(pointDescriptions)]"
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




