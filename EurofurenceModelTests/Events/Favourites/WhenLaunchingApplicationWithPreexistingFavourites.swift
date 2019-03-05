//
//  WhenLaunchingApplicationWithPreexistingFavourites.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 11/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenLaunchingApplicationWithPreexistingFavourites: XCTestCase {

    func testTheObserversAreToldAboutTheFavouritedEvents() {
        let characteristics = ModelCharacteristics.randomWithoutDeletions
        let expected = characteristics.events.changed.map({ EventIdentifier($0.identifier) })
        let dataStore = FakeDataStore(response: characteristics)
        dataStore.performTransaction { (transaction) in
            expected.forEach(transaction.saveFavouriteEventIdentifier)
        }

        let context = ApplicationTestBuilder().with(dataStore).build()
        let observer = CapturingEventsServiceObserver()
        context.eventsService.add(observer)

        XCTAssertTrue(expected.contains(elementsFrom: observer.capturedFavouriteEventIdentifiers))
    }

    func testTheFavouritesAreSortedByEventStartTime() {
        let response = ModelCharacteristics.randomWithoutDeletions
        let events = response.events.changed
        let dataStore = FakeDataStore(response: response)
        dataStore.performTransaction { (transaction) in
            events.map({ EventIdentifier($0.identifier) }).forEach(transaction.saveFavouriteEventIdentifier)
        }

        let context = ApplicationTestBuilder().with(dataStore).build()
        let observer = CapturingEventsServiceObserver()
        context.eventsService.add(observer)

        let expected = events.sorted(by: { $0.startDateTime < $1.startDateTime }).map({ EventIdentifier($0.identifier) })

        XCTAssertEqual(expected, observer.capturedFavouriteEventIdentifiers)
    }

}
