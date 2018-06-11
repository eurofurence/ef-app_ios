//
//  EventsService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 11/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol EventsService {

    func add(_ observer: EventsServiceObserver)
    func favouriteEvent(identifier: Event2.Identifier)
    func unfavouriteEvent(identifier: Event2.Identifier)

}

protocol EventsServiceObserver {

    func eurofurenceApplicationDidUpdateEvents(to events: [Event2])
    func eurofurenceApplicationDidUpdateRunningEvents(to events: [Event2])
    func eurofurenceApplicationDidUpdateUpcomingEvents(to events: [Event2])

}
