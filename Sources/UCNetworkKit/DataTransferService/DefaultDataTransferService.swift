//
//  DefaultDataTransferService.swift
//
//
//  Created by Mahmoud Alaa on 9/12/23.
//

import Foundation

public
final class DefaultDataTransferService {
    
    private let networkService: NetworkService
    private let errorResolver: DataTransferErrorResolver
    private let logger: NetworkLogger?
    
    public 
    init(with networkService: NetworkService,
                errorResolver: DataTransferErrorResolver = DefaultDataTransferErrorResolver(),
                logger: NetworkLogger? = nil) {
        self.networkService = networkService
        self.errorResolver = errorResolver
        self.logger = logger
    }
}

extension DefaultDataTransferService: DataTransferService {
    
    public
    func request<T, E>(with endpoint: E) async throws -> T where T : Decodable, T == E.Response, E : ResponseRequestable {
        do {
            let data = try await self.networkService.request(endpoint: endpoint)
            let result: T = try self.decode(data: data, decoder: endpoint.responseDecoder)
            return result
        } catch {
            self.logger?.log(error: error)
            throw await self.resolve(networkError: error)
        }
    }
    
}

extension DefaultDataTransferService {
    
    // MARK: - Decoding data using response decoding which is managing by endpoint
    private
    func decode<T: Decodable>(data: Data?, decoder: ResponseDecoder) throws -> T {
        guard let data else {
            throw DataTransferError.noResponse
        }
        
        return try decoder.decode(data)
    }
    
}

extension DefaultDataTransferService {
    
    private
    func resolve(networkError error: Error) async -> DataTransferError {
        guard let networkError = error as? NetworkError else {
            return .resolvedNetworkFailure(error)
        }
        
        let resolvedError = self.errorResolver.resolve(error: networkError)
        return .resolvedNetworkFailure(resolvedError)
    }
}
