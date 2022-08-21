import EurofurenceModel
import ScheduleComponent
import XCTest
import XCTEurofurenceModel

class WhenScheduleNotConfiguredForFavourites_ScheduleViewModelShould: XCTestCase {

    func testNotifyDelegateViewingAllEvents() {
        let eventsService = FakeScheduleRepository()
        eventsService.stubSomeFavouriteEvents()
        let context = ScheduleViewModelFactoryTestBuilder().with(eventsService).build()
        context.makeViewModel()

        XCTAssertEqual(.allEvents, context.viewModelDelegate.favouritesfilter)
    }
    
    func testApplyFavouriteEventsSpecificationWhenTogglingFavourites() throws {
        let eventsService = FakeScheduleRepository()
        eventsService.stubSomeFavouriteEvents()
        let context = ScheduleViewModelFactoryTestBuilder().with(eventsService).build()
        let viewModel = context.makeViewModel()
        viewModel?.toggleFavouriteFilteringState()
        
        let schedule = try XCTUnwrap(context.eventsService.schedule(for: "Schedule"))
        let scheduleSpecification = try XCTUnwrap(schedule.specification)
        XCTAssertTrue(
            scheduleSpecification.contains(IsFavouriteEventSpecification.self),
            "Toggling from all events to favourites should apply favourite event specification"
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
        
        let schedule = try XCTUnwrap(context.eventsService.schedule(for: "Schedule"))
        let scheduleSpecification = try XCTUnwrap(schedule.specification)
        let expected = EventsOccurringOnDaySpecification(day: currentDay.element) && IsFavouriteEventSpecification()
        XCTAssertEqual(expected.eraseToAnySpecification(), scheduleSpecification)
    }
    
    func testRetainFavouriteSpecificationFilteringWhenCurrentDayChanges() throws {
        let eventsService = FakeScheduleRepository()
        eventsService.stubSomeFavouriteEvents()
        let days = [Day].random
        let currentDay = days.randomElement()
        eventsService.simulateDaysChanged(days)
        let context = ScheduleViewModelFactoryTestBuilder().with(eventsService).build()
        let viewModel = context.makeViewModel()
        viewModel?.toggleFavouriteFilteringState()
        eventsService.simulateDayChanged(to: currentDay.element)
        
        let schedule = try XCTUnwrap(context.eventsService.schedule(for: "Schedule"))
        let scheduleSpecification = try XCTUnwrap(schedule.specification)
        let expected = EventsOccurringOnDaySpecification(day: currentDay.element) && IsFavouriteEventSpecification()
        XCTAssertEqual(expected.eraseToAnySpecification(), scheduleSpecification)
    }

}
