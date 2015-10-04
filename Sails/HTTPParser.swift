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
        if let query = path.componentsSeparatedByString("?").last {
            return query.componentsSeparatedByString("&").map { (param: String) -> (String, String) in
                let tokens = param.componentsSeparatedByString("=")
                if tokens.count >= 2 {
                    let key = tokens[0].stringByRemovingPercentEncoding
                    let value = tokens[1].stringByRemovingPercentEncoding
                    if key != nil && value != nil { return (key!, value!) }
                }
                return ("","")
            }
        }
        
        return []
    }
    
    private func extractHeaders(socket: Socket) -> [String : String] {
        var headers = [String: String]()
        while let headerLine = try? socket.readNextLine() {
            if headerLine.isEmpty {
                return headers
            }
            
            let headerTokens = headerLine.componentsSeparatedByString(":")
            if ( headerTokens.count >= 2 ) {
                // RFC 2616 - "Hypertext Transfer Protocol -- HTTP/1.1", paragraph 4.2, "Message Headers":
                // "Each header field consists of a name followed by a colon (":") and the field value. Field names are case-insensitive."
                // We can keep lower case version.
                let headerName = headerTokens[0].lowercaseString
                let headerValue = headerTokens[1].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                if !headerName.isEmpty && !headerValue.isEmpty {
                    headers.updateValue(headerValue, forKey: headerName)
                }
            }
        }
        
        return headers
    }
    
    private func extractBody(socket: Socket, length: Int) -> NSData? {
        var body = ""
        var counter = 0;
        while counter < length {
            let c = socket.nextInt8()
            if c < 0 {
                return nil
            }
            body.append(UnicodeScalar(c))
            counter++;
        }
        
        return body.dataUsingEncoding(NSUTF8StringEncoding)
    }
}
