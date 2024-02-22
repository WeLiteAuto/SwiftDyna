//
//  File.swift
//  
//
//  Created by Aaron Ge on 2024/2/21.
//

import Collections
import Foundation

public struct KVFormatedOrderedDictionary<K, V>: Encodable
where  K: Encodable & Hashable,
       V: Encodable
{
    var items: OrderedDictionary<K, V>
    init(_ items: OrderedDictionary<K, V> = [:]) {
        self.items = items
    }
    
    // Computed property to access the keys
    var keys: OrderedSet<K> {
        return items.keys
    }
    
    // Computed property to access the values
    var values: OrderedDictionary<K, V>.Values {
        return items.values
    }
    
    
    subscript(key: K) -> V? {
        get {
            return items[key]
        }
        set {
            items[key] = newValue
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        for (key, value) in items {
            let codingKey = DynamicCodingKeys(stringValue: "\(key)")!
            try container.encode(value, forKey: codingKey)
        }
    }
}


