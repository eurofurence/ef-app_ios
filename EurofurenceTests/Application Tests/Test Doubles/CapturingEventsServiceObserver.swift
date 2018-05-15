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
    
    private(set) var wasProvidedWithEmptyRunningEvents = false
    private(set) var runningEvents = [Event2]()
    func eurofurenceApplicationDidUpdateRunningEvents(to events: [Event2]) {
        wasProvidedWithEmptyRunningEvents = wasProvidedWithEmptyRunningEvents || events.isEmpty
        runningEvents = events
    }
    
    func eurofurenceApplicationDidUpdateUpcomingEvents(to events: [Event2]) {
        
    }
    
}
