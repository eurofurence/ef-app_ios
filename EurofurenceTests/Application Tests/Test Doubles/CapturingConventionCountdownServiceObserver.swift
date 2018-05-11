//
//  CapturingDaysUntilConventionServiceObserver.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 10/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingConventionCountdownServiceObserver: ConventionCountdownServiceObserver {
    
    private(set) var capturedDaysRemaining: Int?
    func conventionCountdownStateDidChange(to state: ConventionCountdownState) {
        switch state {
        case .countingDown(let daysRemaining):
            capturedDaysRemaining = daysRemaining
            
        case .countdownElapsed:
            break
        }
    }
    
}
