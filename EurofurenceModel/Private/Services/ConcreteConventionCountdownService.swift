//
//  ConcreteConventionCountdownService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 11/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EventBus
import Foundation

class ConcreteConventionCountdownService: ConventionCountdownService {

    private let conventionStartDateRepository: ConventionStartDateRepository
    private let dateDistanceCalculator: DateDistanceCalculator
    private let clock: Clock
    private var daysUntilConventionObservers = [ConventionCountdownServiceObserver]()
    
    private class RecomputeCountdownWhenSignificantTimePasses: EventConsumer {
        
        unowned let service: ConcreteConventionCountdownService
        
        init(service: ConcreteConventionCountdownService) {
            self.service = service
        }
        
        func consume(event: DomainEvent.SignificantTimePassedEvent) {
            service.refreshCountdownState()
        }
        
    }

    init(eventBus: EventBus,
         conventionStartDateRepository: ConventionStartDateRepository,
         dateDistanceCalculator: DateDistanceCalculator,
         clock: Clock) {
        self.conventionStartDateRepository = conventionStartDateRepository
        self.dateDistanceCalculator = dateDistanceCalculator
        self.clock = clock

        eventBus.subscribe(consumer: RecomputeCountdownWhenSignificantTimePasses(service: self))
    }

    func add(_ observer: ConventionCountdownServiceObserver) {
        daysUntilConventionObservers.append(observer)

        let state = resolveCountdownState()
        observer.conventionCountdownStateDidChange(to: state)
    }
    
    private func refreshCountdownState() {
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
