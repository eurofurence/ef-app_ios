//
//  WhenResolvingEventByIdentifier_ForEventThatExists_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 17/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import XCTest

class WhenResolvingEventByIdentifier_ForEventThatExists_ApplicationShould: XCTestCase {

    func testInvokeTheHandlerWithTheExpectedEvent() {
        let response = APISyncResponse.randomWithoutDeletions
        let context = ApplicationTestBuilder().build()
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(response)
        let event = response.events.changed.randomElement().element
        let expected = context.makeExpectedEvent(from: event, response: response)
        var actual: Event?
        context.application.fetchEvent(for: Event.Identifier(event.identifier)) { actual = $0 }

        XCTAssertEqual(expected, actual)
    }

}
