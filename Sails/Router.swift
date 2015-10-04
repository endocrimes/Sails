//
//  Router.swift
//  Sails
//
//  Created by  Danielle Lancashireon 04/10/2015.
//  Copyright © 2015 Danielle Lancashire. All rights reserved.
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
