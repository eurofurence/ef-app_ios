//
//  EventsService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 11/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public protocol EventsSchedule {

    func setDelegate(_ delegate: EventsScheduleDelegate)
    func restrictEvents(to day: Day)

}

public protocol EventsScheduleDelegate {

    func scheduleEventsDidChange(to events: [Event])
    func eventDaysDidChange(to days: [Day])
    func currentEventDayDidChange(to day: Day?)

}

public protocol EventsService {

    func fetchEvent(identifier: EventIdentifier) -> Event?

    func add(_ observer: EventsServiceObserver)
    func makeEventsSchedule() -> EventsSchedule
    func makeEventsSearchController() -> EventsSearchController

}

public protocol EventsServiceObserver {

    func eventsDidChange(to events: [Event])
    func runningEventsDidChange(to events: [Event])
    func upcomingEventsDidChange(to events: [Event])
    func favouriteEventsDidChange(_ identifiers: [EventIdentifier])

}
