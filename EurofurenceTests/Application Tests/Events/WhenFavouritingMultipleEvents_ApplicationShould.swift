//
//  WhenFavouritingMultipleEvents_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 11/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenFavouritingMultipleEvents_ApplicationShould: XCTestCase {
    
    func testTellEventsObserversTheEventsAreNowFavourited() {
        let context = ApplicationTestBuilder().build()
        let identifiers = [Event2.Identifier].random
        let observer = CapturingEventsServiceObserver()
        context.application.add(observer)
        identifiers.forEach(context.application.favouriteEvent)
        
        XCTAssertEqual(identifiers, observer.capturedFavouriteEventIdentifiers)
    }
    
}
