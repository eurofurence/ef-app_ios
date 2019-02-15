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

    private(set) var allEvents = [EventProtocol]()
    func eventsDidChange(to events: [EventProtocol]) {
        allEvents = events
    }

    private(set) var wasProvidedWithEmptyRunningEvents = false
    private(set) var runningEvents = [EventProtocol]()
    func runningEventsDidChange(to events: [EventProtocol]) {
        wasProvidedWithEmptyRunningEvents = wasProvidedWithEmptyRunningEvents || events.isEmpty
        runningEvents = events
    }

    private(set) var wasProvidedWithEmptyUpcomingEvents = false
    private(set) var upcomingEvents = [EventProtocol]()
    func upcomingEventsDidChange(to events: [EventProtocol]) {
        wasProvidedWithEmptyUpcomingEvents = wasProvidedWithEmptyUpcomingEvents || events.isEmpty
        upcomingEvents = events
    }

    private(set) var capturedFavouriteEventIdentifiers = [EventIdentifier]()
    func favouriteEventsDidChange(_ identifiers: [EventIdentifier]) {
        capturedFavouriteEventIdentifiers = identifiers
    }

}
