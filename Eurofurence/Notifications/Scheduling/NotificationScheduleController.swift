//
//  NotificationScheduleController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 22/03/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation

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
        let body = String.eventReminderBody(timeString: startTimeString, roomName: event.room.name)
        
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
