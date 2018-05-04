//
//  StubDaysUntilConventionService.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 04/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence

class StubDaysUntilConventionService: DaysUntilConventionService {
    
    let stubbedDays: Int = .random
    func observeDaysUntilConvention(using observer: DaysUntilConventionServiceObserver) {
        observer.daysUntilConventionDidChange(to: stubbedDays)
    }
    
}
