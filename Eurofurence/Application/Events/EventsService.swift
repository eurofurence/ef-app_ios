//
//  EventsService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 11/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol EventsService {

    func add(_ observer: EventsServiceObserver)
    func favouriteEvent(identifier: Event2.Identifier)
    func unfavouriteEvent(identifier: Event2.Identifier)

}

protocol EventsServiceObserver {

    func eventsDidChange(to events: [Event2])
    func runningEventsDidChange(to events: [Event2])
    func upcomingEventsDidChange(to events: [Event2])
    func favouriteEventsDidChange(_ identifiers: [Event2.Identifier])
    func eventDaysDidChange(to days: [Day])
    func currentEventDayDidChange(to day: Day?)

}
