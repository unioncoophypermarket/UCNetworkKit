//
//  URLSessionManager.swift
//  Network
//
//  Created by Mahmoud Alaa on 9/10/23.
//

import Foundation

// MARK: - URLSession Network Manager
// Note: If authorization is needed NetworkSessionManager can be implemented by using, for example, Alamofire SessionManager with its RequestAdapter and RequestRetrier and it can be injected into NetworkService instead of default one.


public
class URLSessionManager: NetworkSessionManager {
    public init() {}
    
    public func request(_ request: URLRequest) async throws -> NetworkSessionManager.Result {
        return try await URLSession.shared.data(for: request)
    }
}
