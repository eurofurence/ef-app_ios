//
//  CapturingEventsServiceObserver.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 14/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingEventsServiceObserver: EventsServiceObserver {
    
    private(set) var allEvents = [Event2]()
    func eventsDidChange(to events: [Event2]) {
        allEvents = events
    }
    
    private(set) var wasProvidedWithEmptyRunningEvents = false
    private(set) var runningEvents = [Event2]()
    func runningEventsDidChange(to events: [Event2]) {
        wasProvidedWithEmptyRunningEvents = wasProvidedWithEmptyRunningEvents || events.isEmpty
        runningEvents = events
    }
    
    private(set) var wasProvidedWithEmptyUpcomingEvents = false
    private(set) var upcomingEvents = [Event2]()
    func upcomingEventsDidChange(to events: [Event2]) {
        wasProvidedWithEmptyUpcomingEvents = wasProvidedWithEmptyUpcomingEvents || events.isEmpty
        upcomingEvents = events
    }
    
    private(set) var capturedFavouriteEventIdentifiers = [Event2.Identifier]()
    func favouriteEventsDidChange(_ identifiers: [Event2.Identifier]) {
        capturedFavouriteEventIdentifiers = identifiers
    }
    
    private(set) var allDays: [Day] = []
    func eventDaysDidChange(to days: [Day]) {
        allDays = days
    }
    
    func currentEventDayDidChange(to day: Day?) {
        
    }
    
}
