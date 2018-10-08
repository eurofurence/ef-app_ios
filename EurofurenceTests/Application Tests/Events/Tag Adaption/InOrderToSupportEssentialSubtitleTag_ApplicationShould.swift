//
//  InOrderToSupportEssentialSubtitleTag_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 16/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import XCTest

class InOrderToSupportEssentialSubtitleTag_ApplicationShould: XCTestCase {
    
    func testCombineSubtitleWithTitle() {
        var syncResponse = APISyncResponse.randomWithoutDeletions
        let randomEvent = syncResponse.events.changed.randomElement()
        var event = randomEvent.element
        event.tags = ["essential_subtitle"]
        syncResponse.events.changed = [event]
        let context = ApplicationTestBuilder().build()
        context.performSuccessfulSync(response: syncResponse)
        let eventsObserver = CapturingEventsServiceObserver()
        context.application.add(eventsObserver)
        let observedEvent = eventsObserver.allEvents.first
        let expected = "\(event.title) - \(event.subtitle)"
        
        XCTAssertEqual(expected, observedEvent?.title)
    }
    
}
