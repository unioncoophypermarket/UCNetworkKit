//
//  DataTransferErrorResolver.swift
//  Network
//
//  Created by Mahmoud Alaa on 9/10/23.
//

import Foundation

public
protocol DataTransferErrorResolver: Sendable {
    func resolve(error: NetworkError) -> Error
}
