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

        let daysUntilConvention = calculateDaysUntilConvention()
        observer.daysUntilConventionDidChange(to: daysUntilConvention)
    }

    func significantTimeChangeDidOccur() {
        let daysUntilConvention = calculateDaysUntilConvention()
        daysUntilConventionObservers.forEach({ $0.daysUntilConventionDidChange(to: daysUntilConvention) })
    }

    private func calculateDaysUntilConvention() -> Int {
        let now = clock.currentDate
        let conventionStartTime = conventionStartDateRepository.conventionStartDate
        return dateDistanceCalculator.calculateDays(between: now, and: conventionStartTime)
    }

}
