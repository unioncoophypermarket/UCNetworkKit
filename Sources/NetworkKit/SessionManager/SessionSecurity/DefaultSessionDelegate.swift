//
//  DefaultSessionDelegate.swift
//  NetworkKit
//
//  Created by Mahmoud Alaa on 1/27/25.
//

import Foundation

public
class DefaultSessionDelegate: NSObject, URLSessionDelegate {
    
    public
    override init() {
        super.init()
    }
    
    public
    func urlSession(_ session: URLSession,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        // Default handling
        completionHandler(.performDefaultHandling, nil)
    }
}
