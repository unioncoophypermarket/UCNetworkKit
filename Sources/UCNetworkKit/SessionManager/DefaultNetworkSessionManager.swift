//
//  DefaultNetworkSessionManager.swift
//  Network
//
//  Created by Mahmoud Alaa on 9/10/23.
//

import Foundation

// MARK: - Default Network Session Manager
// Note: If authorization is needed NetworkSessionManager can be implemented by using, for example, Alamofire SessionManager with its RequestAdapter and RequestRetrier and it can be injected into NetworkService instead of default one.


public
final class DefaultNetworkSessionManager: NetworkSessionManager {
    
    private let sessionDelegate: URLSessionDelegate?
    
    public init(sessionDelegate: URLSessionDelegate? = nil) {
        self.sessionDelegate = sessionDelegate
    }
    
    
    public func request(_ request: URLRequest) async throws -> NetworkSessionManager.Result {
        let session = URLSession(configuration: .default, delegate: self.sessionDelegate, delegateQueue: nil)
        return try await session.data(for: request)
    }
}
