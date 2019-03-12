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

    func testReturnNil() {
        let context = EurofurenceSessionTestBuilder().build()
        let event = context.eventsService.fetchEvent(identifier: .random)

        XCTAssertNil(event)
    }

}
