//
//  CalendarStore.swift
//  Eurofurence
//
//  Created by ShezHsky on 06/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

protocol CalendarStore {

    func makeEvent() -> CalendarEvent
    func save(event: CalendarEvent)
    func reloadStore()

}
