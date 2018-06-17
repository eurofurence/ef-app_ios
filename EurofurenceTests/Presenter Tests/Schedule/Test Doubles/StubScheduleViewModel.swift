//
//  CapturingScheduleViewModel.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 14/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

final class CapturingScheduleViewModel: ScheduleViewModel {
    
    var days: [ScheduleDayViewModel]
    var events: [ScheduleEventGroupViewModel]
    var currentDay: Int
    
    init(days: [ScheduleDayViewModel], events: [ScheduleEventGroupViewModel], currentDay: Int) {
        self.days = days
        self.events = events
        self.currentDay = currentDay
    }
    
    func setDelegate(_ delegate: ScheduleViewModelDelegate) {
        delegate.scheduleViewModelDidUpdateDays(days)
        delegate.scheduleViewModelDidUpdateEvents(events)
        delegate.scheduleViewModelDidUpdateCurrentDayIndex(to: currentDay)
    }
    
    private(set) var capturedDayToShowIndex: Int?
    func showEventsForDay(at index: Int) {
        capturedDayToShowIndex = index
    }
    
    fileprivate var stubbedIdentifiersByIndexPath = [IndexPath : Event2.Identifier]()
    func identifierForEvent(at indexPath: IndexPath) -> Event2.Identifier? {
        return stubbedIdentifiersByIndexPath[indexPath]
    }
    
}

extension CapturingScheduleViewModel {
    
    func stub(_ identifier: Event2.Identifier, at indexPath: IndexPath) {
        stubbedIdentifiersByIndexPath[indexPath] = identifier
    }
    
}
