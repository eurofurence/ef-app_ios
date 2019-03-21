//
//  NotificationScheduleControllerTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 20/03/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class NotificationScheduleController: EventsServiceObserver {
    
    private struct ScheduleNotificationWhenEventFavourited: EventObserver {
        
        unowned let controller: NotificationScheduleController
        
        func eventDidBecomeFavourite(_ event: Event) {
            controller.scheduleNotification(for: event)
        }
        
        func eventDidBecomeUnfavourite(_ event: Event) {
            controller.cancelNotification(for: event)
        }
        
    }
    
    private lazy var favouritesObserver = ScheduleNotificationWhenEventFavourited(controller: self)
    private let notificationScheduler: NotificationScheduler
    private let hoursDateFormatter: HoursDateFormatter
    private let upcomingEventReminderInterval: TimeInterval
    
    init(eventsService: EventsService,
         notificationScheduler: NotificationScheduler,
         hoursDateFormatter: HoursDateFormatter,
         upcomingEventReminderInterval: TimeInterval) {
        self.notificationScheduler = notificationScheduler
        self.hoursDateFormatter = hoursDateFormatter
        self.upcomingEventReminderInterval = upcomingEventReminderInterval
        
        eventsService.add(self)
    }
    
    func eventsDidChange(to events: [Event]) {
        events.forEach({ $0.add(favouritesObserver) })
    }
    
    func runningEventsDidChange(to events: [Event]) { }
    func upcomingEventsDidChange(to events: [Event]) { }
    func favouriteEventsDidChange(_ identifiers: [EventIdentifier]) { }
    
    private func scheduleNotification(for event: Event) {
        let waitInterval = upcomingEventReminderInterval * -1
        let reminderDate = event.startDate.addingTimeInterval(waitInterval)
        let startTimeString = hoursDateFormatter.hoursString(from: event.startDate)
        let body = AppCoreStrings.eventReminderBody(timeString: startTimeString, roomName: event.room.name)
        
        let eventIdentifier = event.identifier
        let userInfo: [ApplicationNotificationKey: String] = [
            .notificationContentKind: ApplicationNotificationContentKind.event.rawValue,
            .notificationContentIdentifier: event.identifier.rawValue
        ]
        
        let components: DateComponents = {
            let desired: Set<Calendar.Component> = Set([.calendar, .timeZone, .year, .month, .day, .hour, .minute])
            return Calendar.current.dateComponents(desired, from: reminderDate)
        }()
        
        notificationScheduler.scheduleNotification(forEvent: eventIdentifier,
                                                   at: components,
                                                   title: event.title,
                                                   body: body,
                                                   userInfo: userInfo)
    }
    
    private func cancelNotification(for event: Event) {
        notificationScheduler.cancelNotification(forEvent: event.identifier)
    }
    
}

class NotificationScheduleControllerTests: XCTestCase {

    func testFavouritingEventSchedulesNotification() {
        let eventsService = FakeEventsService()
        let events = [StubEvent].random
        eventsService.allEvents = events
        let notificationScheduler = CapturingNotificationScheduler()
        let hoursDateFormatter = FakeHoursDateFormatter()
        let upcomingEventReminderInterval = TimeInterval.random
        let controller = NotificationScheduleController(eventsService: eventsService,
                                                        notificationScheduler: notificationScheduler,
                                                        hoursDateFormatter: hoursDateFormatter,
                                                        upcomingEventReminderInterval: upcomingEventReminderInterval)
        
        let eventToFavourite = events.randomElement().element
        eventToFavourite.favourite()
        
        let expectedDateComponents: DateComponents = {
            let scheduleTime = eventToFavourite.startDate.addingTimeInterval(-upcomingEventReminderInterval)
            let components: Set<Calendar.Component> = Set([.calendar, .timeZone, .year, .month, .day, .hour, .minute])
            
            return Calendar.current.dateComponents(components, from: scheduleTime)
        }()
        
        let expectedTitle = eventToFavourite.title
        
        let expectedBody: String = {
            let expectedTimeString = hoursDateFormatter.hoursString(from: eventToFavourite.startDate)
            return AppCoreStrings.eventReminderBody(timeString: expectedTimeString, roomName: eventToFavourite.room.name)
        }()
        
        let expectedUserInfo: [ApplicationNotificationKey: String] =
            [.notificationContentKind: ApplicationNotificationContentKind.event.rawValue,
             .notificationContentIdentifier: eventToFavourite.identifier.rawValue]
        
        XCTAssertEqual(eventToFavourite.identifier, notificationScheduler.capturedEventIdentifier)
        XCTAssertEqual(expectedDateComponents, notificationScheduler.capturedEventNotificationScheduledDateComponents)
        XCTAssertEqual(expectedTitle, notificationScheduler.capturedEventNotificationTitle)
        XCTAssertEqual(expectedBody, notificationScheduler.capturedEventNotificationBody)
        XCTAssertEqual(expectedUserInfo, notificationScheduler.capturedEventNotificationUserInfo)
    }
    
    func testUnfavouritingEventCancelsNotification() {
        let eventsService = FakeEventsService()
        let events = [StubEvent].random
        eventsService.allEvents = events
        let notificationScheduler = CapturingNotificationScheduler()
        let hoursDateFormatter = FakeHoursDateFormatter()
        let upcomingEventReminderInterval = TimeInterval.random
        let controller = NotificationScheduleController(eventsService: eventsService,
                                                        notificationScheduler: notificationScheduler,
                                                        hoursDateFormatter: hoursDateFormatter,
                                                        upcomingEventReminderInterval: upcomingEventReminderInterval)
        
        let eventToFavourite = events.randomElement().element
        eventToFavourite.favourite()
        eventToFavourite.unfavourite()
        
        XCTAssertEqual(eventToFavourite.identifier, notificationScheduler.capturedEventIdentifierToRemoveNotification)
    }

}
