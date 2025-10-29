//
//  NetworkErrorLogger.swift
//  Network
//
//  Created by Mahmoud Alaa on 9/10/23.
//

import Foundation

public protocol NetworkLogger {
    func log(request: URLRequest)
    func log(responseData data: Data?, response: URLResponse?)
    func log(error: Error)
}

extension Dictionary where Key == String {
    public
    func prettyPrint() -> String {
        var string: String = ""
        if let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) {
            if let nsString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                string = nsString as String
            }
        }
        return string
    }
}
