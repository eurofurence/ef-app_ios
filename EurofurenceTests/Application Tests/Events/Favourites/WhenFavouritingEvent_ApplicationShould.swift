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
        let context = ApplicationTestBuilder().build()
        let identifier = Event2.Identifier.random
        context.application.favouriteEvent(identifier: identifier)
        
        XCTAssertTrue(context.dataStore.didFavouriteEvent(identifier))
    }
    
    func testTellEventsObserversTheEventIsNowFavourited() {
        let context = ApplicationTestBuilder().build()
        let identifier = Event2.Identifier.random
        let observer = CapturingEventsServiceObserver()
        context.application.add(observer)
        context.application.favouriteEvent(identifier: identifier)
        
        XCTAssertTrue(observer.capturedFavouriteEventIdentifiers.contains(identifier))
    }
    
    func testTellLateAddedObserversAboutTheFavouritedEvent() {
        let context = ApplicationTestBuilder().build()
        let identifier = Event2.Identifier.random
        let observer = CapturingEventsServiceObserver()
        context.application.favouriteEvent(identifier: identifier)
        context.application.add(observer)
        
        XCTAssertTrue(observer.capturedFavouriteEventIdentifiers.contains(identifier))
    }
    
}
