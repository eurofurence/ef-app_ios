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
    private var daysUntilConventionObservers = [ConventionCountdownServiceObserver]()

    init(significantTimeChangeEventSource: SignificantTimeChangeEventSource?,
         conventionStartDateRepository: ConventionStartDateRepository,
         dateDistanceCalculator: DateDistanceCalculator,
         clock: Clock) {
        self.conventionStartDateRepository = conventionStartDateRepository
        self.dateDistanceCalculator = dateDistanceCalculator
        self.clock = clock

        significantTimeChangeEventSource?.add(self)
    }

    func observeDaysUntilConvention(using observer: ConventionCountdownServiceObserver) {
        daysUntilConventionObservers.append(observer)

        let state = resolveCountdownState()
        observer.conventionCountdownStateDidChange(to: state)
    }

    func significantTimeChangeDidOccur() {
        let state = resolveCountdownState()
        daysUntilConventionObservers.forEach({ $0.conventionCountdownStateDidChange(to: state) })
    }

    private func resolveCountdownState() -> ConventionCountdownState {
        let daysRemaining = calculateDaysUntilConvention()
        if daysRemaining > 0 {
            return .countingDown(daysUntilConvention: daysRemaining)
        } else {
            return .countdownElapsed
        }
    }

    private func calculateDaysUntilConvention() -> Int {
        let now = clock.currentDate
        let conventionStartTime = conventionStartDateRepository.conventionStartDate
        return dateDistanceCalculator.calculateDays(between: now, and: conventionStartTime)
    }

}
