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
        
        XCTAssertEqual(expected, observer.capturedFavouriteEventIdentifiers)
    }
    
}
