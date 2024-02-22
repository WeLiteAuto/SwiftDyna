////
////  File.swift
////  
////
////  Created by Aaron Ge on 2024/2/4.
////
//
//import Foundation
//extension Curve2D {
//    /// Transforms each point in the curve using a given transformation function.
//    ///
//    /// - Parameter transform: A closure that takes a `Point2D` as its argument and returns a transformed `Point2D`.
//    /// - Returns: A new `Curve2D` instance with each point transformed by the given function.
//    func map(_ transform: (Point2D) -> Point2D) -> Curve2D {
//        let transformedPoints = self.points.map(transform)
//        return Curve2D(points: transformedPoints)
//    }
//    
//    /// Reduces the points in the curve to a single value using the provided closure.
//        /// - Parameters:
//        ///   - initialResult: The initial value for the reduction.
//        ///   - nextPartialResult: A closure that takes the current accumulated value and a `Point2D` instance, and returns a new accumulated value.
//        /// - Returns: The final accumulated value after all points have been processed.
//        func reduce<Result>(_ initialResult: Result, _ nextPartialResult: (Result, Point2D) -> Result) -> Result {
//            return points.reduce(initialResult, nextPartialResult)
//        }
//}
