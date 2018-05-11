//
//  StubDaysUntilConventionService.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 04/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence

class StubConventionCountdownService: ConventionCountdownService {
    
    fileprivate var observers = [ConventionCountdownServiceObserver]()
    
    fileprivate(set) var stubbedDays: Int = .random
    func add(_ observer: ConventionCountdownServiceObserver) {
        observer.conventionCountdownStateDidChange(to: stubbedDays)
        observers.append(observer)
    }
    
}

extension StubConventionCountdownService {
    
    func changeDaysUntilConvention(to days: Int) {
        stubbedDays = days
        observers.forEach({ $0.conventionCountdownStateDidChange(to: days) })
    }
    
}
