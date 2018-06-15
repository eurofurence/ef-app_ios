//
//  CapturingScheduleViewModel+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 13/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

extension CapturingScheduleViewModel: RandomValueProviding {
    
    static var random: CapturingScheduleViewModel {
        return CapturingScheduleViewModel(days: .random, events: .random, currentDay: .random)
    }
    
}

extension ScheduleEventGroupViewModel: RandomValueProviding {
    
    static var random: ScheduleEventGroupViewModel {
        return ScheduleEventGroupViewModel(title: .random, events: .random)
    }
    
}

extension ScheduleEventViewModel: RandomValueProviding {
    
    static var random: ScheduleEventViewModel {
        return ScheduleEventViewModel(title: .random,
                                      startTime: .random,
                                      endTime: .random,
                                      location: .random)
    }
    
}

extension ScheduleDayViewModel: RandomValueProviding {
    
    static var random: ScheduleDayViewModel {
        return ScheduleDayViewModel(title: .random)
    }
    
}
