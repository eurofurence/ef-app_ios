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
    
}
