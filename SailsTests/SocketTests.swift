//
//  SocketTests.swift
//  Sails
//
//  Created by  Danielle Lancashireon 03/10/2015.
//  Copyright © 2015 Danielle Lancashire. All rights reserved.
//

import XCTest
@testable import Sails

class SocketTests: XCTestCase {
    func test_can_setup_socket() {
        AssertNoThrow {
            let socket = try Socket(port: 8080)
            XCTAssertNotNil(socket)
        }
    }
    
    func test_setting_up_a_socket_on_a_restricted_port_fails() {
        AssertThrows {
            let socket = try Socket(port: 21)
            XCTAssertNotNil(socket)
        }
    }
}
