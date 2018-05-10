//
//  CapturingDaysUntilConventionServiceObserver.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 10/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingDaysUntilConventionServiceObserver: DaysUntilConventionServiceObserver {
    
    private(set) var capturedDaysRemaining: Int?
    func daysUntilConventionDidChange(to daysRemaining: Int) {
        capturedDaysRemaining = daysRemaining
    }
    
}
