//
//  Endpoint.swift
//  Network
//
//  Created by Mahmoud Alaa on 9/10/23.
//

import Foundation

public
enum HTTPMethodType: String {
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}

public
enum BodyEncoding {
    case jsonSerializationData
    case stringEncodingAscii
    case xWwwFormUrlEncoded
}

public
class Endpoint<R>: ResponseRequestable {
    
    public typealias Response = R
    
    public let path: String
    public let isFullPath: Bool
    public let method: HTTPMethodType
    public let headerParameters: [String: String]
    public let queryParametersEncodable: Encodable?
    public let queryParameters: [String: Any]
    public let bodyParametersEncodable: Encodable?
    public let bodyParameters: [String: Any]
    public let bodyEncoding: BodyEncoding
    public let responseDecoder: ResponseDecoder
    
    public init(path: String,
                isFullPath: Bool = false,
                method: HTTPMethodType,
                headerParameters: [String: String] = [:],
                queryParametersEncodable: Encodable? = nil,
                queryParameters: [String: Any] = [:],
                bodyParametersEncodable: Encodable? = nil,
                bodyParameters: [String: Any] = [:],
                bodyEncoding: BodyEncoding = .jsonSerializationData,
                responseDecoder: ResponseDecoder = JSONResponseDecoder()) {
        self.path = path
        self.isFullPath = isFullPath
        self.method = method
        self.headerParameters = headerParameters
        self.queryParametersEncodable = queryParametersEncodable
        self.queryParameters = queryParameters
        self.bodyParametersEncodable = bodyParametersEncodable
        self.bodyParameters = bodyParameters
        self.bodyEncoding = bodyEncoding
        self.responseDecoder = responseDecoder
    }
}
