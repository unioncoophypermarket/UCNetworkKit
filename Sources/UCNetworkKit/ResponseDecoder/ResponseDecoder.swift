//
//  ResponseDecoder.swift
//  Network
//
//  Created by Mahmoud Alaa on 9/10/23.
//

import Foundation

public
protocol ResponseDecoder: Sendable {
    func decode<T: Decodable>(_ data: Data) throws -> T
}


