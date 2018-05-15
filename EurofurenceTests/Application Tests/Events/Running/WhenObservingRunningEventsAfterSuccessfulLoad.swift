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
        
        let expectedRoom = syncResponse.rooms.changed.first(where: { $0.roomIdentifier == randomEvent.roomIdentifier })!
        let expected = Event2(title: randomEvent.title,
                              room: Room(name: expectedRoom.name),
                              startDate: simulatedTime,
                              secondsUntilEventBegins: 0)
        
        XCTAssertTrue(observer.runningEvents.contains(expected))
    }
    
}
