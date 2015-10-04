//
//  SailsTests.swift
//  Sails
//
//  Created by Daniel Tomlinson on 04/10/2015.
//  Copyright © 2015 Daniel Tomlinson. All rights reserved.
//

import XCTest
@testable import Sails

let port: in_port_t = 8081

func RegexMatcherMake(regex: NSRegularExpression) -> (HTTPRequest -> Bool) {
    return { (request: HTTPRequest) -> Bool in
        let range = NSMakeRange(0, request.url.characters.count)
        return regex.matchesInString(request.url, options: NSMatchingOptions(rawValue: 0), range: range).count > 0
    }
}

class SailsTests: XCTestCase {
    func test_stack_setup() {
        AssertNoThrow {
            _ = Sails(socket: try Socket(port: port), router: ConcreteRouter(matchers: []), parserType: ConcreteHTTPParser.self)
        }
    }
    
    func test_magic() {
        let helloRouteMatcher = RegexMatcherMake(try! NSRegularExpression(pattern: "/hello", options: .AnchorsMatchLines))
        let helloRouteResponse: Handler = { request in
            return ConcreteHTTPResponse(method: request.method, headers: [:], body: nil, statusCode: 200)
        }
        
        let router = ConcreteRouter(matchers: [(helloRouteMatcher, helloRouteResponse)])
        let sut = Sails(socket: try! Socket(port: 8082), router: router)
        sut.start()
        
        let session = NSURLSession.sharedSession()
        let expectation = expectationWithDescription("Request should return")
        
        let task = session.dataTaskWithURL(NSURL(string: "http://localhost:8082/hello")!) { data, response, error in
            XCTAssertEqual(200, (response as! NSHTTPURLResponse).statusCode)
            expectation.fulfill()
        }
        
        task.resume()
        
        waitForExpectationsWithTimeout(10.0, handler: nil)
        
        sut.stop()
    }
}
