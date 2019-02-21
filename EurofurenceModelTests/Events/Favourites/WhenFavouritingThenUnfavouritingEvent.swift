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

    var context: ApplicationTestBuilder.Context!
    var event: Event!
    var eventObserver: CapturingEventObserver!

    override func setUp() {
        super.setUp()

        context = ApplicationTestBuilder().build()
        let modelCharacteristics = ModelCharacteristics.randomWithoutDeletions
        let randomEvent = modelCharacteristics.events.changed.randomElement().element
        context.performSuccessfulSync(response: modelCharacteristics)
        let identifier = EventIdentifier(randomEvent.identifier)
        event = context.eventsService.fetchEvent(identifier: identifier)
        eventObserver = CapturingEventObserver()
    }

    private func registerEventObserver() {
        event.add(eventObserver)
    }

    private func favouriteThenUnfavouriteEvent() {
        event.favourite()
        event.unfavourite()
    }

    func testObserversShouldBeToldTheEventIsUnfavourited() {
        registerEventObserver()
        favouriteThenUnfavouriteEvent()

        XCTAssertEqual(eventObserver.eventFavouriteState, .notFavourite)
    }

    func testNewlyAddedObserversShouldNotBeToldTheEventIsFavourited() {
        favouriteThenUnfavouriteEvent()
        registerEventObserver()

        XCTAssertEqual(eventObserver.eventFavouriteState, .notFavourite)
    }

}
