//
//  FakeDateRangeFormatter.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 21/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import Foundation

class FakeDateRangeFormatter: DateRangeFormatter {

    private struct Input: Hashable {

        var hashValue: Int {
            return start.hashValue ^ end.hashValue
        }

        static func == (lhs: FakeDateRangeFormatter.Input, rhs: FakeDateRangeFormatter.Input) -> Bool {
            return lhs.hashValue == rhs.hashValue
        }

        var start: Date
        var end: Date
    }

    private var strings = [Input: String]()
    func string(from startDate: Date, to endDate: Date) -> String {
        let input = Input(start: startDate, end: endDate)
        var string: String
        if let str = strings[input] {
            string = str
        } else {
            string = .random
        }

        strings[input] = string

        return string
    }

}
