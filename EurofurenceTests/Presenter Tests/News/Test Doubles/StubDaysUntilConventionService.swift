//
//  StubDaysUntilConventionService.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 04/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence

class StubDaysUntilConventionService: DaysUntilConventionService {
    
    fileprivate var observers = [DaysUntilConventionServiceObserver]()
    
    fileprivate(set) var stubbedDays: Int = .random
    func observeDaysUntilConvention(using observer: DaysUntilConventionServiceObserver) {
        observer.daysUntilConventionDidChange(to: stubbedDays)
        observers.append(observer)
    }
    
}

extension StubDaysUntilConventionService {
    
    func changeDaysUntilConvention(to days: Int) {
        stubbedDays = days
        observers.forEach({ $0.daysUntilConventionDidChange(to: days) })
    }
    
}
