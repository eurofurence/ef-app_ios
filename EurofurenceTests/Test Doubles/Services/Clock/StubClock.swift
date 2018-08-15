//
//  StubClock.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 17/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class StubClock: Clock {
    
    var currentDate: Date
    
    init(currentDate: Date = Date()) {
        self.currentDate = currentDate
    }
    
    fileprivate var delegate: ClockDelegate?
    func setDelegate(_ delegate: ClockDelegate) {
        self.delegate = delegate
    }
    
}

extension StubClock {
    
    func tickTime(to time: Date) {
        currentDate = time
        delegate?.clockDidTick(to: time)
    }
    
}
