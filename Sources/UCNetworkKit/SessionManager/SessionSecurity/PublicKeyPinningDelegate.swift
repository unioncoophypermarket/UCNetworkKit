//
//  PublicKeyPinningDelegate.swift
//  NetworkKit
//
//  Created by Mahmoud Alaa on 1/27/25.
//

import Foundation

public
final class PublicKeyPinningDelegate: NSObject, URLSessionDelegate {
    private let pinnedPublicKey: String

    public init(pinnedPublicKey: String) {
        self.pinnedPublicKey = pinnedPublicKey
    }

    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard let serverTrust = challenge.protectionSpace.serverTrust,
              let certificate = SecTrustGetCertificateAtIndex(serverTrust, 0),
              let publicKey = SecCertificateCopyKey(certificate),
              let publicKeyData = SecKeyCopyExternalRepresentation(publicKey, nil) as Data? else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }

        let serverPublicKeyBase64 = publicKeyData.base64EncodedString()

        if serverPublicKeyBase64 == self.pinnedPublicKey {
            completionHandler(.useCredential, URLCredential(trust: serverTrust))
        } else {
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }
}
