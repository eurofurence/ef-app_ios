//
//  SystemClock.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 17/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

class SystemClock: Clock {

    static let shared = SystemClock()
    private var timer: Timer?

    private init() {
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true, block: timerFired)
    }

    var currentDate: Date {
        return Date()
    }

    private var delegate: ClockDelegate?
    func setDelegate(_ delegate: ClockDelegate) {
        self.delegate = delegate
    }

    private func timerFired(_ timer: Timer) {
        delegate?.clockDidTick(to: currentDate)
    }

}
