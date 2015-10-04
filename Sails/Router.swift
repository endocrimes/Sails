//
//  Router.swift
//  Sails
//
//  Created by Daniel Tomlinson on 04/10/2015.
//  Copyright © 2015 Daniel Tomlinson. All rights reserved.
//

public typealias Handler = HTTPRequest -> HTTPResponse
public typealias Matcher = HTTPRequest -> Bool

public typealias Route = (Matcher, Handler)

public protocol Router {
    var matchers: [Route] { get }
    func handlerForRequest(request: HTTPRequest) -> Handler?
}

public struct ConcreteRouter: Router {
    public var matchers: [Route] = []
    
    public func handlerForRequest(request: HTTPRequest) -> Handler? {
        for (matcher, handler) in matchers where matcher(request) == true {
            return handler
        }
        
        return nil
    }
    
    public init(matchers: [Route]) {
        self.matchers = matchers
    }
}
