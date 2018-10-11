//
//  WhenUnfavouritingEvent_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 11/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import XCTest

class WhenUnfavouritingEvent_ApplicationShould: XCTestCase {
    
    func testTellTheDataStoreToDeleteTheEventIdentifier() {
        let context = ApplicationTestBuilder().build()
        let identifier = Event.Identifier.random
        context.application.favouriteEvent(identifier: identifier)
        context.application.unfavouriteEvent(identifier: identifier)
        
        XCTAssertTrue(context.dataStore.didDeleteFavouriteEvent(identifier))
    }
    
    func testTellObserversTheEventHasBeenUnfavourited() {
        let context = ApplicationTestBuilder().build()
        let identifier = Event.Identifier.random
        let observer = CapturingEventsServiceObserver()
        context.application.add(observer)
        context.application.favouriteEvent(identifier: identifier)
        context.application.unfavouriteEvent(identifier: identifier)
        
        XCTAssertFalse(observer.capturedFavouriteEventIdentifiers.contains(identifier))
    }
    
    func testTellTheNotificationServiceToRemoveTheScheduledNotification() {
        let context = ApplicationTestBuilder().build()
        let identifier = Event.Identifier.random
        context.application.favouriteEvent(identifier: identifier)
        context.application.unfavouriteEvent(identifier: identifier)
        
        XCTAssertEqual(identifier, context.notificationsService.capturedEventIdentifierToRemoveNotification)
    }
    
}
