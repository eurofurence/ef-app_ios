//
//  DaysUntilConventionService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 04/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

protocol ConventionCountdownService {

    func add(_ observer: ConventionCountdownServiceObserver)

}

protocol ConventionCountdownServiceObserver {

    func conventionCountdownStateDidChange(to daysRemaining: Int)

}
