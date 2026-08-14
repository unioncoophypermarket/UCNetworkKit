//
//  Intercepting.swift
//
//
//  Created by Mahmoud Alaa on 8/12/24.
//

import Foundation

public
protocol Intercepting: Sendable {
    func interceptRequest(_ request: URLRequest)
    func interceptResponse(_ request: URLRequest, _ response: URLResponse?, _ responseData: Data?)
    func interceptError(_ request: URLRequest, _ error: Error)
    /// Return a modified URLRequest to retry (e.g. with a refreshed token), or nil to propagate the error.
    func retryRequest(_ request: URLRequest, dueTo error: Error) async -> URLRequest?
    /// Called when the retry attempt also fails; use for session-expiry logout or final error handling.
    func handleRetryFailure(_ request: URLRequest, dueTo error: Error) async
}

public
extension Intercepting {
    func interceptRequest(_ request: URLRequest) {}
    func interceptResponse(_ request: URLRequest, _ response: URLResponse?, _ responseData: Data?) {}
    func interceptError(_ request: URLRequest, _ error: Error) {}
    func retryRequest(_ request: URLRequest, dueTo error: Error) async -> URLRequest? { nil }
    func handleRetryFailure(_ request: URLRequest, dueTo error: Error) async {}
}

