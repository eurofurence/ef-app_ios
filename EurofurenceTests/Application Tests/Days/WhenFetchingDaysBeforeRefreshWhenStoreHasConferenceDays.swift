//
//  WhenFetchingDaysBeforeRefreshWhenStoreHasConferenceDays.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 15/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenFetchingDaysBeforeRefreshWhenStoreHasConferenceDays: XCTestCase {
    
    func testTheEventsFromTheStoreAreAdapted() {
        let dataStore = CapturingEurofurenceDataStore()
        let response = APISyncResponse.randomWithoutDeletions
        let conferenceDays = response.conferenceDays.changed
        dataStore.performTransaction { (transaction) in
            transaction.saveConferenceDays(conferenceDays)
        }
        
        let context = ApplicationTestBuilder().with(dataStore).build()
        let observer = CapturingEventsServiceObserver()
        context.application.add(observer)
        let expected = context.makeExpectedDays(from: response)
        
        XCTAssertEqual(expected, observer.allDays)
    }
    
}
