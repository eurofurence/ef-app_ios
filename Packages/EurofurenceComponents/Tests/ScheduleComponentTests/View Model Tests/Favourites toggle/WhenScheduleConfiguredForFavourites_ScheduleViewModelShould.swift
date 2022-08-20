import EurofurenceModel
import ScheduleComponent
import XCTest
import XCTEurofurenceModel

class WhenScheduleConfiguredForFavourites_ScheduleViewModelShould: XCTestCase {
    
    func testNotifyDelegateViewingAllEvents() throws {
        let eventsService = FakeScheduleRepository()
        eventsService.stubSomeFavouriteEvents()
        let context = ScheduleViewModelFactoryTestBuilder().with(eventsService).build()
        context.makeViewModel()
        
        let schedule = try XCTUnwrap(context.eventsService.schedule(for: "Schedule"))
        schedule.filterSchedule(to: IsFavouriteEventSpecification())

        XCTAssertEqual(.favouritesOnly, context.viewModelDelegate.favouritesfilter)
    }
    
    func testRemoveFavouriteEventsSpecificationWhenTogglingFavourites() throws {
        let eventsService = FakeScheduleRepository()
        eventsService.stubSomeFavouriteEvents()
        let context = ScheduleViewModelFactoryTestBuilder().with(eventsService).build()
        let viewModel = context.makeViewModel()
        
        let schedule = try XCTUnwrap(context.eventsService.schedule(for: "Schedule"))
        schedule.filterSchedule(to: IsFavouriteEventSpecification())
        
        viewModel?.toggleFavouriteFilteringState()
        
        XCTAssertEqual(
            AllEventsSpecification().eraseToAnySpecification(),
            schedule.specification,
            "Toggling from favourites to all events should remove the favourite event specification"
        )
    }
    
    func testDoesNotRemoveDaySpecificationWhenTogglingFavourites() throws {
        let eventsService = FakeScheduleRepository()
        eventsService.stubSomeFavouriteEvents()
        let days = [Day].random
        let currentDay = days.randomElement()
        eventsService.simulateDaysChanged(days)
        eventsService.simulateDayChanged(to: currentDay.element)
        let context = ScheduleViewModelFactoryTestBuilder().with(eventsService).build()
        let viewModel = context.makeViewModel()
        viewModel?.toggleFavouriteFilteringState()
        viewModel?.toggleFavouriteFilteringState()
        
        let schedule = try XCTUnwrap(context.eventsService.schedule(for: "Schedule"))
        let scheduleSpecification = try XCTUnwrap(schedule.specification)
        let expected = EventsOccurringOnDaySpecification(day: currentDay.element)
        XCTAssertEqual(expected.eraseToAnySpecification(), scheduleSpecification)
    }
    
    func testNotifiesDelegateViewingAllEventsWhenTogglingFilter() throws {
        let eventsService = FakeScheduleRepository()
        eventsService.stubSomeFavouriteEvents()
        let context = ScheduleViewModelFactoryTestBuilder().with(eventsService).build()
        let viewModel = context.makeViewModel()
        
        let schedule = try XCTUnwrap(context.eventsService.schedule(for: "Schedule"))
        schedule.filterSchedule(to: IsFavouriteEventSpecification())
        
        viewModel?.toggleFavouriteFilteringState()
        
        XCTAssertEqual(.allEvents, context.viewModelDelegate.favouritesfilter)
    }
    
}
