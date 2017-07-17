//
//  StubClock.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 17/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

struct StubClock: Clock {
    
    var currentDate: Date
    
    init() {
        self.init(currentDate: Date())
    }
    
    init(currentDate: Date) {
        self.currentDate = currentDate
    }
    
}
