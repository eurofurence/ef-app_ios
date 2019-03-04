//
//  FakeAnnouncementDateFormatter.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 04/03/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class FakeAnnouncementDateFormatter: AnnouncementDateFormatter {

    private var strings = [Date: String]()

    func string(from date: Date) -> String {
        var output = String.random
        if let previous = strings[date] {
            output = previous
        } else {
            strings[date] = output
        }

        return output
    }

}
