//
//  DaysUntilConventionService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 04/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

protocol DaysUntilConventionService {

    func observeDaysUntilConvention(using observer: DaysUntilConventionServiceObserver)

}

protocol DaysUntilConventionServiceObserver {

    func daysUntilConventionDidChange(to daysRemaining: Int)

}
