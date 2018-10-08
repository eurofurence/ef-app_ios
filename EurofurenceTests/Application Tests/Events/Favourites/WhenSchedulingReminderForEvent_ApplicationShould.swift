//
//  WhenSchedulingReminderForEvent_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 05/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
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
        let expectedScheduleTime = event.startDateTime.addingTimeInterval(-upcomingEventReminderInterval)
        let identifier = Event2.Identifier(event.identifier)
        context.application.favouriteEvent(identifier: identifier)
        
        XCTAssertEqual(expectedScheduleTime, context.notificationsService.capturedEventNotificationScheduledDate)
    }
    
    func testSupplyTheNameOfTheEventAsTheReminderTitle() {
        let response = APISyncResponse.randomWithoutDeletions
        let events = response.events.changed
        let dataStore = CapturingEurofurenceDataStore()
        dataStore.performTransaction { (transaction) in
            transaction.saveEvents(response.events.changed)
            transaction.saveRooms(response.rooms.changed)
            transaction.saveTracks(response.tracks.changed)
        }
        
        let context = ApplicationTestBuilder().with(dataStore).build()
        let event = events.randomElement().element
        let identifier = Event2.Identifier(event.identifier)
        context.application.favouriteEvent(identifier: identifier)
        
        XCTAssertEqual(event.title, context.notificationsService.capturedEventNotificationTitle)
    }
    
    func testSupplyFormattedStartTimeAndLocationAsNotificationBody() {
        let response = APISyncResponse.randomWithoutDeletions
        let events = response.events.changed
        let dataStore = CapturingEurofurenceDataStore()
        dataStore.performTransaction { (transaction) in
            transaction.saveEvents(response.events.changed)
            transaction.saveRooms(response.rooms.changed)
            transaction.saveTracks(response.tracks.changed)
        }
        
        let context = ApplicationTestBuilder().with(dataStore).build()
        let event = events.randomElement().element
        let identifier = Event2.Identifier(event.identifier)
        context.application.favouriteEvent(identifier: identifier)
        let expectedTimeString = context.hoursDateFormatter.hoursString(from: event.startDateTime)
        let expectedLocationString = response.rooms.changed.first(where: { $0.roomIdentifier == event.roomIdentifier })!.name
        let expected = AppCoreStrings.eventReminderBody(timeString: expectedTimeString, roomName: expectedLocationString)
        
        XCTAssertEqual(expected, context.notificationsService.capturedEventNotificationBody)
    }
    
    func testSupplyCustomUserInfoWithEventTypeAndEventIdentifier() {
        let response = APISyncResponse.randomWithoutDeletions
        let events = response.events.changed
        let dataStore = CapturingEurofurenceDataStore()
        dataStore.performTransaction { (transaction) in
            transaction.saveEvents(response.events.changed)
            transaction.saveRooms(response.rooms.changed)
            transaction.saveTracks(response.tracks.changed)
        }
        
        let context = ApplicationTestBuilder().with(dataStore).build()
        let event = events.randomElement().element
        let identifier = Event2.Identifier(event.identifier)
        context.application.favouriteEvent(identifier: identifier)
        let expected: [ApplicationNotificationKey : String] =
            [ApplicationNotificationKey.notificationContentKind : ApplicationNotificationContentKind.event.rawValue,
             ApplicationNotificationKey.notificationContentIdentifier : event.identifier]
        
        XCTAssertEqual(expected, context.notificationsService.capturedEventNotificationUserInfo)
    }
    
}
