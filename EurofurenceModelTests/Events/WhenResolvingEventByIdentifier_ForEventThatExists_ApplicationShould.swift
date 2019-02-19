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

    func testResolveTheExpectedEvent() {
        let response = ModelCharacteristics.randomWithoutDeletions
        let context = ApplicationTestBuilder().build()
        context.refreshLocalStore()
        context.api.simulateSuccessfulSync(response)
        let characteristics = response.events.changed.randomElement().element
        let actual = context.eventsService.fetchEvent(identifier: EventIdentifier(characteristics.identifier))

        EventAssertion(context: context, modelCharacteristics: response)
            .assertEvent(actual, characterisedBy: characteristics)
    }

}
