//
//  CapturingScheduleInteractorDelegate.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 13/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingScheduleInteractorDelegate: ScheduleInteractorDelegate, ScheduleViewModelDelegate {
    
    private(set) var viewModel: ScheduleViewModel?
    func scheduleInteractorDidPrepareViewModel(_ viewModel: ScheduleViewModel) {
        self.viewModel = viewModel
        viewModel.setDelegate(self)
    }
    
    private(set) var daysViewModels: [ScheduleDayViewModel] = []
    func scheduleViewModelDidUpdateDays(_ days: [ScheduleDayViewModel]) {
        daysViewModels = days
    }
    
    private(set) var eventsViewModels: [ScheduleEventGroupViewModel] = []
    func scheduleViewModelDidUpdateEvents(_ events: [ScheduleEventGroupViewModel]) {
        eventsViewModels = events
    }
    
}
