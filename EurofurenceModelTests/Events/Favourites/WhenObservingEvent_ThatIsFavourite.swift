//
//  WhenObservingEvent_ThatIsFavourite.swift
//  EurofurenceModelTests
//
//  Created by Thomas Sherwood on 19/02/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenObservingEvent_ThatIsFavourite: XCTestCase {

    func testTheObserverShouldBeToldTheEventIsFavourited() {
        let response = ModelCharacteristics.randomWithoutDeletions
        let dataStore = FakeDataStore(response: response)
        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let randomEvent = response.events.changed.randomElement().element
        let event = context.eventsService.fetchEvent(identifier: EventIdentifier(randomEvent.identifier))
        event?.favourite()

        let observer = CapturingEventObserver()
        event?.add(observer)

        XCTAssertEqual(observer.eventFavouriteState, .favourite)
    }

}
