//
//  DefaultNetworkService.swift
//  Network
//
//  Created by Mahmoud Alaa on 9/10/23.
//

import Foundation

public
final class DefaultNetworkService: Sendable {
    
    private let config: APIConfiguration
    private let sessionManager: NetworkSessionManager
    private let responseHandler: ResponseHandler
    private let logger: NetworkLogger?
    private let interceptor: Intercepting?
    
    public init(config: APIConfiguration,
                sessionManager: NetworkSessionManager = DefaultNetworkSessionManager(sessionDelegate: DefaultSessionDelegate()),
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
        let urlRequest = try endpoint.urlRequest(with: self.config)
        return try await self.request(request: urlRequest)
    }
    
}

extension DefaultNetworkService {
    
    private
    func request(request: URLRequest) async throws -> Data? {
        self.interceptor?.interceptRequest(request)
        self.logger?.log(request: request)
        do {
            let result = try await self.sessionManager.request(request)
            self.interceptor?.interceptResponse(request, result.1, result.0)
            self.logger?.log(responseData: result.0, response: result.1)
            return try self.responseHandler.handleRequestResponse(data: result.0, response: result.1)
        } catch {
            let resolvedError = self.resolve(error: error)
            self.interceptor?.interceptError(request, resolvedError)

            // One-shot retry: let the interceptor refresh auth and return a new request.
            if let retried = await self.interceptor?.retryRequest(request, dueTo: resolvedError) {
                do {
                    let result = try await self.sessionManager.request(retried)
                    self.interceptor?.interceptResponse(retried, result.1, result.0)
                    self.logger?.log(responseData: result.0, response: result.1)
                    return try self.responseHandler.handleRequestResponse(data: result.0, response: result.1)
                } catch {
                    let retryError = self.resolve(error: error)
                    await self.interceptor?.handleRetryFailure(retried, dueTo: retryError)
                    throw retryError
                }
            }

            throw resolvedError
        }
    }
    
    private
    func resolve(error: Error) -> NetworkError {
        
        if let networkError = error as? NetworkError {
            return networkError
        }
        
        let nsError = error as NSError
        let code = URLError.Code(rawValue: nsError.code)
        switch code {
        case .notConnectedToInternet:
            return .notConnected
        case .cancelled:
            return .cancelled
        default:
            return .generic(error)
        }
        
    }
}
