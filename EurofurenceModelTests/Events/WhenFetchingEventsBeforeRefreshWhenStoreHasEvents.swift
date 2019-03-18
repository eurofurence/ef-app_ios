//
//  WhenFetchingEventsBeforeRefreshWhenStoreHasEvents.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 05/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenFetchingEventsBeforeRefreshWhenStoreHasEvents: XCTestCase {

    func testTheEventsFromTheStoreAreAdapted() {
        let response = ModelCharacteristics.randomWithoutDeletions
        let dataStore = FakeDataStore(response: response)
        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let observer = CapturingEventsServiceObserver()
        context.eventsService.add(observer)

        EventAssertion(context: context, modelCharacteristics: response)
            .assertEvents(observer.allEvents, characterisedBy: response.events.changed)
    }

}
