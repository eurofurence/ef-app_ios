//
//  WhenPreparingViewModelForFavouritedEvent_ScheduleInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 03/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenPreparingViewModelForFavouritedEvent_ScheduleInteractorShould: XCTestCase {
    
    func testIndicateTheEventIsFavourited() {
        let eventsService = FakeEventsService()
        let events = [Event2].random
        let favouriteEvents = events.map({ $0.identifier })
        eventsService.allEvents = events
        eventsService.favourites = favouriteEvents
        let context = ScheduleInteractorTestBuilder().with(eventsService).build()
        context.makeViewModel()
        let eventViewModel = context.eventsViewModels.randomElement().element.events.randomElement().element
        
        XCTAssertTrue(eventViewModel.isFavourite)
    }
    
}
