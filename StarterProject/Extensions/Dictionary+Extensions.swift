//
//  Dictionary+Extensions.swift
//  StarterProject
//
//  Created by Matt Stone on 4/1/19.
//  Copyright © 2019 Internet Schminternet. All rights reserved.
//

import Foundation

public extension Dictionary {
    public func extractString(key: String) -> String {
        let _key = key as! Key
        if let x = self[_key] as? String {
            return x
        }
        return ""
    }
    
    func keysToCamelCase() -> Dictionary {
        
        let keys = Array(self.keys)
        let values = Array(self.values)
        var dict: Dictionary = [:]
        var newKey : Key!
        keys.enumerated().forEach { ( index, key) in
            
            var value = values[index]
            if let v = value as? Dictionary,
                let vl = v.keysToCamelCase() as? Value {
                value = vl
            }
            
            if let k = key as? String,
                let ky = k.underscoreToCamelCase as? Key {
                newKey = ky
            }
            
            dict[newKey] = value
        }
        
        return dict
    }
}
