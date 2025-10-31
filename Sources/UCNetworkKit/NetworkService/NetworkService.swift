//
//  NetworkService.swift
//  Network
//
//  Created by Mahmoud Alaa on 9/10/23.
//

import Foundation

public protocol NetworkService: Sendable {
    func request(endpoint: Requestable) async throws -> Data?
}
