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
               lhs.abstract == rhs.abstract &&
               lhs.room == rhs.room &&
               lhs.startDate == rhs.startDate &&
               lhs.endDate == rhs.endDate
    }

    var title: String
    var abstract: String
    var room: Room
    var startDate: Date
    var endDate: Date

}
