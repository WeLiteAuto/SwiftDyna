//
//  File.swift
//
//
//  Created by Aaron Ge on 2024/2/2.
//

import Foundation
import Collections

/// Represents an elastic material model in LS-DYNA simulations.
///
/// This struct models the basic properties of an elastic material, including its
/// density, elastic modulus, Poisson's ratio, and other related properties.
/// The material is defined by the LS-DYNA keyword `*MAT_ELASTIC` and includes
/// common parameters used to describe elastic behavior.
public struct ElasticMaterial_001: DYNAMaterial {
    /// The unique identifier for the material.
    public var id: Int = 0
    
    /// The LS-DYNA material type keyword.
    public var type: String = "steel"
    
    /// The density of the material in kg/mm³.
    public var density: Double = 7.9e-9
    
    /// An optional title for the material.
    public var title: String? = nil
    
    /// A dictionary of material properties, including Young's modulus (E),
    /// Poisson's ratio (PR), damping coefficients (DA, DB), bulk modulus (K),
    /// critical volume compression (VC), and pressure cutoff (CP).
    ///
    public var basic : [String: Double] = [
        "Youngs": 210000,
        "Poison": 0.3,
        "DA": 0,
        "DB": 0,
        "K": 0,
        "VC": 0.2,
        "CP": 1e20]
    
    public var properties:  OrderedCollections.OrderedDictionary<String, MaterialPropertyValue> = [:]
    
    /// An array of curves associated with the material.
    public var curves: OrderedCollections.OrderedDictionary<Int, Curve2D> = [:]
    
    /// An array of curve tables associated with the material.
    
    public var tables: OrderedCollections.OrderedDictionary<Int, CurveTable> = [:]
    
    /// Provides a textual description of the material.
    /// - Returns: A string describing the material, including its ID.
    public func description() -> String {
        return "Elastic Material: \(id)"
    }
}
