//
//  WhenPreparingViewModel_ScheduleInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 13/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenPreparingViewModel_ScheduleInteractorShould: XCTestCase {
    
    var context: ScheduleInteractorTestBuilder.Context!
    var days: [Day]!
    var eventsService: CapturingEventsService!
    
    override func setUp() {
        super.setUp()
        
        days = .random
        eventsService = CapturingEventsService()
        context = ScheduleInteractorTestBuilder().with(eventsService).build()
    }
    
    func testAdaptDaysIntoViewModelsWithFriendlyDateTitles() {
        eventsService.simulateDaysChanged(days)
        let delegate = CapturingScheduleInteractorDelegate()
        context.interactor.setDelegate(delegate)
        
        let expected = days.map(context.makeExpectedDayViewModel)
        
        XCTAssertEqual(expected, delegate.daysViewModels)
    }
    
    func testInformDelegateAboutLaterDayChanges() {
        let delegate = CapturingScheduleInteractorDelegate()
        context.interactor.setDelegate(delegate)
        eventsService.simulateDaysChanged(days)
        
        let expected = days.map(context.makeExpectedDayViewModel)
        
        XCTAssertEqual(expected, delegate.daysViewModels)
    }
    
    func testProvideCurrentDayIndex() {
        let currentDay = days.randomElement()
        let context = ScheduleInteractorTestBuilder().with(eventsService).build()
        eventsService.simulateDaysChanged(days)
        eventsService.simulateDayChanged(to: currentDay.element)
        let delegate = CapturingScheduleInteractorDelegate()
        context.interactor.setDelegate(delegate)
        
        XCTAssertEqual(currentDay.index, delegate.currentDayIndex)
    }
    
    func testProvideZeroIndexWhenCurrentDayIsNotAvailable() {
        let context = ScheduleInteractorTestBuilder().build()
        let delegate = CapturingScheduleInteractorDelegate()
        context.interactor.setDelegate(delegate)
        
        XCTAssertEqual(0, delegate.currentDayIndex)
    }
    
}
