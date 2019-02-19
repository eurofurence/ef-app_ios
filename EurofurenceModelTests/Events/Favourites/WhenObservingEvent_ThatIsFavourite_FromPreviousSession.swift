//
//  WhenObservingEvent_ThatIsFavourite_FromPreviousSession.swift
//  EurofurenceModelTests
//
//  Created by Thomas Sherwood on 19/02/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenObservingEvent_ThatIsFavourite_FromPreviousSession: XCTestCase {

    func testTheObserverShouldBeToldTheEventIsFavourited() {
        let response = ModelCharacteristics.randomWithoutDeletions
        let randomEvent = response.events.changed.randomElement().element
        let dataStore = CapturingDataStore(response: response)
        let eventIdentifier: EventIdentifier = EventIdentifier(randomEvent.identifier)
        dataStore.performTransaction { (transaction) in
            transaction.saveFavouriteEventIdentifier(eventIdentifier)
        }

        let context = ApplicationTestBuilder().with(dataStore).build()
        let event = context.eventsService.fetchEvent(identifier: eventIdentifier)
        let observer = CapturingEventObserver()
        event?.add(observer)

        XCTAssertEqual(observer.eventFavouriteState, .favourite)
    }

}
