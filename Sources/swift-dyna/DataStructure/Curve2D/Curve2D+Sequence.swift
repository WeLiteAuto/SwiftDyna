//
//  File.swift
//  
//
//  Created by Aaron Ge on 2024/2/20.
//

import Foundation
/// An extension to make `Curve2D` conform to the `Sequence` protocol.
///
/// By conforming to `Sequence`, instances of `Curve2D` can be iterated using standard Swift iteration and sequence operations, such as `for-in` loops, `map`, `filter`, etc. This extension provides an iterator over the points in the curve, allowing easy access to each `Point2D` within the curve.
///
/// ## Topics
///
/// ### Iterating over Points
///
/// - ``Curve2D/makeIterator()`
extension Curve2D: Sequence {
    /// Returns an iterator over the points in the curve.
        ///
        /// The iterator returned allows for sequential access to each `Point2D` in the `Curve2D` instance. This method enables `Curve2D` to conform to the `Sequence` protocol, integrating with Swift's sequence and collection algorithms.
        ///
        /// ## Example
        ///
        /// Here's how you can iterate over a `Curve2D` instance:
        ///
        /// ```swift
        /// let curve = Curve2D(points: [Point2D(x: 1, y: 2), Point2D(x: 3, y: 4), Point2D(x: 5, y: 6)])
        ///
        /// for point in curve {
        ///     print("Point: (\(point.x), \(point.y))")
        /// }
        /// ```
        ///
        /// - Returns: An `AnyIterator<Point2D>` that iterates over each point in the curve.
    public func makeIterator() -> AnyIterator<Point2D> {
        var index = 0
        return AnyIterator {
            guard index < self.points.count else {
                return nil
            }
            let point = self.points[index]
            index += 1
            return point
        }
    }
}
