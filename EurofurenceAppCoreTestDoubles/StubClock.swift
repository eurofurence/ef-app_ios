//
//  StubClock.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 17/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import Foundation

public class StubClock: Clock {
    
    public private(set) var currentDate: Date
    
    public init(currentDate: Date = Date()) {
        self.currentDate = currentDate
    }
    
    fileprivate var delegate: ClockDelegate?
    public func setDelegate(_ delegate: ClockDelegate) {
        self.delegate = delegate
    }
    
}

public extension StubClock {
    
    public func tickTime(to time: Date) {
        currentDate = time
        delegate?.clockDidTick(to: time)
    }
    
}
