//
//  NetworkError.swift
//  Network
//
//  Created by Mahmoud Alaa on 9/10/23.
//

import Foundation

public enum NetworkError: Error {

    case error(statusCode: Int, data: Data?)
    case notConnected
    case cancelled
    case generic(Error)
    case urlGeneration

    public var errorCode: Int {
        switch self {
        case let .error(statusCode, _):
            return statusCode
        case .notConnected:
            return NSURLErrorNotConnectedToInternet
        case .cancelled:
            return NSURLErrorCancelled
        case .urlGeneration:
            return NSURLErrorBadURL
        case let .generic(error):
            return (error as NSError).code
        }
    }

    public var statusCode: Int? {
        if case let .error(code, _) = self {
            return code
        }
        return nil
    }
}

extension NetworkError {

    public var isNotFoundError: Bool {
        self.statusCode == 404
    }

    public func hasStatusCode(_ code: Int) -> Bool {
        self.statusCode == code
    }
}
