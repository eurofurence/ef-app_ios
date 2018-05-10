//
//  EF24StartDateRepository.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 10/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct EF24StartDateRepository: ConventionStartDateRepository {

    var conventionStartDate: Date {
        let components = DateComponents(calendar: .current,
                                        timeZone: TimeZone(secondsFromGMT: 0)!,
                                        year: 2018,
                                        month: 9,
                                        day: 22)
        return components.date!
    }

}
