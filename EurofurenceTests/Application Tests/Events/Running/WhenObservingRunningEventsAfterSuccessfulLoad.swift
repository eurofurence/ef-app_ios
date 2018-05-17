//
//  WhenObservingRunningEventsAfterSuccessfulLoad.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 14/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenObservingRunningEventsAfterSuccessfulLoad: XCTestCase {
    
    func testEventsThatAreCurrentlyRunningAreProvidedToTheObserver() {
        let syncResponse = APISyncResponse.randomWithoutDeletions
        let randomEvent = syncResponse.events.changed.randomElement().element
        let simulatedTime = randomEvent.startDateTime
        let context = ApplicationTestBuilder().with(simulatedTime).build()
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        
        let observer = CapturingEventsServiceObserver()
        context.application.add(observer)
        
        let expectedEvents = syncResponse.events.changed.filter { (event) -> Bool in
            return simulatedTime >= event.startDateTime && simulatedTime < event.endDateTime
        }
        
        let expected = expectedEvents.map { (event) -> Event2 in
            return context.makeExpectedEvent(from: event, response: syncResponse)
        }
        
        XCTAssertTrue(expected.contains(elementsFrom: observer.runningEvents))
    }
    
    func testEventsThatHaveNotStartedAreNotProvidedToTheObserver() {
        let syncResponse = APISyncResponse.randomWithoutDeletions
        let randomEvent = syncResponse.events.changed.randomElement().element
        let simulatedTime = randomEvent.startDateTime
        let context = ApplicationTestBuilder().with(simulatedTime).build()
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        
        let observer = CapturingEventsServiceObserver()
        context.application.add(observer)
        
        let unexpectedEvents = syncResponse.events.changed.filter { (event) -> Bool in
            return event.startDateTime <= simulatedTime
        }
        
        let unexpected = unexpectedEvents.map { (event) -> Event2 in
            return context.makeExpectedEvent(from: event, response: syncResponse)
        }
        
        XCTAssertFalse(observer.runningEvents.contains(elementsFrom: unexpected))
    }
    
}
