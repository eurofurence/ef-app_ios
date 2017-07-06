//
//  CalendarService.swift
//  Eurofurence
//
//  Created by ShezHsky on 06/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

class CalendarService {

    private let calendarPermissionsProviding: CalendarPermissionsProviding
    private let calendarStore: CalendarStore
    private static let thirtyMinutesBeforeEvent: TimeInterval = -1800

    init(calendarPermissionsProviding: CalendarPermissionsProviding, calendarStore: CalendarStore) {
        self.calendarPermissionsProviding = calendarPermissionsProviding
        self.calendarStore = calendarStore
    }

    func add(event: Event) {
        if calendarPermissionsProviding.isAuthorizedForEventsAccess {
            makeAndInsertEvent(event)
        } else {
            calendarPermissionsProviding.requestAccessToEvents { authorized in
                if authorized {
                    self.makeAndInsertEvent(event)
                }
            }
        }
    }

    private func makeAndInsertEvent(_ event: Event) {
        let calendarEvent = makeCalendarStoreEvent()
        copyEventInformationFromEvent(event, intoCalendarEvent: calendarEvent)
        calendarStore.save(event: calendarEvent)
    }

    private func makeCalendarStoreEvent() -> CalendarEvent {
        var calendarEvent = calendarStore.makeEvent()

        if !calendarEvent.isAssociatedToCalendar {
            calendarStore.reloadStore()
            calendarEvent = calendarStore.makeEvent()
        }

        return calendarEvent
    }

    private func copyEventInformationFromEvent(_ event: Event, intoCalendarEvent calendarEvent: CalendarEvent) {
        var calendarEvent = calendarEvent
        calendarEvent.title = event.Title
        calendarEvent.notes = event.Description
        calendarEvent.location = event.ConferenceRoom?.Name
        calendarEvent.startDate = event.StartDateTimeUtc
        calendarEvent.endDate = event.EndDateTimeUtc
        calendarEvent.addAlarm(relativeOffsetFromStartDate: CalendarService.thirtyMinutesBeforeEvent)
    }

}
