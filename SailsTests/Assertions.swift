//
//  Assertions.swift
//  Sails
//
//  Created by Daniel Tomlinson on 03/10/2015.
//  Copyright © 2015 Daniel Tomlinson. All rights reserved.
//

import XCTest

/// This allows you to write safe tests for the happy path of failable functions.
/// It helps you to avoid the `try!` operator in tests.
///
/// If you want to test a function, which may fail in general, you may think of using `try`.
/// But this would mean that you have to declare your test method as throwing, which causes that
/// XCTest doesn't execute the test anymore.
///
/// So in consequence, you would usually need to write:
///
///     XCTAssertEqual(try! fib(x), 21)
///
/// If the expression fails, your whole test suite doesn't execute further and aborts immediately,
/// which is very undesirable, especially on CI, but also for your workflow when you use TDD.
///
/// Instead you can write now:
///
///     AssertNoThrow {
///         XCTAssertEqual(try fib(x), 21)
///     }
///
/// Or alternatively:
///
///     AssertNoThrow(try fib(x)).map { (y: Int) in
///         XCTAssertEqual(y, 21)
///     }
///
/// If the expression fails, your test fails.
///
public func AssertNoThrow<R>(@autoclosure closure: () throws -> R) -> R? {
    var result: R?
    AssertNoThrow() {
        result = try closure()
    }
    return result
}

public func AssertNoThrow(@noescape closure: () throws -> ()) {
    do {
        try closure()
    } catch let error {
        XCTFail("Caught unexpected error <\(error)>.")
    }
}

public func AssertThrows(@noescape closure: () throws -> ()) {
    do {
        try closure()
        XCTFail("Closure did not throw and error.")
    }
    catch {
        
    }
}