//
//  EntityAssertion.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 14/02/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import XCTest

class EntityAssertion {

    private let file: StaticString
    private let line: UInt

    init(file: StaticString = #file, line: UInt = #line) {
        self.file = file
        self.line = line
    }

    func fail(message: String) {
        XCTFail(message, file: file, line: line)
    }

    func assert<T>(_ first: T, isEqualTo second: T) where T: Equatable {
        XCTAssertEqual(first, second, file: file, line: line)
    }

    func assertTrue(_ block: @autoclosure () -> Bool) {
        XCTAssertTrue(block(), file: file, line: line)
    }

}
