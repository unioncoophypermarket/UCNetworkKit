//
//  DataTransferError.swift
//  Network
//
//  Created by Mahmoud Alaa on 9/10/23.
//

import Foundation

public
enum DataTransferError: Error, Sendable {
    case noResponse
    case parsing(Error)
    case networkFailure(NetworkError)
    case resolvedNetworkFailure(Error)
}
