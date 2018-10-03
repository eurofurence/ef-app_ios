//
//  Clock.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 17/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

public protocol Clock {

    var currentDate: Date { get }
    func setDelegate(_ delegate: ClockDelegate)

}

public protocol ClockDelegate {

    func clockDidTick(to time: Date)

}
