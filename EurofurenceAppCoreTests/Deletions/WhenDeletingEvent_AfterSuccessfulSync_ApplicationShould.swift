//
//  WhenDeletingEvent_AfterSuccessfulSync_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 26/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import XCTest

class WhenDeletingEvent_AfterSuccessfulSync_ApplicationShould: XCTestCase {

    func testUpdateDelegateWithoutDeletedEvent() {
        var response = APISyncResponse.randomWithoutDeletions
        let context = ApplicationTestBuilder().build()
        let delegate = CapturingEventsServiceObserver()
        context.application.add(delegate)
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(response)
        let eventToDelete = response.events.changed.randomElement()
        response.events.changed = response.events.changed.filter({ $0.identifier != eventToDelete.element.identifier })
        let expected = Set(response.events.changed.map({ $0.identifier }))
        response.events.changed.removeAll()
        response.events.deleted.append(eventToDelete.element.identifier)
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(response)
        let actual = Set(delegate.allEvents.map({ $0.identifier.rawValue }))

        XCTAssertEqual(expected, actual,
                       "Should have removed event \(eventToDelete.element.identifier)")
    }

}
