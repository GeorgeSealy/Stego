//
//  XCTExtensions.swift
//  StegoTests
//
//  Created by George Sealy on 14/08/18.
//  Copyright © 2018 George Sealy. All rights reserved.
//

import Foundation
import XCTest

// From https://medium.com/@hybridcattt/how-to-test-throwing-code-in-swift-c70a95535ee5

public func XCTAssertNoThrow<T>(_ expression: @autoclosure () throws -> T, _ message: String = "", file: StaticString = #file, line: UInt = #line, also validateResult: (T) -> Void) {
    
    func executeAndAssignResult(_ expression: @autoclosure () throws -> T, to: inout T?) rethrows {
        to = try expression()
    }
    
    var result: T?
    XCTAssertNoThrow(try executeAndAssignResult(expression, to: &result), message, file: file, line: line)
    if let r = result {
        validateResult(r)
    }
}
