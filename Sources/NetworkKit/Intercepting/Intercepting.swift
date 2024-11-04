//
//  Intercepting.swift
//
//
//  Created by Mahmoud Alaa on 8/12/24.
//

import Foundation

public
protocol Intercepting {
    func interceptRequest(_ request: URLRequest)
    func interceptResponse(_ request: URLRequest, _ response: URLResponse, _ responseData: Data?)
    func interceptError(_ request: URLRequest, _ error: Error)
}

public
extension Intercepting {
    func interceptRequest(_ request: URLRequest) {}
    func interceptResponse(_ request: URLRequest, _ response: Data?) {}
    func interceptError(_ request: URLRequest, _ error: Error) {}
}

