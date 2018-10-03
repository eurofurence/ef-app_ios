//
//  Day.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 14/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct Day: Comparable {

    static func < (lhs: Day, rhs: Day) -> Bool {
        return lhs.date < rhs.date
    }

    var date: Date

}
