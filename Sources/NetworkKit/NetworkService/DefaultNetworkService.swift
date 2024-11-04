//
//  DefaultNetworkService.swift
//  Network
//
//  Created by Mahmoud Alaa on 9/10/23.
//

import Foundation

public
final class DefaultNetworkService {
    
    private let config: APIConfiguration
    private let sessionManager: NetworkSessionManager
    private let responseHandler: ResponseHandler
    private let logger: NetworkLogger?
    private let interceptor: Intercepting?
    
    public init(config: APIConfiguration,
                sessionManager: NetworkSessionManager = URLSessionManager(),
                responseHandler: ResponseHandler = DefaultResponseHandler(),
                logger: NetworkLogger? = nil,
                interceptor: Intercepting? = nil) {
        self.sessionManager = sessionManager
        self.config = config
        self.responseHandler = responseHandler
        self.logger = logger
        self.interceptor = interceptor
    }
}


extension DefaultNetworkService: NetworkService {
    
    public
    func request(endpoint: Requestable) async throws -> Data? {
        let urlRequest = try endpoint.urlRequest(with: config)
        return try await request(request: urlRequest)
    }

}

extension DefaultNetworkService {
    
    private
    func request(request: URLRequest) async throws -> Data? {
        self.interceptor?.interceptRequest(request)
        self.logger?.log(request: request)
        do {
            let result = try await self.sessionManager.request(request)
            self.interceptor?.interceptResponse(request, result.0)
            self.logger?.log(responseData: result.0, response: result.1)
            return try self.responseHandler.handleRequestResponse(data: result.0, response: result.1)
        } catch {
            let error = resolve(error: error)
            self.interceptor?.interceptError(request, error)
            throw error
        }
        
    }
    
    private
    func resolve(error: Error) -> NetworkError {
        let code = URLError.Code(rawValue: (error as NSError).code)
        switch code {
        case .notConnectedToInternet:
            return .notConnected
        case .cancelled:
            return .cancelled
        default: return
                .generic(error)
        }
    }
}

