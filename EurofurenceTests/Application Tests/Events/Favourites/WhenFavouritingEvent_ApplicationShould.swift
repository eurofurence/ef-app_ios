//
//  WhenFavouritingEvent_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 11/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenFavouritingEvent_ApplicationShould: XCTestCase {
    
    func testTellTheDataStoreToSaveTheEventIdentifier() {
        let response = APISyncResponse.randomWithoutDeletions
        let events = response.events.changed
        let dataStore = CapturingEurofurenceDataStore()
        dataStore.performTransaction { (transaction) in
            transaction.saveEvents(response.events.changed)
            transaction.saveRooms(response.rooms.changed)
            transaction.saveTracks(response.tracks.changed)
        }
        
        let context = ApplicationTestBuilder().with(dataStore).build()
        let identifier = Event2.Identifier(events.randomElement().element.identifier)
        context.application.favouriteEvent(identifier: identifier)
        
        XCTAssertTrue(context.dataStore.didFavouriteEvent(identifier))
    }
    
    func testTellEventsObserversTheEventIsNowFavourited() {
        let response = APISyncResponse.randomWithoutDeletions
        let events = response.events.changed
        let dataStore = CapturingEurofurenceDataStore()
        dataStore.performTransaction { (transaction) in
            transaction.saveEvents(response.events.changed)
            transaction.saveRooms(response.rooms.changed)
            transaction.saveTracks(response.tracks.changed)
        }
        
        let context = ApplicationTestBuilder().with(dataStore).build()
        let identifier = Event2.Identifier(events.randomElement().element.identifier)
        let observer = CapturingEventsServiceObserver()
        context.application.add(observer)
        context.application.favouriteEvent(identifier: identifier)
        
        XCTAssertTrue(observer.capturedFavouriteEventIdentifiers.contains(identifier))
    }
    
    func testTellLateAddedObserversAboutTheFavouritedEvent() {
        let response = APISyncResponse.randomWithoutDeletions
        let events = response.events.changed
        let dataStore = CapturingEurofurenceDataStore()
        dataStore.performTransaction { (transaction) in
            transaction.saveEvents(response.events.changed)
            transaction.saveRooms(response.rooms.changed)
            transaction.saveTracks(response.tracks.changed)
        }
        
        let context = ApplicationTestBuilder().with(dataStore).build()
        let identifier = Event2.Identifier(events.randomElement().element.identifier)
        let observer = CapturingEventsServiceObserver()
        context.application.favouriteEvent(identifier: identifier)
        context.application.add(observer)
        
        XCTAssertTrue(observer.capturedFavouriteEventIdentifiers.contains(identifier))
    }
    
    func testOrganiseTheFavouritesInStartTimeOrder() {
        let response = APISyncResponse.randomWithoutDeletions
        let events = response.events.changed
        let identifier = events.randomElement().element.identifier
        let storedFavourites = events.map({ $0.identifier })
        let dataStore = CapturingEurofurenceDataStore()
        dataStore.performTransaction { (transaction) in
            transaction.saveEvents(response.events.changed)
            transaction.saveRooms(response.rooms.changed)
            transaction.saveTracks(response.tracks.changed)
            
            for storedFavourite in storedFavourites {
                if storedFavourite != identifier {
                    transaction.saveFavouriteEventIdentifier(Event2.Identifier(storedFavourite))
                }
            }
        }
        
        let context = ApplicationTestBuilder().with(dataStore).build()
        let observer = CapturingEventsServiceObserver()
        context.application.add(observer)
        context.application.favouriteEvent(identifier: Event2.Identifier(identifier))
        let expected = events.sorted(by: { $0.startDateTime < $1.startDateTime }).map({ Event2.Identifier($0.identifier) })
        
        XCTAssertEqual(expected, observer.capturedFavouriteEventIdentifiers)
    }
    
}
