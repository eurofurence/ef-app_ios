//
//  CapturingEventsServiceObserver.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 14/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation

class CapturingEventsServiceObserver: EventsServiceObserver {

    private(set) var allEvents = [Event]()
    func eventsDidChange(to events: [Event]) {
        allEvents = events
    }

    private(set) var wasProvidedWithEmptyRunningEvents = false
    private(set) var runningEvents = [Event]()
    func runningEventsDidChange(to events: [Event]) {
        wasProvidedWithEmptyRunningEvents = wasProvidedWithEmptyRunningEvents || events.isEmpty
        runningEvents = events
    }

    private(set) var wasProvidedWithEmptyUpcomingEvents = false
    private(set) var upcomingEvents = [Event]()
    func upcomingEventsDidChange(to events: [Event]) {
        wasProvidedWithEmptyUpcomingEvents = wasProvidedWithEmptyUpcomingEvents || events.isEmpty
        upcomingEvents = events
    }

    private(set) var capturedFavouriteEventIdentifiers = [EventIdentifier]()
    func favouriteEventsDidChange(_ identifiers: [EventIdentifier]) {
        capturedFavouriteEventIdentifiers = identifiers
    }

}
