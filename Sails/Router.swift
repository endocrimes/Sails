//
//  Router.swift
//  Sails
//
//  Created by Daniel Tomlinson on 04/10/2015.
//  Copyright © 2015 Daniel Tomlinson. All rights reserved.
//

public typealias Handler = HTTPRequest -> HTTPResponse

public protocol Router {
    func handlerForRequest(request: HTTPRequest) -> Handler?
}

public struct ConcreteRouter: Router {
    public func handlerForRequest(request: HTTPRequest) -> Handler? {
        return nil
    }
}
