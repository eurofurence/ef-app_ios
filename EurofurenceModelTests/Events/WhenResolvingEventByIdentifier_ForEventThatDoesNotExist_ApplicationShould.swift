//
//  WhenResolvingEventByIdentifier_ForEventThatDoesNotExist_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 17/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenResolvingEventByIdentifier_ForEventThatDoesNotExist_ApplicationShould: XCTestCase {

    func testInvokeTheHandlerWithNilEvent() {
        let context = ApplicationTestBuilder().build()
        var invokedWithNilEvent = false
        context.application.fetchEvent(for: EventIdentifier(.random)) { invokedWithNilEvent = $0 == nil }

        XCTAssertTrue(invokedWithNilEvent)
    }

}
