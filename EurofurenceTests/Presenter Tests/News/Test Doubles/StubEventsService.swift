//
//  StubEventsService.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 13/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class StubEventsService: EventsService {
    
    var runningEvents: [Event2] = []
    var upcomingEvents: [Event2] = []
    var allEvents: [Event2] = []
    var favouriteEventIdentifiers: [Event2.Identifier] = []
    var allDays: [Day] = []
    var currentDay: Day?
    
    func stubSomeFavouriteEvents() {
        allEvents = .random(minimum: 3)
        favouriteEventIdentifiers = Array(allEvents.dropFirst()).map({ $0.identifier })
    }
    
    func add(_ observer: EventsServiceObserver) {
        observer.eventsDidChange(to: allEvents)
        observer.runningEventsDidChange(to: runningEvents)
        observer.upcomingEventsDidChange(to: upcomingEvents)
        observer.favouriteEventsDidChange(favouriteEventIdentifiers)
        observer.eventDaysDidChange(to: allDays)
        observer.currentEventDayDidChange(to: currentDay)
    }
    
    func favouriteEvent(identifier: Event2.Identifier) {
        
    }
    
    func unfavouriteEvent(identifier: Event2.Identifier) {
        
    }
    
}
