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
        var calendarEvent = calendarStore.makeEvent()

        if !calendarEvent.isAssociatedToCalendar {
            calendarStore.reloadStore()
            calendarEvent = calendarStore.makeEvent()
        }

        calendarEvent.title = event.Title
        calendarEvent.notes = event.Description
        calendarEvent.location = event.ConferenceRoom?.Name
        calendarEvent.startDate = event.StartDateTimeUtc
        calendarEvent.endDate = event.EndDateTimeUtc

        let thirtyMinutesPrior: TimeInterval = -1800
        calendarEvent.addAlarm(relativeOffsetFromStartDate: thirtyMinutesPrior)

        calendarStore.save(event: calendarEvent)
    }

}
