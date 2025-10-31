//
//  APIConfiguration.swift
//  
//
//  Created by Mahmoud Alaa on 9/12/23.
//

import Foundation

public
protocol APIConfiguration: Sendable {
    var baseURL: URL { get }
    var headers: [String: String] { get }
    var queryParameters: [String: String] { get }
}
