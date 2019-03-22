//
//  FakeHoursDateFormatter.swift
//  EurofurenceModelTestDoubles
//
//  Created by Thomas Sherwood on 09/10/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import TestUtilities

class FakeHoursDateFormatter: HoursDateFormatter {

    private var strings = [Date: String]()

    func hoursString(from date: Date) -> String {
        var output = String.random
        if let previous = strings[date] {
            output = previous
        } else {
            strings[date] = output
        }

        return output
    }

}
