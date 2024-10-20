// //
// //  File.swift
// //  
// //
// //  Created by Aaron Ge on 2024/2/28.
// //

// import Foundation
// /// A structure representing a 2D point.
// ///
// /// This structure provides a basic representation of a point in a two-dimensional space,
// /// with `x` and `y` coordinates.
// public struct Point2D {
//     /// The x-coordinate of the point.
//     var x: Decimal
    
//     /// The y-coordinate of the point.
//     var y: Decimal
    
//     /// Returns the x-coordinate formatted to a specific number of decimal places.
//     func formattedX(decimalPlaces: Int = 3) -> String {
//         return String(format: "%.\(decimalPlaces)f", x as NSDecimalNumber)
//     }
    
//     /// Returns the y-coordinate formatted to a specific number of decimal places.
//     func formattedY(decimalPlaces: Int = 3) -> String {
//         return String(format: "%.\(decimalPlaces)f", y as NSDecimalNumber)
//     }
    
//     init?(xString: String, yString: String) {
//         guard let x = Decimal(string: xString),
//               let y = Decimal(string: yString) else {
//             return nil
//         }
//         self.x = x
//         self.y = y
//     }
// }
