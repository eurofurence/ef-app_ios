//
//  WhenSchedulingReminderForEvent_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 05/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenSchedulingReminderForEvent_ApplicationShould: XCTestCase {
    
    func testScheduleTheNotificationAtTheConfiguredReminderIntervalFromUserPreferences() {
        let response = APISyncResponse.randomWithoutDeletions
        let events = response.events.changed
        let dataStore = CapturingEurofurenceDataStore()
        dataStore.performTransaction { (transaction) in
            transaction.saveEvents(response.events.changed)
            transaction.saveRooms(response.rooms.changed)
            transaction.saveTracks(response.tracks.changed)
        }
        
        let preferences = StubUserPreferences()
        let upcomingEventReminderInterval = TimeInterval.random
        preferences.upcomingEventReminderInterval = upcomingEventReminderInterval
        let context = ApplicationTestBuilder().with(preferences).with(dataStore).build()
        let event = events.randomElement().element
        let expectedScheduleTime = event.startDateTime.addingTimeInterval(upcomingEventReminderInterval)
        let identifier = Event2.Identifier(event.identifier)
        context.application.favouriteEvent(identifier: identifier)
        
        XCTAssertEqual(expectedScheduleTime, context.notificationsService.capturedEventNotificationScheduledDate)
    }
    
}
