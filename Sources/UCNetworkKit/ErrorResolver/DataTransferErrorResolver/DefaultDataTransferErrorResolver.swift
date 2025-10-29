//
//  File.swift
//  
//
//  Created by Mahmoud Alaa on 9/12/23.
//

import Foundation

// MARK: - Error Resolver

public
class DefaultDataTransferErrorResolver: DataTransferErrorResolver {
    public init() { }
    
    public func resolve(error: NetworkError) -> Error {
        return error
    }
}
