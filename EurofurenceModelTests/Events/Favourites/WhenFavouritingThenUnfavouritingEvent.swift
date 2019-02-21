//
//  WhenFavouritingThenUnfavouritingEvent.swift
//  EurofurenceModelTests
//
//  Created by Thomas Sherwood on 21/02/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenFavouritingThenUnfavouritingEvent: XCTestCase {

    func testObserversShouldBeToldTheEventIsUnfavourited() {
        let context = ApplicationTestBuilder().build()
        let modelCharacteristics = ModelCharacteristics.randomWithoutDeletions
        let randomEvent = modelCharacteristics.events.changed.randomElement().element
        context.performSuccessfulSync(response: modelCharacteristics)
        let identifier = EventIdentifier(randomEvent.identifier)
        let event = context.eventsService.fetchEvent(identifier: identifier)
        let eventObserver = CapturingEventObserver()
        event?.add(eventObserver)

        event?.favourite()
        event?.unfavourite()

        XCTAssertEqual(eventObserver.eventFavouriteState, .notFavourite)
    }

    func testNewlyAddedObserversShouldNotBeToldTheEventIsFavourited() {
        let context = ApplicationTestBuilder().build()
        let modelCharacteristics = ModelCharacteristics.randomWithoutDeletions
        let randomEvent = modelCharacteristics.events.changed.randomElement().element
        context.performSuccessfulSync(response: modelCharacteristics)
        let identifier = EventIdentifier(randomEvent.identifier)
        let event = context.eventsService.fetchEvent(identifier: identifier)
        let eventObserver = CapturingEventObserver()

        event?.favourite()
        event?.unfavourite()
        event?.add(eventObserver)

        XCTAssertEqual(eventObserver.eventFavouriteState, .notFavourite)
    }

}
