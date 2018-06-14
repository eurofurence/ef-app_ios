//
//  StubScheduleViewModel.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 14/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

struct StubScheduleViewModel: ScheduleViewModel {
    
    var days: [ScheduleDayViewModel]
    var events: [ScheduleEventGroupViewModel]
    
    func setDelegate(_ delegate: ScheduleViewModelDelegate) {
        delegate.scheduleViewModelDidUpdateDays(days)
        delegate.scheduleViewModelDidUpdateEvents(events)
    }
    
}
