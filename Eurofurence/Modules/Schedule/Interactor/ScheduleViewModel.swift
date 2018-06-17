//
//  ScheduleViewModel.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 13/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol ScheduleViewModel {

    func setDelegate(_ delegate: ScheduleViewModelDelegate)
    func showEventsForDay(at index: Int)
    func identifierForEvent(at indexPath: IndexPath) -> Event2.Identifier?

}

protocol ScheduleViewModelDelegate {

    func scheduleViewModelDidUpdateDays(_ days: [ScheduleDayViewModel])
    func scheduleViewModelDidUpdateCurrentDayIndex(to index: Int)
    func scheduleViewModelDidUpdateEvents(_ events: [ScheduleEventGroupViewModel])

}
