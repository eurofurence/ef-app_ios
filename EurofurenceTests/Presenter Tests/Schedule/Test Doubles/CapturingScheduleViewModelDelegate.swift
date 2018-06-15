//
//  CapturingScheduleViewModelDelegate.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 13/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingScheduleViewModelDelegate: ScheduleViewModelDelegate {
    
    private(set) var daysViewModels: [ScheduleDayViewModel] = []
    func scheduleViewModelDidUpdateDays(_ days: [ScheduleDayViewModel]) {
        daysViewModels = days
    }
    
    private(set) var currentDayIndex: Int?
    func scheduleViewModelDidUpdateCurrentDayIndex(to index: Int) {
        currentDayIndex = index
    }
    
    private(set) var eventsViewModels: [ScheduleEventGroupViewModel] = []
    func scheduleViewModelDidUpdateEvents(_ events: [ScheduleEventGroupViewModel]) {
        eventsViewModels = events
    }
    
}
