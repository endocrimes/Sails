//
//  SailsTests.swift
//  Sails
//
//  Created by  Danielle Lancashireon 04/10/2015.
//  Copyright © 2015 Danielle Lancashire. All rights reserved.
//

import XCTest
@testable import Sails

let port: in_port_t = 8081

class SailsTests: XCTestCase {
    func test_stack_setup() {
        AssertNoThrow {
            _ = Sails(socket: try Socket(port: port), router: ConcreteRouter(), parserType: ConcreteHTTPParser.self)
        }
    }
    
    func test_magic() {
        let helloRouteMatcher = try! NSRegularExpression(pattern: "/hello", options: .AnchorsMatchLines)
        let helloRouteResponse: Handler = { request in
            return ConcreteHTTPResponse(method: request.method, headers: [:], body: nil, statusCode: 200)
        }
        
        let router = ConcreteRouter(matchers: [(helloRouteMatcher, helloRouteResponse)])
        let sut = Sails(router: router)
        sut.start()
        
        let session = NSURLSession.sharedSession()
        let expectation = expectationWithDescription("Request should return")
        
        let task = session.dataTaskWithURL(NSURL(string: "http://localhost:8080/hello")!) { data, response, error in
            expectation.fulfill()
        }
        
        task.resume()
        
        waitForExpectationsWithTimeout(10.0, handler: nil)
        
        sut.stop()
    }
}
