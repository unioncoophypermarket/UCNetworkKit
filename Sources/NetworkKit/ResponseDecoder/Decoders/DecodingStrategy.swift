//
//  DecodingStrategy.swift
//
//
//  Created by Mahmoud Alaa on 20/12/2023.
//

import Foundation

public
struct DecodingStrategy {
    
    public
    static var lowercase: ([CodingKey]) -> CodingKey {
        return { keys -> CodingKey in
            let key = keys.first!
            let modifiedKey = key.stringValue.prefix(1).lowercased() + key.stringValue.dropFirst()
            return AnyKey(stringValue: modifiedKey)!
        }
    }
}

private
struct AnyKey: CodingKey {
    var stringValue: String

    init?(stringValue: String) {
        self.stringValue = stringValue
    }

    var intValue: Int? {
        return nil
    }

    init?(intValue: Int) {
        return nil
    }
}

