//
//  FakeEventsService.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 15/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class FakeEventsService: EventsService {
    
    var runningEvents: [Event2] = []
    var upcomingEvents: [Event2] = []
    var allEvents: [Event2] = []
    var favourites: [Event2.Identifier] = []
    var allDays: [Day] = []
    var currentDay: Day?
    
    init(favourites: [Event2.Identifier] = []) {
        self.favourites = favourites
    }
    
    private var observers = [EventsServiceObserver]()
    func add(_ observer: EventsServiceObserver) {
        observers.append(observer)
        
        observer.eventsDidChange(to: allEvents)
        observer.runningEventsDidChange(to: runningEvents)
        observer.upcomingEventsDidChange(to: upcomingEvents)
        observer.favouriteEventsDidChange(favourites)
        observer.eventDaysDidChange(to: allDays)
        observer.currentEventDayDidChange(to: currentDay)
    }
    
    private(set) var favouritedEventIdentifier: Event2.Identifier?
    func favouriteEvent(identifier: Event2.Identifier) {
        favouritedEventIdentifier = identifier
        favourites.append(identifier)
        observers.forEach { $0.favouriteEventsDidChange(favourites) }
    }
    
    private(set) var unfavouritedEventIdentifier: Event2.Identifier?
    func unfavouriteEvent(identifier: Event2.Identifier) {
        unfavouritedEventIdentifier = identifier
        if let idx = favourites.index(of: identifier) {
            favourites.remove(at: idx)
        }
        
        observers.forEach { $0.favouriteEventsDidChange([]) }
    }
    
    private(set) var lastProducedSchedule: FakeEventsSchedule?
    func makeEventsSchedule() -> EventsSchedule {
        let schedule = FakeEventsSchedule()
        lastProducedSchedule = schedule
        return schedule
    }
    
}

extension FakeEventsService {
    
    func stubSomeFavouriteEvents() {
        allEvents = .random(minimum: 3)
        favourites = Array(allEvents.dropFirst()).map({ $0.identifier })
    }
    
    func simulateEventFavourited(identifier: Event2.Identifier) {
        favourites.append(identifier)
        observers.forEach { $0.favouriteEventsDidChange(favourites) }
    }
    
    func simulateEventUnfavourited(identifier: Event2.Identifier) {
        if let idx = favourites.index(of: identifier) {
            favourites.remove(at: idx)
        }
        
        observers.forEach { $0.favouriteEventsDidChange(favourites) }
    }
    
    func simulateEventsChanged(_ events: [Event2]) {
        lastProducedSchedule?.simulateEventsChanged(events)
    }
    
    func simulateDaysChanged(_ days: [Day]) {
        observers.forEach { $0.eventDaysDidChange(to: days) }
    }
    
    func simulateDayChanged(to day: Day) {
        observers.forEach { $0.currentEventDayDidChange(to: day) }
    }
    
}
