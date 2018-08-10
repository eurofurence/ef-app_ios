//
//  FoundationShortFormDayAndTimeFormatter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 18/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct FoundationShortFormDayAndTimeFormatter: ShortFormDayAndTimeFormatter {

    static let shared = FoundationShortFormDayAndTimeFormatter()
    private let formatter: DateFormatter

    private init() {
        formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
    }

    func dayAndHoursString(from date: Date) -> String {
        return formatter.string(from: date)
    }

}
