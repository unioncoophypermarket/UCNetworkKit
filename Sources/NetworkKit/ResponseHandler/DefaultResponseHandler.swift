//
//  DefaultResponseHandler.swift
//  Network
//
//  Created by Mahmoud Alaa on 9/10/23.
//

import Foundation

public
class DefaultResponseHandler: ResponseHandler {
    
    public init() {}
    
    public
    func handleRequestResponse(data: Data?, response: URLResponse?) throws -> Data? {
        guard let response = response as? HTTPURLResponse,
              !(200...299).contains(response.statusCode) else {
            return data
        }
        throw NetworkError.error(statusCode: response.statusCode, data: data)
    }
    
}
