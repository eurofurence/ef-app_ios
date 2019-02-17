//
//  WhenSchedulingReminderForEvent_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 05/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenSchedulingReminderForEvent_ApplicationShould: XCTestCase {

    func testScheduleTheNotificationAtTheConfiguredReminderIntervalFromUserPreferences() {
        let response = ModelCharacteristics.randomWithoutDeletions
        let dataStore = CapturingDataStore(response: response)
        let preferences = StubUserPreferences()
        let upcomingEventReminderInterval = TimeInterval.random
        preferences.upcomingEventReminderInterval = upcomingEventReminderInterval
        let context = ApplicationTestBuilder().with(preferences).with(dataStore).build()
        let event = response.events.changed.randomElement().element

        let expectedDateComponents: DateComponents = {
            let scheduleTime = event.startDateTime.addingTimeInterval(-upcomingEventReminderInterval)
            let components: Set<Calendar.Component> = Set([.calendar, .timeZone, .year, .month, .day, .hour, .minute])

            return Calendar.current.dateComponents(components, from: scheduleTime)
        }()

        let expectedTitle = event.title

        let expectedBody: String = {
            let expectedTimeString = context.hoursDateFormatter.hoursString(from: event.startDateTime)
            let room: RoomCharacteristics = response.rooms.changed.first(where: { $0.roomIdentifier == event.roomIdentifier })!
            let expectedLocationString = room.name

            return AppCoreStrings.eventReminderBody(timeString: expectedTimeString, roomName: expectedLocationString)
        }()

        let expectedUserInfo: [ApplicationNotificationKey: String] =
            [.notificationContentKind: ApplicationNotificationContentKind.event.rawValue,
             .notificationContentIdentifier: event.identifier]

        context.eventsService.favouriteEvent(identifier: EventIdentifier(event.identifier))

        XCTAssertEqual(expectedDateComponents, context.notificationScheduler.capturedEventNotificationScheduledDateComponents)
        XCTAssertEqual(expectedTitle, context.notificationScheduler.capturedEventNotificationTitle)
        XCTAssertEqual(expectedBody, context.notificationScheduler.capturedEventNotificationBody)
        XCTAssertEqual(expectedUserInfo, context.notificationScheduler.capturedEventNotificationUserInfo)
    }

}
