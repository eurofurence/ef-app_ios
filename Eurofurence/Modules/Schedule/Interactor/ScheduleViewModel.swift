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
    func refresh()
    func showEventsForDay(at index: Int)
    func identifierForEvent(at indexPath: IndexPath) -> Event2.Identifier?
    func onlyShowFavourites()
    func showAllEvents()
    func favouriteEvent(at indexPath: IndexPath)
    func unfavouriteEvent(at indexPath: IndexPath)

}

protocol ScheduleViewModelDelegate {

    func scheduleViewModelDidBeginRefreshing()
    func scheduleViewModelDidFinishRefreshing()
    func scheduleViewModelDidUpdateDays(_ days: [ScheduleDayViewModel])
    func scheduleViewModelDidUpdateCurrentDayIndex(to index: Int)
    func scheduleViewModelDidUpdateEvents(_ events: [ScheduleEventGroupViewModel])

}
