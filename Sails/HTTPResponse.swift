//
//  HTTPResponse.swift
//  Sails
//
//  Created by Daniel Tomlinson on 04/10/2015.
//  Copyright © 2015 Daniel Tomlinson. All rights reserved.
//

public protocol HTTPResponse {
    var url: String { get }
    var urlParams: [(String, String)] { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var body: NSData? { get }
    var statusCode: Int { get }
}

public struct ConcreteHTTPResponse: HTTPResponse {
    public let url: String
    public let urlParams: [(String, String)]
    public let method: HTTPMethod
    public let headers: [String : String]
    public let body: NSData?
    public let statusCode: Int
    
    public init(url: String, urlParams: [(String, String)], method: HTTPMethod, headers: [String : String], body: NSData?, statusCode: Int) {
        self.url = url
        self.urlParams = urlParams
        self.method = method
        self.headers = headers
        self.body = body
        self.statusCode = statusCode
    }
}
