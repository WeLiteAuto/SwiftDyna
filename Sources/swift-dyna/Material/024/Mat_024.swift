//
//  File.swift
//
//
//  Created by Aaron Ge on 2024/2/4.
//
import Collections

public struct Mat_024: DYNAMaterial {
    
    
    
    public var id: Int
    public var type: String = "steel"
    public var density: Double
    public var title: String?
    
    public var basic =  [String: Double] ()
    
    public var hardenCurves: MaterialPropertyValue = .directValue(0.0)
    public var fracture: [String : MaterialPropertyValue]? = nil
    
    public init(id: Int, density: Double, title: String? = nil
    ) {
        self.id = id
        self.density = density
        self.title = title ?? "steel"
        if let title = title{
            self.type = title.hasPrefix("AA") ? "aluminum" :  "steel"
        }
    }
    
    public func description() -> String {
        var desc = "Piecewise Linear Plasticity Material: \(id)"
        if let title = title {
            desc += ", \(title)"
        }
        desc += ", Density: \(density)"
        
        return desc
    }
}
