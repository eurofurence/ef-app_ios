//
//  FoundationDateRangeFormatter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 21/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct FoundationDateRangeFormatter: DateRangeFormatter {

    static let shared = FoundationDateRangeFormatter()
    private let formatter = DateIntervalFormatter()

    private init() {
        formatter.dateTemplate = "E, d MMM HH:mm"
    }

    func string(from startDate: Date, to endDate: Date) -> String {
        return formatter.string(from: startDate, to: endDate)
    }

}
