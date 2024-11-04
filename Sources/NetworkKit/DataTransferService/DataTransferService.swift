//
//  DataTransferService.swift
//  Network
//
//  Created by Mahmoud Alaa on 9/10/23.
//

import Foundation

public
protocol DataTransferService {
    
    func request<T: Decodable, E: ResponseRequestable>(with endpoint: E) async throws -> T where E.Response == T
    
    // MARK: - handle this in case you have an request that's have no response like success only 🥵
//    func request<E: ResponseRequestable>(with endpoint: E) async throws where E.Response == Void
    
}


