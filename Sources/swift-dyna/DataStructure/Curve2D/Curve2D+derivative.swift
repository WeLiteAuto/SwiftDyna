//
//  File 2.swift
//  
//
//  Created by Aaron Ge on 2024/2/18.
//

import Foundation
public extension Curve2D{
    
    /// Computes the derivative of the curve.
    /// - Returns: A new `Curve2D` representing the derivative of the original curve.
    func derivative() -> Curve2D {
        var derivativePoints: [Point2D] = []
        
        for i in 0..<points.count - 1 {
            let deltaX = points[i + 1].x - points[i].x
            let deltaY = points[i + 1].y - points[i].y
            
            // Avoid division by zero
            if deltaX != 0 {
                let slope = deltaY / deltaX
                // Use the midpoint's x-value for the derivative point
                let midPointX = (points[i].x + points[i + 1].x) / 2
                derivativePoints.append(Point2D(x: midPointX, y: slope))
            }
        }
        
        return Curve2D(points: derivativePoints)
    }
    
    
    /// Calculates the intersection point between two line segments, if it exists.
    ///
    /// Uses the vector cross product approach to determine if two line segments intersect and calculates the intersection point. This method handles cases where segments are non-parallel.
    /// - Parameters:
    ///   - seg1: A tuple containing the start and end `Point2D` of the first line segment.
    ///   - seg2: A tuple containing the start and end `Point2D` of the second line segment.
    /// - Returns: An optional `Point2D` representing the intersection point if it exists; otherwise, `nil`.
    static func intersectionBetweenSegments(_ seg1: (Point2D, Point2D), _ seg2: (Point2D, Point2D)) -> Point2D? {
        let p = seg1.0
        let q = seg2.0
        let r = Point2D(x: seg1.1.x - seg1.0.x, y: seg1.1.y - seg1.0.y)
        let s = Point2D(x: seg2.1.x - seg2.0.x, y: seg2.1.y - seg2.0.y)
        
        let rxs = r.x * s.y - r.y * s.x
        let qpxr = (q.x - p.x) * r.y - (q.y - p.y) * r.x
        
        // Parallel lines
        if rxs == 0 && qpxr == 0 {
            return nil // Colinear or parallel
        }
        
        // Non-parallel
        if rxs != 0 {
            let t = ((q.x - p.x) * s.y - (q.y - p.y) * s.x) / rxs
            let u = ((q.x - p.x) * r.y - (q.y - p.y) * r.x) / rxs
            
            if t >= 0 && t <= 1 && u >= 0 && u <= 1 {
                // Intersection found
                return Point2D(x: p.x + t * r.x, y: p.y + t * r.y)
            }
        }
        
        return nil // No intersection
    }
    
    /// Finds the first point of intersection between this curve and another curve.
    ///
    /// Iterates through each segment of both curves to check for intersections. Returns the first intersection point found, if any. This method is useful for detecting collisions or overlaps between curves.
    /// - Parameter curve: A `Curve2D` instance representing the other curve to check for intersections.
    /// - Returns: An optional `Point2D` representing the first intersection point if it exists; otherwise, `nil`.
    func firstIntersection(with curve: Curve2D) -> Point2D? {
        for i in 0..<self.points.count - 1 {
            let segment1 = (self.points[i], self.points[i + 1])
            
            for j in 0..<curve.points.count - 1 {
                let segment2 = (curve.points[j], curve.points[j + 1])
                
                if let intersection = Curve2D.intersectionBetweenSegments(segment1, segment2) {
                    return intersection
                }
            }
        }
        return nil
    }
}

