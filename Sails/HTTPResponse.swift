//
//  HTTPResponse.swift
//  Sails
//
//  Created by Danielle Lancashire on 04/10/2015.
//  Copyright © 2015 Danielle Lancashire. All rights reserved.
//

public protocol HTTPResponse {
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var body: NSData? { get }
    var statusCode: Int { get }
}

public struct ConcreteHTTPResponse: HTTPResponse {
    public let method: HTTPMethod
    public let headers: [String : String]
    public let body: NSData?
    public let statusCode: Int
    
    public init(method: HTTPMethod, headers: [String : String], body: NSData?, statusCode: Int) {
        self.method = method
        self.headers = headers
        self.body = body
        self.statusCode = statusCode
    }
}
