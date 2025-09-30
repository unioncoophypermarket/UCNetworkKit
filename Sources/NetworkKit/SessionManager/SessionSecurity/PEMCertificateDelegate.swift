//
//  PEMCertificateDelegate.swift
//  NetworkKit
//
//  Created by Mahmoud Alaa on 1/27/25.
//

import Foundation

// MARK: - PEM File Delegate Implementation
public
class PEMCertificateDelegate: NSObject, URLSessionDelegate {
    private let certificateURL: URL

    public init(certificateURL: URL) {
        self.certificateURL = certificateURL
    }

    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }

        do {
            let certificateData = try Data(contentsOf: self.certificateURL)
            print(certificateData as CFData)
            guard let certificate = SecCertificateCreateWithData(nil, certificateData as CFData) else {
                completionHandler(.cancelAuthenticationChallenge, nil)
                return
            }

            let policy = SecPolicyCreateSSL(true, challenge.protectionSpace.host as CFString)
            var trust: SecTrust?
            SecTrustCreateWithCertificates(certificate, policy, &trust)

            if let trust = trust {
                SecTrustSetAnchorCertificates(trust, [certificate] as CFArray)
                var error: CFError?
                if SecTrustEvaluateWithError(trust, &error) {
                    completionHandler(.useCredential, URLCredential(trust: serverTrust))
                    return
                }
            }
        } catch {
            print("Failed to load PEM file: \(error.localizedDescription)")
        }

        completionHandler(.cancelAuthenticationChallenge, nil)
    }
}
