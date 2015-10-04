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
        return ConcreteHTTPRequest()
    }
}
