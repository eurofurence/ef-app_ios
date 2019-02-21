//
//  Assertion.swift
//  TestUtilities
//
//  Created by Thomas Sherwood on 21/02/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import XCTest

open class Assertion {

    public let file: StaticString
    public let line: UInt

    public init(file: StaticString = #file, line: UInt = #line) {
        self.file = file
        self.line = line
    }

    public func fail(message: String) {
        XCTFail(message, file: file, line: line)
    }

    public func assert<T>(_ first: T, isEqualTo second: T) where T: Equatable {
        XCTAssertEqual(first, second, file: file, line: line)
    }

    public func assertTrue(_ block: @autoclosure () -> Bool) {
        XCTAssertTrue(block(), file: file, line: line)
    }

}
