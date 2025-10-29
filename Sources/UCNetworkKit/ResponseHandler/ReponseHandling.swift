//
//  ResponseHandler.swift
//  Network
//
//  Created by Mahmoud Alaa on 9/10/23.
//

import Foundation

public
protocol ResponseHandler {
    func handleRequestResponse(data: Data?, response: URLResponse?) throws -> Data?
}
