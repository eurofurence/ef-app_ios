//
//  WhenResolvingEventByIdentifier_ForEventThatExists_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 17/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenResolvingEventByIdentifier_ForEventThatExists_ApplicationShould: XCTestCase {

    func testInvokeTheHandlerWithTheExpectedEvent() {
        let response = ModelCharacteristics.randomWithoutDeletions
        let context = ApplicationTestBuilder().build()
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(response)
        let event = response.events.changed.randomElement().element
        var actual: Event?
        context.eventsService.fetchEvent(for: EventIdentifier(event.identifier)) { actual = $0 }

        EventAssertion(context: context, modelCharacteristics: response)
            .assertEvent(actual, characterisedBy: event)
    }

}
