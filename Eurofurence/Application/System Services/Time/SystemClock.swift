//
//  SystemClock.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 17/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

struct SystemClock: Clock {

    var currentDate: Date {
        return Date()
    }

    func setDelegate(_ delegate: ClockDelegate) {

    }

}
