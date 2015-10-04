//
//  Router.swift
//  Sails
//
//  Created by  Danielle Lancashireon 04/10/2015.
//  Copyright © 2015 Danielle Lancashire. All rights reserved.
//

public typealias Handler = HTTPRequest -> HTTPResponse

public protocol Router {
    var matchers: [(NSRegularExpression, Handler)] { get }
    func handlerForRequest(request: HTTPRequest) -> Handler?
}

public struct ConcreteRouter: Router {
    public var matchers: [(NSRegularExpression, Handler)] = []
    
    public func handlerForRequest(request: HTTPRequest) -> Handler? {
        for (matcher, handler) in matchers {
            guard matcher.matchesInString(request.url, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, request.url.characters.count)).count > 0 else {
                return nil
            }
            
            return handler
        }
        
        return nil
    }
}
