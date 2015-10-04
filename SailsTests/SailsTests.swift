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
}
