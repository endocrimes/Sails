//
//  HTTPParser.swift
//  Sails
//
//  Created by  Danielle Lancashireon 04/10/2015.
//  Copyright © 2015 Danielle Lancashire. All rights reserved.
//

public protocol HTTPParser {
    init()
    func parse(socket: Socket) -> HTTPRequest?
}

public struct ConcreteHTTPParser: HTTPParser {
    public init() {
        
    }
    
    public func parse(socket: Socket) -> HTTPRequest? {
        return ConcreteHTTPRequest()
    }
}
