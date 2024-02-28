////
////  File.swift
////  
////
////  Created by Aaron Ge on 2024/2/21.
////
//
//import Collections
//import Foundation
//
//public struct KVFormatedOrderedDictionary<K, V>: Encodable
//where  K: Encodable & Hashable,
//       V: Codable
//{
//    var items: OrderedDictionary<K, V>
//    init(_ items: OrderedDictionary<K, V> = [:]) {
//        self.items = items
//    }
//    
//    // Computed property to access the keys
//    var keys: OrderedSet<K> {
//        return items.keys
//    }
//    
//    // Computed property to access the values
//    var values: OrderedDictionary<K, V>.Values {
//        return items.values
//    }
//    
//    
//    subscript(key: K) -> V? {
//        get {
//            return items[key]
//        }
//        set {
//            items[key] = newValue
//        }
//    }
//    
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
//        for (key, value) in items {
//            let codingKey = DynamicCodingKeys(stringValue: "\(key)")!
//            try container.encode(value, forKey: codingKey)
//        }
//    }
//}
//
//
//extension KVFormatedOrderedDictionary: Decodable {
//    public init(from decoder: Decoder) throws {
//        self.items = OrderedDictionary<K, V>()
//        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
//        
//        for key in container.allKeys {
//            let value = try container.decode(V.self, forKey: key)
//            if let intValue = key.intValue {
//                // Assuming K can be initialized from an Int
//                guard let keyType = K(exactly: NSNumber(value: intValue)) else {
//                    throw DecodingError.dataCorruptedError(forKey: key, in: container, debugDescription: "Cannot convert key to specified type")
//                }
//                items[keyType] = value
//            } else {
//                // Assuming K can be initialized from a String
//                guard let keyType = K(exactly: NSNumber(value: (key.stringValue as NSString).doubleValue)) else {
//                    throw DecodingError.dataCorruptedError(forKey: key, in: container, debugDescription: "Cannot convert key to specified type")
//                }
//                items[keyType] = value
//            }
//        }
//    }
//}
