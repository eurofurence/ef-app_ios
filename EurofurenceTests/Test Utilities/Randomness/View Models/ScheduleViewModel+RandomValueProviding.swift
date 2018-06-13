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
        return ScheduleViewModel(days: .random, eventGroups: .random)
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
