//
//  NetworkSessionManager.swift
//  
//
//  Created by Mahmoud Alaa on 9/12/23.
//

import Foundation

public
protocol NetworkSessionManager: Sendable {
    typealias Result = (Data?, URLResponse?)
    
    func request(_ request: URLRequest) async throws -> Result
}
