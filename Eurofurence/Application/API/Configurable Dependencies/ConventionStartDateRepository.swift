//
//  ConventionStartDateRepository.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 10/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

// TODO: Promote into fetching from remote config
// 1. Make acquiring start date async as-is (API change)
// 2. Add second adapter for fetching value from Firebase
protocol ConventionStartDateRepository {

    var conventionStartDate: Date { get }

}
