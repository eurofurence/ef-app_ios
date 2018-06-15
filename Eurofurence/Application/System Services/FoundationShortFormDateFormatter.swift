//
//  FoundationShortFormDateFormatter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 15/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct FoundationShortFormDateFormatter: ShortFormDateFormatter {

    static let shared = FoundationShortFormDateFormatter()
    private let formatter: DateFormatter

    private init() {
        formatter = DateFormatter()
        formatter.dateFormat = "E d"
    }

    func dateString(from date: Date) -> String {
        return formatter.string(from: date)
    }

}
