//
//  JSONResponseDecoder.swift
//  
//
//  Created by Mahmoud Alaa on 9/12/23.
//

import Foundation

public
class JSONResponseDecoder: ResponseDecoder {
    private let jsonDecoder = JSONDecoder()
    public init() { }
    public func decode<T: Decodable>(_ data: Data) throws -> T {
        return try jsonDecoder.decode(T.self, from: data)
    }
}
