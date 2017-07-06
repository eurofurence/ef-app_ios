//
//  CalendarEvent.swift
//  Eurofurence
//
//  Created by ShezHsky on 06/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

protocol CalendarEvent {

    var isAssociatedToCalendar: Bool { get }

    var title: String { get set }
    var notes: String { get set }
    var location: String? { get set }
    var startDate: Date { get set }
    var endDate: Date { get set }

    func addAlarm(relativeOffsetFromStartDate relativeOffset: TimeInterval)

}
