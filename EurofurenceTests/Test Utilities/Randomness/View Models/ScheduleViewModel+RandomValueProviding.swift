//
//  ScheduleViewModel+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 13/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

extension ScheduleViewModel: RandomValueProviding {
    
    static var random: ScheduleViewModel {
        return ScheduleViewModel(eventsPerGroup: .random(minimum: 1))
    }
    
}
