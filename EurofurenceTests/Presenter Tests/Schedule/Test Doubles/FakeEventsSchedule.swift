//
//  FakeEventsSchedule.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 15/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class FakeEventsSchedule: EventsSchedule {
    
    private(set) var dayUsedToRestrictEvents: Day?
    func restrictEvents(to day: Day) {
        dayUsedToRestrictEvents = day
    }
    
}
