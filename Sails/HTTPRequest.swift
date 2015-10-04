//
//  HTTPRequest.swift
//  Sails
//
//  Created by  Danielle Lancashireon 04/10/2015.
//  Copyright © 2015 Danielle Lancashire. All rights reserved.
//

public protocol HTTPRequest {
    var url: String { get }
    var urlParams: [(String, String)] { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var body: NSData? { get }
}


public struct ConcreteHTTPRequest: HTTPRequest {
    public let url: String
    public let urlParams: [(String, String)]
    public let method: HTTPMethod
    public let headers: [String : String]
    public let body: NSData?
    
    public init(url: String, urlParams: [(String, String)], method: HTTPMethod, headers: [String : String], body: NSData?) {
        self.url = url
        self.urlParams = urlParams
        self.method = method
        self.headers = headers
        self.body = body
    }
}
