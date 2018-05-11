//
//  ConventionCountdownController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 11/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

class ConventionCountdownController: SignificantTimeChangeEventObserver {

    private let conventionStartDateRepository: ConventionStartDateRepository
    private let dateDistanceCalculator: DateDistanceCalculator
    private let clock: Clock
    private var daysUntilConventionObservers = [DaysUntilConventionServiceObserver]()

    init(significantTimeChangeEventSource: SignificantTimeChangeEventSource,
         conventionStartDateRepository: ConventionStartDateRepository,
         dateDistanceCalculator: DateDistanceCalculator,
         clock: Clock) {
        self.conventionStartDateRepository = conventionStartDateRepository
        self.dateDistanceCalculator = dateDistanceCalculator
        self.clock = clock

        significantTimeChangeEventSource.add(self)
    }

    func observeDaysUntilConvention(using observer: DaysUntilConventionServiceObserver) {
        daysUntilConventionObservers.append(observer)
        let now = clock.currentDate
        let conventionStartTime = conventionStartDateRepository.conventionStartDate
        let distance = dateDistanceCalculator.calculateDays(between: now, and: conventionStartTime)
        observer.daysUntilConventionDidChange(to: distance)
    }

    func significantTimeChangeDidOccur() {
        let now = clock.currentDate
        let conventionStartTime = conventionStartDateRepository.conventionStartDate
        let distance = dateDistanceCalculator.calculateDays(between: now, and: conventionStartTime)
        daysUntilConventionObservers.forEach({ $0.daysUntilConventionDidChange(to: distance) })
    }

}
