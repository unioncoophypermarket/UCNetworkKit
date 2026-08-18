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
        interceptor?.interceptRequest(request)
        logger?.log(request: request)
        do {
            return try await execute(request)
        } catch {
            let networkError = resolve(error: error)
            interceptor?.interceptError(request, networkError)

            guard let retryRequest = await interceptor?.retryRequest(request, dueTo: networkError) else {
                throw networkError
            }

            do {
                return try await execute(retryRequest)
            } catch {
                let retryError = resolve(error: error)
                await interceptor?.handleRetryFailure(retryRequest, dueTo: retryError)
                throw retryError
            }
        }
    }

    private
    func execute(_ request: URLRequest) async throws -> Data? {
        let (data, response) = try await sessionManager.request(request)
        interceptor?.interceptResponse(request, response, data)
        logger?.log(responseData: data, response: response)
        return try responseHandler.handleRequestResponse(data: data, response: response)
    }

    private
    func resolve(error: Error) -> NetworkError {
        if let networkError = error as? NetworkError { return networkError }
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet: return .notConnected
            case .cancelled: return .cancelled
            default: return .generic(urlError)
            }
        }
        return .generic(error)
    }
}

