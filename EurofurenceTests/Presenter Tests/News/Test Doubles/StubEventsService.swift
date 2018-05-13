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
    
    func add(_ observer: EventsServiceObserver) {
        observer.eurofurenceApplicationDidUpdateRunningEvents(to: runningEvents)
    }
    
}
