//
//  FoundationRelativeTimeIntervalCountdownFormatter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 13/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct FoundationRelativeTimeIntervalCountdownFormatter: RelativeTimeIntervalCountdownFormatter {

    static let shared = FoundationRelativeTimeIntervalCountdownFormatter()
    private var formatter: DateComponentsFormatter

    private init() {
        formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
    }

    func relativeString(from timeInterval: TimeInterval) -> String {
        return formatter.string(from: timeInterval)!
    }

}
