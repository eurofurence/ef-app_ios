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
    
    func stubSomeFavouriteEvents() {
        allEvents = .random(minimum: 3)
        favouriteEventIdentifiers = Array(allEvents.dropFirst()).map({ $0.identifier })
    }
    
    func add(_ observer: EventsServiceObserver) {
        observer.eurofurenceApplicationDidUpdateEvents(to: allEvents)
        observer.eurofurenceApplicationDidUpdateRunningEvents(to: runningEvents)
        observer.eurofurenceApplicationDidUpdateUpcomingEvents(to: upcomingEvents)
        observer.eventsServiceDidResolveFavouriteEvents(favouriteEventIdentifiers)
        observer.eventsServiceDidUpdateDays(to: allDays)
    }
    
    func favouriteEvent(identifier: Event2.Identifier) {
        
    }
    
    func unfavouriteEvent(identifier: Event2.Identifier) {
        
    }
    
}
