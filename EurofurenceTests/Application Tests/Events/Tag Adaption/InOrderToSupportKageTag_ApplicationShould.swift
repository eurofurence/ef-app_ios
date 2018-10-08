//
//  InOrderToSupportKageTag_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 08/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import XCTest

class InOrderToSupportKageTag_ApplicationShould: XCTestCase {
    
    func testIndicateItIsKageEventWhenTagPresent() {
        var syncResponse = APISyncResponse.randomWithoutDeletions
        let randomEvent = syncResponse.events.changed.randomElement()
        var event = randomEvent.element
        event.tags = ["kage"]
        syncResponse.events.changed = [event]
        let context = ApplicationTestBuilder().build()
        context.performSuccessfulSync(response: syncResponse)
        let eventsObserver = CapturingEventsServiceObserver()
        context.application.add(eventsObserver)
        let observedEvent = eventsObserver.allEvents.first
        
        XCTAssertEqual(true, observedEvent?.isKageEvent)
    }
    
    func testNotIndicateItIsArtShowEventWhenTagNotPresent() {
        var syncResponse = APISyncResponse.randomWithoutDeletions
        let randomEvent = syncResponse.events.changed.randomElement()
        var event = randomEvent.element
        event.tags = []
        syncResponse.events.changed = [event]
        let context = ApplicationTestBuilder().build()
        context.performSuccessfulSync(response: syncResponse)
        let eventsObserver = CapturingEventsServiceObserver()
        context.application.add(eventsObserver)
        let observedEvent = eventsObserver.allEvents.first
        
        XCTAssertEqual(false, observedEvent?.isKageEvent)
    }
    
}
