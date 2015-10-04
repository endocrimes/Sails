//
//  HTTPParser.swift
//  Sails
//
//  Created by Daniel Tomlinson on 04/10/2015.
//  Copyright © 2015 Daniel Tomlinson. All rights reserved.
//

public protocol HTTPParser {
    init()
    func parse(socket: Socket) -> HTTPRequest?
}

public struct ConcreteHTTPParser: HTTPParser {
    public init() {
        
    }
    
    public func parse(socket: Socket) -> HTTPRequest? {
        guard let statusLine = try? socket.readNextLine() else { return nil }
        let statusTokens = statusLine.componentsSeparatedByString(" ")
        print("ConcreteHTTPParser: ", statusTokens)
        guard statusTokens.count == 3 else { return nil }
        
        guard let method = HTTPMethod(rawValue: statusTokens[0]) else { return nil }
        let path = statusTokens[1]
        let urlParams = extractUrlParams(path)
        let headers = extractHeaders(socket)
        guard let contentLengthString = headers["content-length"], let contentLength = Int(contentLengthString) else {
            return ConcreteHTTPRequest(url: path, urlParams: urlParams, method: method, headers: headers, body: nil)
        }
        let body = extractBody(socket, length: contentLength)
        
        return ConcreteHTTPRequest(url: path, urlParams: urlParams, method: method, headers: headers, body: body)
    }
    
    private func extractUrlParams(path: String) -> [(String, String)] {
        return []
    }
    
    private func extractHeaders(socket: Socket) -> [String : String] {
        return [String : String]()
    }
    
    private func extractBody(socket: Socket, length: Int) -> NSData? {
        return nil
    }
}
