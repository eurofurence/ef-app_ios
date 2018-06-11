//
//  WhenLaunchingApplicationWithPreexistingFavourites.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 11/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenLaunchingApplicationWithPreexistingFavourites: XCTestCase {
    
    func testTheObserversAreToldAboutTheFavouritedEvents() {
        let dataStore = CapturingEurofurenceDataStore()
        let expected = [Event2.Identifier].random
        dataStore.performTransaction { (transaction) in
            expected.forEach(transaction.saveFavouriteEventIdentifier)
        }
        
        let context = ApplicationTestBuilder().with(dataStore).build()
        let observer = CapturingEventsServiceObserver()
        context.application.add(observer)
        
        XCTAssertTrue(expected.contains(elementsFrom: observer.capturedFavouriteEventIdentifiers))
    }
    
    func testTheFavouritesAreSortedByEventStartTime() {
        let response = APISyncResponse.randomWithoutDeletions
        let events = response.events.changed
        let dataStore = CapturingEurofurenceDataStore()
        dataStore.performTransaction { (transaction) in
            transaction.saveEvents(response.events.changed)
            transaction.saveRooms(response.rooms.changed)
            transaction.saveTracks(response.tracks.changed)
            events.map({ Event2.Identifier($0.identifier) }).forEach(transaction.saveFavouriteEventIdentifier)
        }
        
        let context = ApplicationTestBuilder().with(dataStore).build()
        let observer = CapturingEventsServiceObserver()
        context.application.add(observer)
        
        let expected = events.sorted(by: { $0.startDateTime < $1.startDateTime }).map({ Event2.Identifier($0.identifier) })
        
        XCTAssertEqual(expected, observer.capturedFavouriteEventIdentifiers)
    }
    
}
