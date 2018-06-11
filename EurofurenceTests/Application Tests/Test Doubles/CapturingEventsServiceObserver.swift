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
    func eurofurenceApplicationDidUpdateEvents(to events: [Event2]) {
        allEvents = events
    }
    
    private(set) var wasProvidedWithEmptyRunningEvents = false
    private(set) var runningEvents = [Event2]()
    func eurofurenceApplicationDidUpdateRunningEvents(to events: [Event2]) {
        wasProvidedWithEmptyRunningEvents = wasProvidedWithEmptyRunningEvents || events.isEmpty
        runningEvents = events
    }
    
    private(set) var wasProvidedWithEmptyUpcomingEvents = false
    private(set) var upcomingEvents = [Event2]()
    func eurofurenceApplicationDidUpdateUpcomingEvents(to events: [Event2]) {
        wasProvidedWithEmptyUpcomingEvents = wasProvidedWithEmptyUpcomingEvents || events.isEmpty
        upcomingEvents = events
    }
    
    private(set) var capturedFavouriteEventIdentifiers = [Event2.Identifier]()
    func eventsServiceDidResolveFavouriteEvents(_ identifiers: [Event2.Identifier]) {
        capturedFavouriteEventIdentifiers = identifiers
    }
    
}
