//
//  EventKitCalendarPermissionsProviding.swift
//  Eurofurence
//
//  Created by ShezHsky on 06/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import EventKit
import Foundation

struct EventKitCalendarPermissionsProviding: CalendarPermissionsProviding {

    var eventStore: EKEventStore

    var isAuthorizedForEventsAccess: Bool {
        return EKEventStore.authorizationStatus(for: EKEntityType.event) == .authorized
    }

    func requestAccessToEvents(completionHandler: @escaping (Bool) -> Void) {
        eventStore.requestAccess(to: .event) { (authorized, _) in
            completionHandler(authorized)
        }
    }

}
