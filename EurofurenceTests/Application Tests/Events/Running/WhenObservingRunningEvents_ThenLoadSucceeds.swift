//
//  WhenObservingRunningEvents_ThenLoadSucceeds.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 16/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenObservingRunningEvents_ThenLoadSucceeds: XCTestCase {
    
    func testTheObserverIsProvidedWithTheRunningEvents() {
        let syncResponse = APISyncResponse.randomWithoutDeletions
        let randomEvent = syncResponse.events.changed.randomElement().element
        let simulatedTime = randomEvent.startDateTime
        let context = ApplicationTestBuilder().with(simulatedTime).build()
        let observer = CapturingEventsServiceObserver()
        context.application.add(observer)
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        
        let expected = makeExpectedEvent(from: randomEvent, response: syncResponse)
        
        XCTAssertTrue(observer.runningEvents.contains(expected))
    }
    
    private func makeExpectedEvent(from event: APIEvent, response: APISyncResponse) -> Event2 {
        let expectedRoom = response.rooms.changed.first(where: { $0.roomIdentifier == event.roomIdentifier })!
        return Event2(title: event.title,
                      room: Room(name: expectedRoom.name),
                      startDate: event.startDateTime)
    }
    
}
