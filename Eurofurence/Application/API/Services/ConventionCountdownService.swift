//
//  DaysUntilConventionService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 04/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

public protocol ConventionCountdownService {

    func add(_ observer: ConventionCountdownServiceObserver)

}

public enum ConventionCountdownState {
    case countingDown(daysUntilConvention: Int)
    case countdownElapsed
}

public protocol ConventionCountdownServiceObserver {

    func conventionCountdownStateDidChange(to state: ConventionCountdownState)

}
