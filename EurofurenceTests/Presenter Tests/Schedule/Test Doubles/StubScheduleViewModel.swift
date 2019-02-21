//
//  CapturingScheduleViewModel.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 14/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import Foundation
import TestUtilities

final class CapturingScheduleViewModel: ScheduleViewModel {

    var days: [ScheduleDayViewModel]
    var events: [ScheduleEventGroupViewModel]
    var currentDay: Int

    init(days: [ScheduleDayViewModel], events: [ScheduleEventGroupViewModel], currentDay: Int) {
        self.days = days
        self.events = events
        self.currentDay = currentDay
    }

    private(set) var delegate: ScheduleViewModelDelegate?
    func setDelegate(_ delegate: ScheduleViewModelDelegate) {
        self.delegate = delegate
        delegate.scheduleViewModelDidUpdateDays(days)
        delegate.scheduleViewModelDidUpdateEvents(events)
        delegate.scheduleViewModelDidUpdateCurrentDayIndex(to: currentDay)
    }

    private(set) var didPerformRefresh = false
    func refresh() {
        didPerformRefresh = true
    }

    private(set) var capturedDayToShowIndex: Int?
    func showEventsForDay(at index: Int) {
        capturedDayToShowIndex = index
    }

    fileprivate var stubbedIdentifiersByIndexPath = [IndexPath: EventIdentifier]()
    func identifierForEvent(at indexPath: IndexPath) -> EventIdentifier? {
        return stubbedIdentifiersByIndexPath[indexPath]
    }

    private(set) var toldToFilterToFavouritesOnly = false
    func onlyShowFavourites() {
        toldToFilterToFavouritesOnly = true
    }

    private(set) var toldToShowAllEvents = false
    func showAllEvents() {
        toldToShowAllEvents = true
    }

    private(set) var indexPathForFavouritedEvent: IndexPath?
    func favouriteEvent(at indexPath: IndexPath) {
        indexPathForFavouritedEvent = indexPath
    }

    private(set) var indexPathForUnfavouritedEvent: IndexPath?
    func unfavouriteEvent(at indexPath: IndexPath) {
        indexPathForUnfavouritedEvent = indexPath
    }

}

extension CapturingScheduleViewModel {

    func eventViewModel(inGroup group: Int, at index: Int) -> StubScheduleEventViewModel {
        return events[group].events[index] as! StubScheduleEventViewModel
    }

    func stub(_ identifier: EventIdentifier, at indexPath: IndexPath) {
        stubbedIdentifiersByIndexPath[indexPath] = identifier
    }

    func simulateScheduleRefreshDidBegin() {
        delegate?.scheduleViewModelDidBeginRefreshing()
    }

    func simulateScheduleRefreshDidFinish() {
        delegate?.scheduleViewModelDidFinishRefreshing()
    }

}
