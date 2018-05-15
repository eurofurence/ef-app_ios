//
//  Event2.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 11/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct Event2: Equatable {

    static func ==(lhs: Event2, rhs: Event2) -> Bool {
        return lhs.title == rhs.title &&
               lhs.room == rhs.room &&
               lhs.startDate == rhs.startDate &&
               lhs.secondsUntilEventBegins == rhs.secondsUntilEventBegins
    }

    var title: String
    var room: Room
    var startDate: Date
    var secondsUntilEventBegins: TimeInterval

}
