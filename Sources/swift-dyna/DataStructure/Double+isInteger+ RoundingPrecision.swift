//
//  File.swift
//  
//
//  Created by Aaron Ge on 2024/2/21.
//

import Foundation



public extension Double{
    var isInteger : Bool {
         self.truncatingRemainder(dividingBy: 1) == 0
    }
    
   
}

